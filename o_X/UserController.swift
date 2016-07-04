//
//  UserController.swift
//  o_X
//
//  Created by Sam Perkins on 6/30/16.
//  Copyright © 2016 iX. All rights reserved.
//

import UIKit
import Foundation
class UserController {
    static var sharedInstance = UserController()
    private var users: [User] = []
    var currentUser: User?
    func register(email: String, password: String, onCompletion: (User?, String?) -> Void) {
        if (password.characters.count >= 6) {
            currentUser = User(email: email, password: password)
            
            //Get defaults system
            let defaults = NSUserDefaults.standardUserDefaults()
            //Save an object with a reference (key)
            defaults.setObject(email, forKey: "currentUserEmail")
            defaults.setObject(password, forKey: "currentUserPassword")
            defaults.synchronize()
            
            users.append(currentUser!)
            onCompletion(currentUser, nil)
        } else {
            onCompletion(nil, "Password must be at least 6 characters")
        }
        print(users.count)
    }
    
    func login(email: String, password: String, onCompletion: (User?, String?) -> Void) {
        for user in users {
            if (user.email == email) {
                if (user.password == password) {
                    currentUser = user
        
                    //Get defaults system
                    let defaults = NSUserDefaults.standardUserDefaults()
                    //Save an object with a reference (key)
                    defaults.setObject(email, forKey: "currentUserEmail")
                    defaults.setObject(password, forKey: "currentUserPassword")
                    defaults.synchronize()

                    onCompletion(user, nil)
                    return
                } else {
                    onCompletion(nil, "Incorrect Password")
                    return
                }
            }
        }
        onCompletion(nil, "Email not registered")
        print(users.count)
    }
    
    func logout(onCompletion: (String?) -> Void) {
        currentUser = nil
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey("currentUserEmail")
        defaults.removeObjectForKey("currentUserPassword")
        defaults.synchronize()
        onCompletion("You have successfully logged out.")
        
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
}
