//
//  BoardViewController.swift
//  o_X
//

import UIKit

class BoardViewController: UIViewController {
    @IBOutlet weak var boardView: UIView!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    // Create additional IBOutlets here.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newGameButton.hidden = true
    }
    
    
    @IBAction func newGamePressed(sender: UIButton) {
        print("New Game Button Pressed")
        restartGame()
    }
    
    @IBAction func logoutButtonPressed(sender: UIButton) {
        //Get the other storyboard object
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        //Get the root view controller of the other storyboard object
        let viewController = storyboard.instantiateInitialViewController()
        //Get the application object
        let application = UIApplication.sharedApplication()
        //Get the window object from the application object
        let window = application.keyWindow
        //Set the rootViewController of the window to the rootViewController of the other storyboard
        window?.rootViewController = viewController
    }


    @IBAction func cellPressed(sender: UIButton) {
        OXGameController.sharedInstance.playMove(sender.tag)
        let currGame = OXGameController.sharedInstance.getCurrentGame()
        sender.setTitle(currGame.whoseTurn().rawValue, forState: .Normal)
        print("Button Pressed:", sender.tag)
        
        let gameState = currGame.state()
        
        if (gameState == OXGameState.Won) {
            print("Congratulations, ", currGame.whoseTurn().rawValue)
            newGameButton.hidden = false
            let winner : String = "\(currGame.whoseTurn().rawValue) Won!"
            let alert = UIAlertController(title: "Game Over", message: winner, preferredStyle: UIAlertControllerStyle.Alert)
            let alertAction = UIAlertAction(title: "Dismiss", style: .Default, handler: {(action) in
            })
            alert.addAction(alertAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else if (gameState == OXGameState.Tie) {
            print("Game ended in a tie")
            newGameButton.hidden = false
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
    
    var gameObject = OXGame()
}