//
//  TileGridContainerView.swift
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

class TileGridContainerView: UIView {
    
    private var tileViews: [[TileButtonView]]?
    private var mainStackView: UIStackView?
    
    func removeAllTileViews() {
        self.mainStackView?.removeFromSuperview()
        self.mainStackView = .None
        self.tileViews = .None
    }
    
    func updateViewsWithGameState(gameState: GameState) {
        guard let tileViews = self.tileViews else { return }
        for (section, sectionViews) in tileViews.enumerate() {
            for (row, rowView) in sectionViews.enumerate() {
                rowView.ownership = gameState.stateForIndexPath(NSIndexPath(forRow: row, inSection: section))
            }
        }
    }
    
    func generateTileViewsWithGridSize(gridSize: Int, withTarget target: AnyObject, andAction action: Selector) {
        let tiles = TileButtonView.tileViewsForGridSize(gridSize, withTarget: target, andAction: action)
        self.insertViewArray(tiles)
    }
    
    private func insertViewArray(viewArray: [[TileButtonView]]) {
        self.tileViews = viewArray
        let mainStackView = UIStackView(gridFromViewArray: viewArray)
        self.mainStackView = mainStackView
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(mainStackView)
        mainStackView.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 0).active = true
        mainStackView.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: 0).active = true
        mainStackView.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 0).active = true
        mainStackView.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: 0).active = true
    }
}