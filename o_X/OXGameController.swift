//
//  OXGameController.swift
//  o_X
//
//  Created by Sam Perkins on 6/29/16.
//  Copyright © 2016 iX. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class OXGameController : WebService {
    static let sharedInstance = OXGameController()
    var currentGame = OXGame()
    private override init() {}
    func getCurrentGame() -> OXGame {
        return currentGame
    }
    
    func restartGame() {
        currentGame.reset()
    }
    
    func playMove(cell: Int) {
        currentGame.playMove(cell)
    }
    
    func playMove(cell: Int, onCompletion: (() -> Void)?) {
        currentGame.playMove(cell)
        if (onCompletion != nil) {
            let newBoard : String = currentGame.serialiseBoard()
            let defaults = NSUserDefaults.standardUserDefaults()
            let headerArray = ["Access-Token":defaults.stringForKey("currentUserToken")!, "Client":defaults.stringForKey("currentUserClient")!, "Token-Type":defaults.stringForKey("currentUserTokenType")!, "Uid":defaults.stringForKey("currentUserUID")!, "board": newBoard]
            let url : String = "https://ox-backend.herokuapp.com/games/" + String(currentGame.ID!)
            let request = self.createMutableRequest(NSURL(string: url), method: "PUT", parameters: headerArray)
            self.executeRequest(request, requestCompletionFunction: {(responseCode, json) in
                print (json)
                if (responseCode == 200) {
                    print ("move made")
                } else {
                    print (json["errrors"]["full_messages"][0].stringValue)
                }
            })
        }
    }
    
    //update board

    
    func getGames(onCompletion onCompletion: ([Int]?, String?) -> Void) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let headerArray = ["Access-Token":defaults.stringForKey("currentUserToken")!, "Client":defaults.stringForKey("currentUserClient")!, "Token-Type":defaults.stringForKey("currentUserTokenType")!, "Uid":defaults.stringForKey("currentUserUID")!]

        let request = self.createMutableRequest(NSURL(string: "https://ox-backend.herokuapp.com/games"), method: "GET", parameters: headerArray)
        //execute request is a function we are able to call in UserController, because UserController extends WebService (See top of file, where UserController is defined)
        self.executeRequest(request, requestCompletionFunction: {(responseCode, json) in
            //Here is our completion closure for the web request. when the web service is done, this is what is executed.
            //Not only is the code in this block executed, but we are given 2 input parameters, responseCode and json.
            //responseCode is the response code from the server.
            //json is the response data received
            //print(json)
            
            if (responseCode == 200) {
                var gamesArray : [Int] = []
                for i in 0..<json.count {
                    gamesArray.append(json[i]["id"].int!)
                }
                onCompletion(gamesArray,nil)
            }   else    {
                //the web service to create a user failed. Lets extract the error message to be displayed
                let errorMessage = json["errors"]["full_messages"][0].stringValue
                //execute the closure in the ViewController
                onCompletion(nil,errorMessage)
            }
        })
        //we are now done with the registerUser function. Note that this function doesnt return anything. But because of the viewControllerCompletionFunction closure we are given as an input parameter, we can set in motion a function in the calling class when it is needed.
    }
    
    func acceptGame(gameID: Int, onCompletion: (String?, String?) -> Void) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let headerArray = ["Access-Token":defaults.stringForKey("currentUserToken")!, "Client":defaults.stringForKey("currentUserClient")!, "Token-Type":defaults.stringForKey("currentUserTokenType")!, "Uid":defaults.stringForKey("currentUserUID")!]
        let url : String = "https://ox-backend.herokuapp.com/games/" + String(gameID) + "/join"
        let request = self.createMutableRequest(NSURL(string: url), method: "GET", parameters: headerArray)
        self.executeRequest(request, requestCompletionFunction: {(responseCode, json) in
            //print(json)
            
            if (responseCode == 200) {
                let gameHost = json["host_user"]["uid"].string!
                print("HOST", gameHost)
                onCompletion(gameHost, nil)
            }   else    {
                //the web service to create a user failed. Lets extract the error message to be displayed
                let errorMessage = json["errors"]["full_messages"][0].stringValue
                //execute the closure in the ViewController
                onCompletion(nil,errorMessage)
            }
        })
    }
    
    func newGame(onCompletion: ()-> Void) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let headerArray = ["Access-Token":defaults.stringForKey("currentUserToken")!, "Client":defaults.stringForKey("currentUserClient")!, "Token-Type":defaults.stringForKey("currentUserTokenType")!, "Uid":defaults.stringForKey("currentUserUID")!]
        let request = self.createMutableRequest(NSURL(string: "https://ox-backend.herokuapp.com/games/"), method: "POST", parameters: headerArray)
        self.executeRequest(request, requestCompletionFunction: {(responseCode, json) in
            print("NEW GAME DONE")
            //print (json)
            if (responseCode == 200) {
                let newGame = OXGame()
                newGame.host = headerArray["Uid"]
                newGame.ID = json["id"].int!
                OXGameController.sharedInstance.currentGame = newGame
                onCompletion()
            } else {
                print (json["errrors"]["full_messages"][0].stringValue)
            }
        })
    }
    
    func getGame(onCompletion onCompletion : ()->Void) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let headerArray = ["Access-Token":defaults.stringForKey("currentUserToken")!, "Client":defaults.stringForKey("currentUserClient")!, "Token-Type":defaults.stringForKey("currentUserTokenType")!, "Uid":defaults.stringForKey("currentUserUID")!]
        let url : String = "https://ox-backend.herokuapp.com/games/" + String(currentGame.ID!)
        let request = self.createMutableRequest(NSURL(string: url), method: "GET", parameters: headerArray)
        self.executeRequest(request, requestCompletionFunction: {(responseCode, json) in
            //print (json)
            if (responseCode == 200) {
                self.currentGame.board = self.currentGame.deserialiseBoard(json["board"].stringValue)
                onCompletion()
            } else {
                print (json["errrors"]["full_messages"][0].stringValue)
            }
        })
    }
    
    func cancelGame() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let headerArray = ["Access-Token":defaults.stringForKey("currentUserToken")!, "Client":defaults.stringForKey("currentUserClient")!, "Token-Type":defaults.stringForKey("currentUserTokenType")!, "Uid":defaults.stringForKey("currentUserUID")!]
        let url : String = "https://ox-backend.herokuapp.com/games/" + String(currentGame.ID!)
        let request = self.createMutableRequest(NSURL(string: url), method: "DELETE", parameters: headerArray)
        self.executeRequest(request, requestCompletionFunction: {(responseCode, json) in
            //print (json)
            if (responseCode == 200) {
                print("Game Cancelled")
            } else {
                print (json["errrors"]["full_messages"][0].stringValue)
            }
        })
    }

}
