//
//  LogTableViewController.swift
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

class LogTableViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView?
    
    var logItems: [LogItem] = [] {
        didSet {
            domainSections = LogTableViewBuilder.getDomainSections(from: logItems, in: domainSections)
            tableView?.reloadData()
        }
    }
    
    var selectedLogItem: LogItem!
    var domainSections: [CollapsibleSection<LogItem>] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
    }
    
    func setUpTableView() {
        guard let tableView = tableView else {
            assertionFailure("tableView is unexpectedly nil")
            return
        }

        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableFooterView = UIView()

        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 70
        tableView.register(CollapsibleHeaderView.self)
        tableView.register(SessionLogItemTableViewCell.self)
    }
    
    @IBAction private func removeLogs() {
        Guppy.shared.removeAllLogs()
    }

    @IBAction private func closePressed() {
        dismiss(animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: LogDetailTableViewController.self) {
            
            let sessions = LogTableViewBuilder.getSections(from: selectedLogItem as! Session)
            
            let logDetailTableViewController = segue.destination as! LogDetailTableViewController
            logDetailTableViewController.collapsibleSections = sessions
        }
    }
}

// MARK: UITableViewDataSource
extension LogTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return domainSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = domainSections[section].isCollapsed ? 0 : domainSections[section].rows.count
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SessionLogItemTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        
        cell.setUp(domainSections[indexPath.section].rows[indexPath.row] as! LogItem & Session)
        
        return cell
    }
}

// MARK: UITableViewDelegate
extension LogTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: CollapsibleHeaderView = tableView.dequeueReusableCell()
        
        let domainSection = domainSections[section]
        let domainString = URL(string: domainSection.title)?.host ?? domainSection.title
        
        headerView.setUp(with: domainString, at: section, isCollapsed: domainSection.isCollapsed)
        headerView.delegate = self
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedLogItem = domainSections[indexPath.section].rows[indexPath.row]
        
        performSegue(withIdentifier: String(describing: LogDetailTableViewController.self), sender: self)
    }
}

// MARK: CollapsibleHeaderDelegate
extension LogTableViewController: CollapsibleHeaderDelegate {
    
    func toggleSection(at index: Int) {
        domainSections[index].isCollapsed = !domainSections[index].isCollapsed

        tableView?.beginUpdates()

        if domainSections[index].isCollapsed {
            tableView?.deleteRows(at: indexPaths(for: index), with: .top)
        } else {
            tableView?.insertRows(at: indexPaths(for: index), with: .top)
        }

        tableView?.endUpdates()
    }

    func indexPaths(for section: Int) -> [IndexPath] {
        var indexPaths = [IndexPath]()

        for i in 0..<domainSections[section].rows.count {
            indexPaths.append(IndexPath(row: i, section: section))
        }

        return indexPaths
    }
}
