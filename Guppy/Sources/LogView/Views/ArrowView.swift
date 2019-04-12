//
//  ArrowView.swift
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

class ArrowView: UIView {

    override func draw(_ rect: CGRect) {
        UIColor.white.setStroke()

        let bezierPath = UIBezierPath()
        bezierPath.lineWidth = 2.0
        bezierPath.lineJoinStyle = .round

        // Inset the rect vertically so the bezier path join doesn't get cut off
        let insetRect = rect.insetBy(dx: 0.0, dy: 2.0)

        bezierPath.move(to: insetRect.origin)
        bezierPath.addLine(to: CGPoint(x: rect.midX, y: insetRect.height))
        bezierPath.addLine(to: CGPoint(x: rect.width, y: insetRect.origin.y))
        
        bezierPath.stroke()
    }
}
