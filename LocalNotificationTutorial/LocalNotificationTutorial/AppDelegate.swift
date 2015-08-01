//
//  AppDelegate.swift
//  LocalNotificationTutorial
//
//  Created by David Hodge on 2/24/15.
//  Copyright (c) 2015 Genesis Apps, LLC. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        //Local Notification Actions
        var firstAction: UIMutableUserNotificationAction = createAction(
            identifier: "FIRST_ACTION",
            title: "First Action",
            backgroundActivation: true,
            destructive: true,
            authenticationRequired: false)
        
        var secondAction: UIMutableUserNotificationAction = createAction(
            identifier: "SECOND_ACTION",
            title: "Second Action",
            backgroundActivation: false,
            destructive: false,
            authenticationRequired: false)
        
        var thirdAction: UIMutableUserNotificationAction = createAction(
            identifier: "THIRD_ACTION",
            title: "Third Action",
            backgroundActivation: true,
            destructive: false,
            authenticationRequired: false)
        
        //Category
        var firstCategory: UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
        firstCategory.identifier = "FIRST_CATEGORY"
        
        let defaultActions: NSArray = [firstAction, secondAction, thirdAction]
        let minimalActions: NSArray = [firstAction, secondAction]
        
        firstCategory.setActions(defaultActions as! [AnyObject], forContext: UIUserNotificationActionContext.Default)
        firstCategory.setActions(minimalActions as! [AnyObject], forContext: UIUserNotificationActionContext.Minimal)
        
        //NSSet of all our categories
        let categories: Set<NSObject> = Set(arrayLiteral: [firstCategory])
        
        //Register for Local Notifications
        let types: UIUserNotificationType = .Alert | .Badge
        
        let settings: UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: categories)
        
        application.registerUserNotificationSettings(settings)

        return true
    }
    
    func createAction(identifier actionIdentifier: String, title actionTitle: String, backgroundActivation background: Bool, destructive destructiveValue: Bool, authenticationRequired auth: Bool) -> UIMutableUserNotificationAction
    {
        var action: UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        action.identifier = actionIdentifier
        action.title = actionTitle
        
        if background == false
        {
            action.activationMode = UIUserNotificationActivationMode.Foreground
        } else if background == true
        {
            action.activationMode = UIUserNotificationActivationMode.Background
        }
        action.destructive = destructiveValue
        action.authenticationRequired = auth
        
        return action
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


}

