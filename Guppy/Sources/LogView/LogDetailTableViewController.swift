//
//  LogDetailTableViewController.swift
//
//  Copyright © 2019 Johnson & Johnson
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

class LogDetailTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedRow: Row!
    var filteredSections: [CollapsibleSection<Row>] = []
    var collapsibleSections: [CollapsibleSection<Row>] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
        setUpSearchController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        FileManager.default.clearGuppyLog()
    }
    
    func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableFooterView = UIView()
        
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 70
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 140
        
        tableView.register(CollapsibleHeaderView.self)
        tableView.register(LogDetailTableViewCell.self)
    }
    
    private func setUpSearchController() {
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchResultsUpdater = self
        searchController.searchBar.tintColor = .white

        definesPresentationContext = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: FullDetailViewController.self) {
            if let fullDetailTableViewController = segue.destination as? FullDetailViewController {
                fullDetailTableViewController.text = selectedRow?.title
                fullDetailTableViewController.searchText = searchController.searchBar.text
            }
        }
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        shareText(collapsibleSections.prettyPrint())
    }
}

// MARK: Share Log Details
extension LogDetailTableViewController {
    
    fileprivate func shareText(_ sharedText: String) {
        let activityVC = UIActivityViewController(activityItems: [AirDropTextDataSource(with: sharedText)], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = tableView
        self.present(activityVC, animated: true, completion: nil)
    }
}

// MARK: UITableViewDataSource
extension LogDetailTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isFiltering() ? filteredSections.count : collapsibleSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tableSections = isFiltering() ? filteredSections : collapsibleSections
        let numberOfRows = tableSections[section].isCollapsed ? 0 : tableSections[section].rows.count
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LogDetailTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        let tableSections = isFiltering() ? filteredSections : collapsibleSections
        let row = tableSections[indexPath.section].rows[indexPath.row]
        
        if isFiltering() {
            if let searchText = searchController.searchBar.text {
                cell.setUp(withAttributed: row.title.highlight(searchText: searchText))
            }
        } else {
            cell.setUp(with: row.title)
        }
        
        return cell
    }
}

// MARK: UITableViewDelegate
extension LogDetailTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: CollapsibleHeaderView = tableView.dequeueReusableCell()
        let tableSections = isFiltering() ? filteredSections : collapsibleSections
        
        let collapsibleSection = tableSections[section]
        
        headerView.setUp(with: collapsibleSection.title, at: section, isCollapsed: collapsibleSection.isCollapsed)
        headerView.delegate = self
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let tableSections = isFiltering() ? filteredSections : collapsibleSections
        selectedRow = tableSections[indexPath.section].rows[indexPath.row]
        
        performSegue(withIdentifier: String(describing: FullDetailViewController.self), sender: self)
    }
}

// MARK: UISearchResultsUpdating
extension LogDetailTableViewController: UISearchResultsUpdating {
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            assertionFailure("SearchBar not unwrapped")
            return
        }
        
        let quotedSearchText = searchText.lowercased().escapeQuotes()
        filteredSections = collapsibleSections.filter { sections in
            let rows = sections.rows.filter { $0.title.lowercased().matches(quotedSearchText) }
            return !rows.isEmpty
        }
        tableView.reloadData()
    }
}

// MARK: CollapsibleHeaderDelegate
extension LogDetailTableViewController: CollapsibleHeaderDelegate {
    
    func toggleSection(at index: Int) {
        var sections = isFiltering() ? filteredSections : collapsibleSections
        sections[index].isCollapsed = !sections[index].isCollapsed
        
        tableView.beginUpdates()
        
        if sections[index].isCollapsed {
            tableView.deleteRows(at: indexPaths(for: index, in: sections), with: .top)
        } else {
            tableView.insertRows(at: indexPaths(for: index, in: sections), with: .top)
        }
        
        tableView.endUpdates()
    }
    
    func indexPaths(for sectionIndex: Int, in section: [CollapsibleSection<Row>]) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        
        for i in 0..<section[sectionIndex].rows.count {
            indexPaths.append(IndexPath(row: i, section: sectionIndex))
        }
        
        return indexPaths
    }
}
