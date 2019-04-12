//
//  FullDetailViewController.swift
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

import UIKit

class FullDetailViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var textView: UITextView!
    
    var text: String!
    var searchText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        textView.text = text
        
        searchBar.barTintColor = Colors.NavigationBar.lightBlue
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = Colors.NavigationBar.lightBlue.cgColor
        
        if let searchText = searchText {
            searchBar.text = searchText
            textView.attributedText = textView.text.highlight(searchText: searchText)
        }
    }
}

extension FullDetailViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        textView.attributedText = textView.text.highlight(searchText: searchText)
    }
}
