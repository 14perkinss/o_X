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
    }
    
    // Create additional IBActions here.
    @IBAction func logoutPressed(sender: AnyObject) {
        print("Logout button pressed")
    }

}

