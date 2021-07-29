//
//  CollapsibleHeaderView.swift
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

import Foundation
import UIKit

protocol CollapsibleHeaderDelegate: AnyObject {
    
    func toggleSection(at index: Int)
}

class CollapsibleHeaderView: UITableViewHeaderFooterView, NibLoadableView {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var arrowImageView: UIImageView!
    
    let collapsedAngle = CGFloat.pi * 3 / 2
    let uncollapsedAngle = CGFloat.zero
    
    weak var delegate: CollapsibleHeaderDelegate?
    var isCollapsed: Bool!
    var index: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedTitle))
        addGestureRecognizer(tapGesture)
    }
    
    func setUp(with title: String, at index: Int, isCollapsed: Bool, backgroundColor: UIColor = Colors.Cell.backgroundBlue) {
        titleLabel.text = title
        self.isCollapsed = isCollapsed
        self.index = index
        
        updateChevron(isCollapsed: isCollapsed)
        contentView.backgroundColor = backgroundColor
    }
    
    @objc func tappedTitle() {
        isCollapsed.toggle()
        updateChevron(isCollapsed: isCollapsed)
        
        delegate?.toggleSection(at: index)
    }
    
    private func updateChevron(isCollapsed: Bool) {
        let angle = isCollapsed ? collapsedAngle : uncollapsedAngle
        arrowImageView.transform = CGAffineTransform(rotationAngle: angle)
    }
}
