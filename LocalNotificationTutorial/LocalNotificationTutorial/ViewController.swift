//
//  ViewController.swift
//  LocalNotificationTutorial
//
//  Created by David Hodge on 2/24/15.
//  Copyright (c) 2015 Genesis Apps, LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    /*
        var localNotification:UILocalNotification = UILocalNotification()
        localNotification.alertAction = "Testing notifications on iOS8"
        localNotification.alertBody = "Woww it works!!"
        localNotification.timeZone = NSTimeZone.defaultTimeZone()
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 2 - (3600*4))
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
*/
    }

 
    @IBAction func notificationAction(sender: AnyObject) {
        
        //Create Notification using attributes from AppDelegate Notification Registration
        var notification: UILocalNotification = UILocalNotification()
        notification.category = "FIRST_CATEGORY"
        notification.alertAction = "Yo"
        notification.alertBody = "Hi, I am a notification"
        let date: NSDate = NSDate(timeIntervalSinceNow: 4/* - (3600*4)*/)
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.fireDate = date //Dispatches notification NOW
        println("Fire Date: \(notification.fireDate)")
        
        //Dispatch Notification
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        println("Notification Dispatched")
        
        //Test
        println("Scheduled Notifications: \(UIApplication.sharedApplication().scheduledLocalNotifications)")
    }
}

