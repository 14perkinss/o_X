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
        OXGameController.sharedInstance.restartGame()
    }
    
    // Create additional IBActions here.
    @IBAction func logoutPressed(sender: AnyObject) {
        print("Logout button pressed")
    }

    @IBAction func cellPressed(sender: AnyObject) {
        OXGameController.sharedInstance.playMove(sender.tag)
        var currGame = OXGameController.sharedInstance.getCurrentGame()
        //sender.title = currGame.whoseTurn()
        print("Button Pressed:", sender.tag)
        var gameState = currGame.state()
        if (gameState == OXGameState.Won) {
            print("Congratulations!")
            OXGameController.sharedInstance.restartGame()
        } else if (gameState == OXGameState.Tie) {
            print("Game ended in a tie")
            OXGameController.sharedInstance.restartGame()
        }
        
    }
    
    var gameObject = OXGame()
}