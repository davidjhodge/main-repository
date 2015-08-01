//
//  FirstVC.swift
//  What's Poppin?
//
//  Created by David Hodge on 2/1/15.
//  Copyright (c) 2015 Genesis Apps, LLC. All rights reserved.
//

import UIKit

class FirstVC: UIViewController {
    @IBOutlet weak var normalPersonButton: UIButton!
    @IBOutlet weak var businessButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
        
        self.view.layoutIfNeeded()
        
        if let normalPersonbutton = normalPersonButton
        {
            normalPersonButton.layer.cornerRadius = 0.5 * normalPersonButton.bounds.size.height
        }
        
        }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        let font = UIFont(name: "HelveticaNeue-Light", size: 20)
        if let font = font {
            UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName : font, NSForegroundColorAttributeName : UIColor.whiteColor()]
        }
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        if UIApplication.sharedApplication().statusBarHidden == false {
            UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade)
        }
        
        //BAD but it works
        businessButton.layer.cornerRadius = 0.5 * businessButton.bounds.size.height
    }
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue)
    {
        println("Unwind Segue Called")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
