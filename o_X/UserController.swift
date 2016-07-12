//
//  UserController.swift
//  o_X
//
//  Created by Sam Perkins on 6/30/16.
//  Copyright © 2016 iX. All rights reserved.
//

import UIKit
import Foundation
class UserController : WebService {
    static var sharedInstance = UserController()
    private var users: [User] = []
    var currentUser: User?
    
    func register(email:String, password:String, onCompletion:(User?,String?) -> ()) {
        
        
        let user = ["email":email,"password":password]
        //remember a request has 4 things:
        //1: A endpoint
        //2: A method
        //3: input data (optional)
        //4: A response
        let request = self.createMutableAnonRequest(NSURL(string: "https://ox-backend.herokuapp.com/auth"), method: "POST", parameters: user)
        //execute request is a function we are able to call in UserController, because UserController extends WebService (See top of file, where UserController is defined)
        self.executeRequest(request, requestCompletionFunction: {(responseCode, json) in
            //Here is our completion closure for the web request. when the web service is done, this is what is executed.
            //Not only is the code in this block executed, but we are given 2 input parameters, responseCode and json.
            //responseCode is the response code from the server.
            //json is the response data received
            print(json)
            var user:User = User(email:email,password: password, client: "", token: "")
            user.email = email
            user.password = "not_saved"
            
            
            if (responseCode == 200)   {
                //if the responseCode is 2xx (any responseCode in the 200's range is a success case. For example, some servers return 201 for successful object creation)
                //successfully registered user. get the obtained data from the json response data and create the user object to give back to the calling ViewController
                
                user = User(email: json["data"]["email"].stringValue,password:"not_given_and_not_stored", client:json["data"]["client"].stringValue, token:json["data"]["token"].stringValue)
                
                //and while we still at it, lets set the user as logged in. This is good programming as we are keeping all the user management inside the UserController and handling it at the right time
                self.currentUser = user
                //Note that our registerUser function has 4 parameters: email, password, presentingViewController and requestCompletionFunction
                //requestCompletionFunction is a closure for what is to happen in the ViewController when we are done with the webservice.
                //lets execute that closure now - Lets me be clear. This is 1 step more advanced than normal. We are executing a closure inside a closure (we are executing the viewControllerCompletionFunction from within the
                onCompletion(user,nil)
            }   else    {
                //the web service to create a user failed. Lets extract the error message to be displayed
                let errorMessage = json["errors"]["full_messages"][0].stringValue
                //execute the closure in the ViewController
                onCompletion(nil,errorMessage)
            }
        })
        //we are now done with the registerUser function. Note that this function doesnt return anything. But because of the viewControllerCompletionFunction closure we are given as an input parameter, we can set in motion a function in the calling class when it is needed.
    }
    
    
    func login(email: String, password: String, onCompletion: (User?, String?) -> Void) {
        let user = ["email":email,"password":password]
        let request = self.createMutableAnonRequest(NSURL(string: "https://ox-backend.herokuapp.com/auth/sign_in"), method: "POST", parameters: user)
        
        self.executeRequest(request, requestCompletionFunction: {(responseCode, json) in
            
            //Here is our completion closure for the web request. when the web service is done, this is what is executed.
            //Not only is the code in this block executed, but we are given 2 input parameters, responseCode and json.
            //responseCode is the response code from the server.
            //json is the response data received
            
            
            print(json)
            if (responseCode == 200)   {
                
                let user = User(email: json["data"]["email"].stringValue,password:"not_given_and_not_stored", client:json["data"]["client"].stringValue, token:json["data"]["token"].stringValue)
                self.currentUser = user

                //Get defaults system
                let defaults = NSUserDefaults.standardUserDefaults()
                //Save an object with a reference (key)
                defaults.setObject(email, forKey: "currentUserEmail")
                defaults.setObject(password, forKey: "currentUserPassword")
                defaults.setObject(json["data"]["client"].stringValue, forKey: "currentUserClient")
                defaults.setObject(json["data"]["token"].stringValue, forKey: "currentUserToken")
                defaults.setObject(json["data"]["uid"].stringValue, forKey: "currentUserUID")
                defaults.setObject("Bearer", forKey: "currentUserTokenType")
                defaults.synchronize()
                onCompletion(user,nil)
            } else {
                //the web service to create a user failed. Lets extract the error message to be displayed
                
                let errorMessage = json["errors"]["full_messages"][0].stringValue
                
                //execute the closure in the ViewController
                onCompletion(nil,errorMessage)
            }
        })
    }
    
    func logout(onCompletion: (String?) -> Void) {
        OXGameController.sharedInstance.restartGame()
        currentUser = nil
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey("currentUserEmail")
        defaults.removeObjectForKey("currentUserClient")
        defaults.removeObjectForKey("currentUserUID")
        defaults.removeObjectForKey("currentUserTokenType")
        defaults.removeObjectForKey("currentUserToken")
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
