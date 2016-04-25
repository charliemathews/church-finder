/*
Copyright 2016 Serious Llama and Grove City College. All rights reserved.
*/

import UIKit
import Parse
import Bolts
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {

    var window: UIWindow?
    
    var wsession : WCSession?
    /*
        TODO: set keys from constants file.
    */
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //TODO, figure out why we can't use Constants.Parse.{keyname} here without crashing parse
        Parse.enableLocalDatastore()
        Parse.setApplicationId("OTXY6dM8ChkriarqrX4SPi2e2Def9v1EM0VVNoOW", clientKey: "5I1Iky8vY7hheR7X9QAejEbXaw96UMFBYGzVr4h3")
        //wc
        if(WCSession.isSupported()){
            wsession = WCSession.defaultSession()
            wsession!.delegate = self
            wsession!.activateSession()
        }
        var churchBookmarkedNames = [""]
        var bookmarkedChurches = [MiniChurch()]
        for b in Data.sharedInstance.bookmarks {
            churchBookmarkedNames.append(b.name)
            let newC = MiniChurch()
            newC.name = b.name
            newC.denom = b.denom
            newC.style = b.style
            newC.times = b.times
            newC.address = b.address
            newC.lat = b.location.latitude
            newC.long = b.location.longitude
            bookmarkedChurches.append(newC)
        }
        
        var message = [[""]]
        for(_,church) in bookmarkedChurches.enumerate() {
            message.append([church.name,church.denom,church.style,String(church.size), church.address, String(church.lat),String(church.long)])
        }
        if(message.count > 0){
            do {
                try wsession?.updateApplicationContext(
                    ["Array1" : message]
                )
            } catch let error as NSError {
                NSLog("Updating the context failed: " + error.localizedDescription)
            }
        }

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        if(WCSession.isSupported()){
            wsession = WCSession.defaultSession()
            wsession!.delegate = self
            wsession!.activateSession()
        }
        var churchBookmarkedNames = [""]
        for b in Data.sharedInstance.bookmarks {
            churchBookmarkedNames.append(b.name)
        }
        let message = churchBookmarkedNames
        if(message.count > 0){
            do{
                let applicationDict = ["Array1": message]
                try WCSession.defaultSession().updateApplicationContext(applicationDict)
            }
            catch {
                NSLog("error w/ watch connectivity.")
            }
            
        }
    }

}