//
//  JokeTableViewController.swift
//  FoodTracker
//
//  Created by HAN LI on 6/16/16.
//  Copyright © 2016 HAN LI. All rights reserved.
//

import SwiftyJSON
import Alamofire
import UIKit
import MBProgressHUD

class JokeTableViewController: UITableViewController {

    var jokes = [String]();
    let numberOfJokesToDownload = 20
    var refreshFeed: UIRefreshControl!
    let label = UILabel(frame: CGRectMake(0, 0, 160, 240))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createRefreshControl()
        refresh(refreshFeed)
    }
    func createRefreshControl()
    {
        refreshFeed = UIRefreshControl()
        refreshFeed.tintColor = UIColor.whiteColor()
        refreshFeed.backgroundColor = self.view.tintColor
        refreshFeed.addTarget(self, action: #selector(refresh(_:)), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshFeed)
        

    }
    func refresh(refreshControl: UIRefreshControl) {
        downloadJokes(true)
        refreshControl.endRefreshing()
    }
    func downloadJokes(clearBeforeRefresh : Bool)
    {
//        jokes += ["hello"]
        
//        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//        loadingNotification.mode = MBProgressHUDMode.Indeterminate
//        loadingNotification.labelText = "Loading"
        
        let requestString = "http://api.icndb.com/jokes/random/"
        
        Alamofire.request(.GET, requestString + String(numberOfJokesToDownload))
            .responseJSON { response in
//                print(response.request)  // original URL request
//                print(response.response) // URL response
//                print(response.data)     // server data
//                print(response.result)   // result of response serialization
                
                if let data = response.result.value {
                    let json = JSON(data)
                    let type = json["type"]
                    //print(type)
                    
                    if clearBeforeRefresh
                    {
                        self.jokes = []
                    }
                    let currCount = self.jokes.count
                    var endCount = currCount
                    let jokesArray = json["value"]
                    for (_, object) in jokesArray {
                        var jokeString = object["joke"].stringValue
                        jokeString = jokeString.stringByReplacingOccurrencesOfString("&quot;", withString: "\"")
                        
                        self.jokes+=[jokeString]
                        endCount+=1
                        //print(jokeString);
                    }
                    
                    var rows = [NSIndexPath]()
                    for i in currCount...endCount
                    {
                        rows += [NSIndexPath(forRow: i, inSection: 0)]
                    }
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                        
//                        UIView.transitionWithView(self.tableView,
//                            duration: 0.35,
//                            options: .TransitionNone,
//                            animations:
//                            { () -> Void in
//                                
//                                
//                                self.tableView.reloadData()
//                                
//                            },
//                            completion: nil)
                        self.tableView.reloadData()
                    })
                    
                    
                }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if jokes.count != 0
        {
            label.text = "";
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            return 1
        }
        else
        {
            label.numberOfLines = 0
            label.textAlignment = NSTextAlignment.Center
            label.text = "Loading jokes"
            
            self.tableView.backgroundView = label;
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            return 0;
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return jokes.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("JokeTableViewCell", forIndexPath: indexPath) as! JokeTableViewCell
        
        cell.jokeText.text = jokes[indexPath.row]
        cell.index.text = String(indexPath.row + 1)
        
        if indexPath.row == jokes.count - 1
        {
            downloadJokes(false)
        }

        return cell
    }
 
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // Fix weird table view divider not extending all the way to the left
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.separatorInset = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let share = UITableViewRowAction(style: .Normal, title: "Share") { action, index in
            
            tableView.setEditing(false, animated: true)
            var sharingItems = [AnyObject]()
            
            sharingItems.append(self.jokes[indexPath.row])
            print(self.jokes[indexPath.row])
            
            let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
            self.presentViewController(activityViewController, animated: true, completion: nil)
            
        }
        share.backgroundColor = UIColor(netHex:0x4CD964)

        return [share]
    }

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
