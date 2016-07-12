//
//  NetworkGamesTableViewController.swift
//  o_X
//
//  Created by Sam Perkins on 7/4/16.
//  Copyright © 2016 iX. All rights reserved.
//

import UIKit

class NetworkGamesTableViewController: UITableViewController {
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var newGameButton: UIBarButtonItem!
    private var gameArray : [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let onCompletion = {(gameList: [Int]?, errorMessage: String?) -> Void in
            if (errorMessage == nil) {
                for game in gameList! {
                    self.gameArray.append(game)
                }
                self.tableView.reloadData()
            } else {
                print(errorMessage)
            }
        }
        
        OXGameController.sharedInstance.getGames(onCompletion: onCompletion)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gameArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        
        //Configure cell
        cell.textLabel?.text = String(gameArray[indexPath.row])
        
        return cell
    }
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        let cellText: String = cell.textLabel!.text!
        
        let onCompletion = {(gameHost: String?, errorMessage: String?) -> Void in
            if (errorMessage == nil) {
                let newGame = OXGame()
                newGame.host = gameHost
                newGame.ID = Int(cellText)
                OXGameController.sharedInstance.currentGame = newGame
                self.performSegueWithIdentifier("networkSegue", sender: nil)
            } else {
                print (errorMessage)
            }
        }
        OXGameController.sharedInstance.acceptGame(Int(cellText)!, onCompletion: onCompletion)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let boardViewController = segue.destinationViewController as! BoardViewController
        boardViewController.networkMode = true
    }
    
    
    @IBAction func backButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: {});
    }

    @IBAction func newGameButtonPressed(sender: UIBarButtonItem) {
        OXGameController.sharedInstance.newGame({
            self.performSegueWithIdentifier("networkSegue", sender: nil)
            })
    }
}
