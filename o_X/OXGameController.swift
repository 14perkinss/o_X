//
//  OXGameController.swift
//  o_X
//
//  Created by Sam Perkins on 6/29/16.
//  Copyright © 2016 iX. All rights reserved.
//

import UIKit


class OXGameController {
    static let sharedInstance = OXGameController()
    private var currentGame = OXGame()
    private init() {}
    func getCurrentGame() -> OXGame {
        return currentGame
    }
    
    func restartGame() {
        
        currentGame.reset()
    }
    
    func playMove(cell: Int) {
        currentGame.playMove(cell)
    }
    
    func getGames(onCompletion onCompletion: ([OXGame]?, String?) -> Void) {
         onCompletion([OXGame(), OXGame()], nil)
    }

}
