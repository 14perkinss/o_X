//
//  BoardViewController.swift
//  o_X
//

import UIKit

class BoardViewController: UIViewController {
    @IBOutlet weak var boardView: UIView!
    @IBOutlet weak var newGameButton: UIBarButtonItem!
    // Create additional IBOutlets here.

    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    @IBAction func newGamePressed(sender: UIBarButtonItem) {
        print("New Game Button Pressed")
        restartGame()
    }
    
    // Create additional IBActions here.
    @IBAction func logoutPressed(sender: AnyObject) {
        print("Logout button pressed")
    }

    @IBAction func cellPressed(sender: UIButton) {
        OXGameController.sharedInstance.playMove(sender.tag)
        let currGame = OXGameController.sharedInstance.getCurrentGame()
        sender.setTitle(currGame.whoseTurn().rawValue, forState: .Normal)
        print("Button Pressed:", sender.tag)
        
        let gameState = currGame.state()
        
        if (gameState == OXGameState.Won) {
            print("Congratulations, ", currGame.whoseTurn().rawValue)
        } else if (gameState == OXGameState.Tie) {
            print("Game ended in a tie")
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
    
    var gameObject = OXGame()
}