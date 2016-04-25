//
//  WInterfaceController.swift
//  ChurchFinder
//
//  Created by Sarah Burgess on 4/10/16.
//  Copyright © 2016 Michael Curtis. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class BookmarksInterfaceController: WKInterfaceController,WCSessionDelegate {

  //  var bookmarks = Data.sharedInstance.bookmarks
    
    @IBOutlet var bookmarkTable: WKInterfaceTable!
    var name = ""
    var bookmarks:[MiniChurch] = [MiniChurch()] {
        didSet{
            self.bookmarkTable.setNumberOfRows(self.bookmarks.count, withRowType: "bookmark")
            for(index,church) in bookmarks.enumerate(){
                if let row = bookmarkTable.rowControllerAtIndex(index) as? ChurchRowController {
                    //row.ChurchName?.setText(name)
                    row.name = church.name
                }
            }
            self.bookmarkTable.removeRowsAtIndexes(NSIndexSet(index: 0))
        }
    }
    private var session : WCSession? = WCSession.isSupported() ? WCSession.defaultSession() : nil
    override init() {
        super.init()
        
        session?.delegate = self
        session?.activateSession()
    }

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }

    override func didAppear() {
        super.didAppear()
        // 1
        if WCSession.isSupported() {
            // 2
            session = WCSession.defaultSession()
            // 3
            session!.sendMessage(["reference": "church"], replyHandler: { (response) -> Void in
                // 4
                if let churchData = response["churchData"] as? NSData {
                    
                }
                }, errorHandler: { (error) -> Void in
                    // 6
                    print(error)
            })
        }
    }
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        let church = bookmarks[rowIndex+1]
        presentControllerWithName("Detail", context: church)
    }
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]){
     //   var tst = applicationContext["Array1"] as! [MiniChurch]
        dispatch_async(dispatch_get_main_queue()) { () -> Void in if let retrievedArray1 = applicationContext["Array1"] as? [[String]] {
            // message.append([church.name,church.denom,church.style,String(church.size), church.address])
            var books = retrievedArray1
            books.removeFirst()
            self.bookmarks.removeAll()
            self.bookmarks = [MiniChurch()]
            for(_,church) in books.enumerate() {
                if(church[0] != ""){
                    let temp = MiniChurch()
                    temp.name = church[0]
                    temp.denom = church[1]
                    temp.style = church[2]
                    temp.size = Int(church[3])!
                    temp.address = church[4]
                    temp.lat = Double(church[5])!
                    temp.long = Double(church[6])!
                    self.bookmarks.append(temp)
                }
                
            }
            //self.bookmarks.removeFirst()
           
        }
            
        }
    }
}
