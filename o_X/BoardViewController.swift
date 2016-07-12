//
//  BoardViewController.swift
//  o_X
//

import UIKit

class BoardViewController: UIViewController {
    @IBOutlet weak var boardView: UIView!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var networkPlayButton: UIButton!
    @IBOutlet weak var cancelGameButton: UIBarButtonItem!
    // Create additional IBOutlets here.
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    var networkMode: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        if (!networkMode) {
            newGameButton.hidden = true
            updateUI()
        } else {
            for subview in boardView.subviews {
                if let button = subview as? UIButton {
                    button.setTitle("", forState: .Normal)
                    button.enabled = false
                }
            }
            //Lets set the starting player to O or X
            if (OXGameController.sharedInstance.currentGame.host! == UserController.sharedInstance.currentUser?.email) {
                OXGameController.sharedInstance.currentGame.otherType = CellType.X
                bottomLabel.text = "Waiting for Opponent to Join"
            } else {
                OXGameController.sharedInstance.currentGame.startType = CellType.O
                bottomLabel.text = "Waiting for Opponent to Move"
            }
        }
    }
    
    
    @IBAction func newGamePressed(sender: UIButton) {
        print("New Game Button Pressed")
        restartGame()
    }
    
    @IBAction func logoutButtonPressed(sender: UIButton) {
        let onCompletion = {(errorMessage: String?) -> Void in
            //If there was an error, show an alert
            let alert = UIAlertController(title: "Log Out Successful", message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Dismiss", style: .Default, handler: {(action) in
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        UserController.sharedInstance.logout(onCompletion)
    }
    
    @IBAction func cellPressed(sender: UIButton) {
        OXGameController.sharedInstance.playMove(sender.tag, onCompletion: {
            print ("closure executed for make move")
            })
        let currGame = OXGameController.sharedInstance.getCurrentGame()
        sender.setTitle(currGame.whoseTurn().rawValue, forState: .Normal)
        print("Button Pressed:", sender.tag)
        
        let gameState = currGame.state()
        
        if (gameState == OXGameState.Won) {
            if (!networkMode) {
                newGameButton.hidden = false
            }
            print("Congratulations, ", currGame.whoseTurn().rawValue)
            let winner : String = "\(currGame.whoseTurn().rawValue) Won!"
            let alert = UIAlertController(title: "Game Over", message: winner, preferredStyle: UIAlertControllerStyle.Alert)
            let alertAction = UIAlertAction(title: "Dismiss", style: .Default, handler: {(action) in
            })
            alert.addAction(alertAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else if (gameState == OXGameState.Tie) {
            print("Game ended in a tie")
            if (!networkMode) {
                newGameButton.hidden = false
            }
            let alert = UIAlertController(title: "Game Over", message: "Game Ended in a Tie!", preferredStyle: UIAlertControllerStyle.Alert)
            let alertAction = UIAlertAction(title: "Dismiss", style: .Default, handler: {(action) in
            })
            alert.addAction(alertAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        sender.enabled = false
        
    }
    
    func restartGame() {
        OXGameController.sharedInstance.restartGame()
        for subview in boardView.subviews {
            if let button = subview as? UIButton {
                button.setTitle("", forState: .Normal)
                button.enabled = true
            }
        }
    }
    
    /* BoardViewController's updateUI() function: This function must set the values of O and X on the board, based on the games board array values */
    func updateUI() {
        let currGame = OXGameController.sharedInstance.getCurrentGame()
        print ("HERE'S THE BOARD", currGame.board)
        var count = 0
        for subview in boardView.subviews {
            if let button = subview as? UIButton {
                if (currGame.board[count] == CellType.EMPTY) {
                    button.setTitle("", forState: .Normal)
                    button.enabled = true
                } else if (currGame.board[count] == CellType.O) {
                    button.setTitle("O", forState: .Normal)
                    button.enabled = false
                } else {
                    button.setTitle("X", forState: .Normal)
                    button.enabled = false
                }
                count += 1
            }
        }
    }
    
    @IBAction func refreshPressed(sender: UIButton) {
        OXGameController.sharedInstance.getGame(onCompletion: {
            self.updateUI()
        })
    }
    
    @IBAction func cancelGamePressed(sender: UIBarButtonItem) {
        OXGameController.sharedInstance.cancelGame()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}