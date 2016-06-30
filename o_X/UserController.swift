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
    
    func logout(onCompletion onCompletion: (String?) -> Void) {
        currentUser = nil
        onCompletion("You have successfully logged out.")
    }
}
