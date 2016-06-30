//
//  LoginViewController.swift
//  o_X
//
//  Created by Sam Perkins on 6/30/16.
//  Copyright © 2016 iX. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func loginButtonPressed(sender: UIButton) {
        //Closure to handle completion
        let onCompletion = {(currentUser: User?, errorMessage: String?) -> Void in
            //If there was an error, show an alert
            if (currentUser == nil) {
                let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
                let action = UIAlertAction(title: "Dismiss", style: .Default, handler: {(action) in
                })
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                //Get the other storyboard object
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                //Get the root view controller of the other storyboard object
                let viewController = storyboard.instantiateInitialViewController()
                //Get the application object
                let application = UIApplication.sharedApplication()
                //Get the window object from the application object
                let window = application.keyWindow
                //Set the rootViewController of the window to the rootViewController of the other storyboard
                window?.rootViewController = viewController
            }
        }
        UserController.sharedInstance.login(emailField.text!, password: passwordField.text!, onCompletion: onCompletion)
    }
}
