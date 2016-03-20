//
//  TileButtonView.swift
//  TicTacoEmoji
//
//  Created by Jeffrey Bergier on 3/20/16.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2016 jeffreybergier
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit

class TileButtonView: UIButton {
    
    let location: NSIndexPath
    
    var ownership = TileOwnership.Unclaimed {
        didSet {
            switch self.ownership {
            case .Unclaimed:
                self.setTitle("", forState: .Normal)
            case .X:
                self.setTitle("❎", forState: .Normal)
            case .O:
                self.setTitle("⭕️", forState: .Normal)
            }
        }
    }
    
    init(location: NSIndexPath) {
        self.location = location
        super.init(frame: CGRect.zero)
        self.titleLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("required init coder: kmn")
    }
    
    static func tileViewsForGridSize(gridSize: Int, withTarget target: AnyObject, andAction action: Selector) -> [[TileButtonView]] {
        var tileViews = [[TileButtonView]]()
        for heightIndex in 0 ..< gridSize {
            var row = [TileButtonView]()
            for widthIndex in 0 ..< gridSize {
                let indexPath = NSIndexPath(forItem: widthIndex, inSection: heightIndex)
                let tileView = TileButtonView(location: indexPath)
                tileView.addTarget(target, action: action, forControlEvents: .TouchUpInside)
                row += [tileView]
            }
            tileViews += [row]
        }
        return tileViews
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
    }
}
