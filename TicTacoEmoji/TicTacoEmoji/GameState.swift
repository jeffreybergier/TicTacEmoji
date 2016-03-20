//
//  GameState.swift
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

import Foundation

struct GameState { // This probably could be a class at this point, but struct helps control mutability.
    
    private(set) var result = GameResult.NoWinner(currentPlayer: .X)
    private var state: [[TileOwnership]]
    
    init(gridSize: Int) {
        var state = [[TileOwnership]]()
        for _ in 0 ..< gridSize {
            var section = [TileOwnership]()
            for _ in 0 ..< gridSize {
                section += [.Unclaimed]
            }
            state += [section]
        }
        self.state = state
    }
    
    func stateForIndexPath(indexPath: NSIndexPath) -> TileOwnership {
        return self.state[indexPath.section][indexPath.row]
    }
    
    mutating func setTileOwnership(tileOwnership: TileOwnership, forIndexPath indexPath: NSIndexPath) {
        let nonWinningPlayer: TileOwnership?
        switch self.result {
        case .NoWinner(let oldPlayer):
            nonWinningPlayer = oldPlayer
        default:
            nonWinningPlayer = .None
        }
        
        // verify that the game is in a NoWin state
        // if the game has already been won, nothing should change
        guard let oldPlayer = nonWinningPlayer else { return }
        
        // update the state of the game
        self.state[indexPath.section][indexPath.row] = tileOwnership
        
        // scan the board to see if there is a winner
        if let winningScan = self.scanStateForWinners() {
            self.result = winningScan
        } else {
            // if there is no winner, see if its a draw
            if self.allTilesOwned == true {
                self.result = .Draw
            } else {
                // if its not a draw then change the player
                switch oldPlayer {
                case .X:
                    self.result = .NoWinner(currentPlayer: .O)
                case .O:
                    self.result = .NoWinner(currentPlayer: .X)
                case .Unclaimed:
                    fatalError()
                }
            }
        }
    }
}

extension GameState {
    
    private var allTilesOwned: Bool {
        let flattendTiles = Array(self.state.flatten())
        let unownedTiles = flattendTiles.filter() { ownership -> Bool in
            switch ownership {
            case .O, .X:
                return false
            case .Unclaimed:
                return true
            }
        }
        
        if unownedTiles.count == 0 { return true } else { return false }
    }

    private func scanStateForWinners() -> GameResult? {
        let ownership: TileOwnership?
        if let cross = self.crossGameResultRight(true) {
            ownership = cross
        } else if let cross = self.crossGameResultRight(false) {
            ownership = cross
        } else if let horizontal = self.horizontalGameResult() {
            ownership = horizontal
        } else if let vertical = self.verticalGameResult() {
            ownership = vertical
        } else {
            ownership = Optional.None
        }
        
        if let ownership = ownership {
            switch ownership {
            case .O:
                return .Win(.O)
            case .X:
                return .Win(.X)
            default:
                break
            }
        }
        
        return .None
    }
    
    private func gameResultFromSet(ownershipSet: Set<TileOwnership>) -> TileOwnership? {
        if let ownership = ownershipSet.first where ownershipSet.count == 1 && ownership != .Unclaimed {
            return ownership
        }
        return .None
    }
    
    private func horizontalGameResult() -> TileOwnership? {
        for sectionOwnerships in self.state {
            let reduced = Set(sectionOwnerships)
            if let result = self.gameResultFromSet(reduced) {
                return result
            }
        }
        return .None
    }
    
    private func verticalGameResult() -> TileOwnership? {
        for row in 0 ..< self.state.count {
            var rowSet = Set<TileOwnership>()
            for section in 0 ..< self.state.count {
                let ownership = self.state[section][row]
                rowSet.insert(ownership)
            }
            if let result = self.gameResultFromSet(rowSet) {
                return result
            }
        }
        return .None
    }
    
    private func crossGameResultRight(right: Bool) -> TileOwnership? {
        var rowSet = Set<TileOwnership>()
        let count = self.state.count
        for index in 0 ..< count {
            let reverseIndex = right == true ? index : abs(index - (count - 1))
            let ownership = self.state[index][reverseIndex]
            rowSet.insert(ownership)
        }
        if let result = self.gameResultFromSet(rowSet) {
            return result
        }
        return .None
    }
}
