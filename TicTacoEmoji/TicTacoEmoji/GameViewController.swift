//
//  ViewController.swift
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

class GameViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet private weak var tileViewContainerView: TileGridContainerView?
    @IBOutlet private weak var playerXButton: UIButton?
    @IBOutlet private weak var playerOButton: UIButton?
    
    // MARK: Properties
    
    private var gridSize = 3
    private var gameState = GameState(gridSize: 0) {
        didSet {
            switch self.gameState.result {
            case .NoWinner(let currentPlayer):
                self.updateUIForCurrentPlayer(currentPlayer)
            case .Draw:
                self.presentDrawAlert()
            case .Win(let winner):
                self.scores.incrementScoreForWinner(winner)
                self.presentWinAlertForWinner(winner)
            }
        }
    }
    private var scores = ScoreKeeper(O: 0, X: 0) {
        didSet {
            self.title = self.scores.stringValue
        }
    }
    
    // MARK: Basic Gameplay
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scores = ScoreKeeper(O: 0, X: 0)
    }
    
    private func startNewGame() {
        self.tileViewContainerView?.removeAllTileViews()
        self.gameState = GameState(gridSize: self.gridSize)
        self.tileViewContainerView?.generateTileViewsWithGridSize(gridSize, withTarget: self, andAction: "tileTapped:")
        self.tileViewContainerView?.updateViewsWithGameState(self.gameState)
    }
    
    private func updateUIForCurrentPlayer(currentPlayer: TileOwnership) {
        UIView.animateWithDuration(0.3,
            delay: 0.0,
            usingSpringWithDamping: 0.4,
            initialSpringVelocity: 1.5,
            options: [.AllowUserInteraction],
            animations: {
                switch currentPlayer {
                case .X:
                    self.playerXButton?.alpha = 1.0
                    self.playerOButton?.alpha = 0.3
                    self.playerXButton?.transform = CGAffineTransformIdentity
                    self.playerOButton?.transform = CGAffineTransformMakeScale(0.5, 0.5)
                case .O:
                    self.playerOButton?.alpha = 1.0
                    self.playerXButton?.alpha = 0.3
                    self.playerOButton?.transform = CGAffineTransformIdentity
                    self.playerXButton?.transform = CGAffineTransformMakeScale(0.5, 0.5)
                case .Unclaimed:
                    fatalError()
                }
            },
            completion: { success in
            }
        )
    }
    
    @objc private func tileTapped(sender: TileButtonView?) {
        guard let tileButton = sender else { return }
        let indexPath = tileButton.location
        let oldOwnership = self.gameState.stateForIndexPath(indexPath)
        guard oldOwnership == .Unclaimed else { return }
        
        switch self.gameState.result {
        case .NoWinner(let currentPlayer):
            switch currentPlayer {
            case .X:
                self.gameState.setTileOwnership(.X, forIndexPath: indexPath)
                self.tileViewContainerView!.updateViewsWithGameState(self.gameState)
            case .O:
                self.gameState.setTileOwnership(.O, forIndexPath: indexPath)
                self.tileViewContainerView!.updateViewsWithGameState(self.gameState)
            case .Unclaimed:
                fatalError()
            }
            
            // add fun animation
            let originalBorderColor = tileButton.layer.borderColor
            UIView.animateWithDuration(0.3,
                delay: 0.0,
                usingSpringWithDamping: 0.4,
                initialSpringVelocity: 1.5,
                options: [.Autoreverse, .AllowUserInteraction],
                animations: {
                    tileButton.transform = CGAffineTransformMakeScale(2.0, 2.0)
                    tileButton.layer.borderColor = UIColor.clearColor().CGColor
                },
                completion: { success in
                    tileButton.transform = CGAffineTransformIdentity
                    tileButton.layer.borderColor = originalBorderColor
                }
            )
        default:
            break
        }
    }
    
    // MARK: Game Ending Alerts
    
    private func presentDrawAlert() {
        let drawVC = UIAlertController(title: "Draw", message: .None, preferredStyle: .Alert)
        let newGameAction = UIAlertAction(title: "Start New Game", style: .Default) { action in
            self.startNewGame()
        }
        let dismissAction = UIAlertAction(title: "Dismiss", style: .Cancel, handler: .None)
        drawVC.addAction(newGameAction)
        drawVC.addAction(dismissAction)
        self.presentViewController(drawVC, animated: true, completion: .None)
    }
    
    private func presentWinAlertForWinner(winner: TileOwnership) {
        let winnerString: String
        switch winner {
        case .O:
            winnerString = "⭕️, You won! Good work!"
        case .X:
            winnerString = "❎, You won! Good work!"
        case .Unclaimed:
            fatalError()
        }
        let drawVC = UIAlertController(title: "🎊 Win 🎉", message: winnerString, preferredStyle: .Alert)
        let newGameAction = UIAlertAction(title: "Start New Game", style: .Default) { action in
            self.startNewGame()
        }
        let dismissAction = UIAlertAction(title: "Dismiss", style: .Cancel, handler: .None)
        drawVC.addAction(newGameAction)
        drawVC.addAction(dismissAction)
        self.presentViewController(drawVC, animated: true, completion: .None)
    }
    
    // MARK: Extras
    
    @IBAction private func startNewGameButtonTapped(sender: UIBarButtonItem?) {
        self.startNewGame()
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue?) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        let navVC = segue?.destinationViewController as? UINavigationController
        let destVC = navVC?.viewControllers.first as? GridPickerViewController
        destVC?.gridSize = self.gridSize
        destVC?.delegate = self
    }
    
    private struct ScoreKeeper {
        var O: Int
        var X: Int
        
        mutating func incrementScoreForWinner(winner: TileOwnership) {
            switch winner {
            case .O:
                self.O += 1
            case .X:
                self.X += 1
            case .Unclaimed:
                fatalError()
            }
        }
        
        var stringValue: String {
            return "❎  \(self.X)  –  \(self.O)  ⭕️"
        }
    }
    
}

extension GameViewController: GridPickable {
    func picker(picker: GridPickerViewController, didPickGrid gridSize: Int) {
        self.gridSize = gridSize
        self.startNewGame()
    }
}

