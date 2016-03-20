//
//  GameModelTypes.swift
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

enum TileOwnership {
    case Unclaimed, X, O
}

enum GameResult: Equatable {
    case NoWinner(currentPlayer: TileOwnership), Draw, Win(TileOwnership)
}

func ==(lhs: GameResult, rhs: GameResult) -> Bool {
    switch lhs {
    case .NoWinner:
        switch rhs {
        case .NoWinner:
            return true
        default:
            return false
        }
    case .Draw:
        switch rhs {
        case .Draw:
            return true
        default:
            return false
        }
    case .Win(let lhsPlayer):
        switch rhs {
        case .Win(let rhsPlayer):
            if lhsPlayer == rhsPlayer {
                return true
            } else {
                return false
            }
        default:
            return false
        }
    }
}