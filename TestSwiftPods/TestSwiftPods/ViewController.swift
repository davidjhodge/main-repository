//
//  ViewController.swift
//  TestSwiftPods
//
//  Created by David Hodge on 2/9/15.
//  Copyright (c) 2015 Genesis Apps, LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var dictionary = [ : ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let manager = AFHTTPRequestOperationManager()
        
        manager.GET("http://api.kivaws.org/v1/loans/search.json?status=fundraising",
            parameters: nil,
            success: {
                (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                self.dictionary = responseObject as NSDictionary
            println("JSON: \(responseObject.description)")
            }, failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

