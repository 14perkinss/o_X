//
//  OXGame.swift
//  o_X
//
//  Created by Sam Perkins on 6/29/16.
//  Copyright © 2016 iX. All rights reserved.
//

import Foundation

enum CellType : String {
    
    case X = "X"
    case O = "O"
    case EMPTY = ""
    
}

enum OXGameState : String {
    
    case InProgress
    case Tie
    case Won
    
}

class OXGame {
    var turns : Int = 0
    var board : [CellType] = [CellType.EMPTY,CellType.EMPTY,CellType.EMPTY,CellType.EMPTY,CellType.EMPTY,CellType.EMPTY,CellType.EMPTY,CellType.EMPTY,CellType.EMPTY]
    var startType : CellType = CellType.X
    func turnCount() -> Int {
        return self.turns
    }
    
    func whoseTurn() -> CellType {
        if (self.turns % 2 == 0) {
            return CellType.X
        } else {
            return CellType.O
        }
    }
    
    func playMove(cell: Int) -> CellType {
        self.turns += 1
        self.board[cell] = self.whoseTurn();
        return self.board[cell];
    }

    func gameWon() -> Bool {
        if (board[1] != CellType.EMPTY) {
            if (board[1] == board[2] && board[1] == board[3]) {
                return true
            }
            if (board[1] == board[4] && board[1] == board[7]) {
                return true
            }
            if (board[1] == board[5] && board[1] == board[9]) {
                return true
            }
        }
        
        if (board[9] != CellType.EMPTY) {
            if (board[9] == board[8] && board[9] == board[7]) {
                return true
            }
            if (board[9] == board[6] && board[9] == board[3]) {
                return true
            }
        }
        
        if (board[5] != CellType.EMPTY) {
            if (board[5] == board[2] && board[5] == board[8]) {
                return true
            }
            if (board[5] == board[4] && board[5] == board[6]) {
                return true
            }
            if (board[5] == board[3] && board[5] == board[7]) {
                return true
            }
        }
        return false
    }
    
    
    func state() -> OXGameState {
        if (self.gameWon() == true) {
            return OXGameState.Won
        } else if (turnCount() == 9) {
            return OXGameState.Tie
        } else {
            return OXGameState.InProgress
        }
    }
    
    func reset() {
        turns = 0
        board = [CellType.EMPTY,CellType.EMPTY,CellType.EMPTY,CellType.EMPTY,CellType.EMPTY,CellType.EMPTY,CellType.EMPTY,CellType.EMPTY,CellType.EMPTY]
    }
}