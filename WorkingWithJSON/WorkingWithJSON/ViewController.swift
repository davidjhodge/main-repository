//
//  ViewController.swift
//  WorkingWithJSON
//
//  Created by David Hodge on 2/13/15.
//  Copyright (c) 2015 Genesis Apps, LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var dictionary: NSDictionary = NSDictionary()
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchResultsWithQuery()
    }
    
    func printResults()
    {
        println(self.dictionary)
        
        if let loans: Array<Dictionary<String,AnyObject>> = self.dictionary["loans"] as? Array<Dictionary<String,AnyObject>>
        {
            if let location: Dictionary<String,AnyObject> = loans[0]["location"] as? Dictionary<String,AnyObject>
            {
                if let country: String = location["country"] as? String
                {
                    self.resultLabel.text = country
                    println(country)
                }
            }
        }
    }
    
    /*
    for (Dictionary currentLoan in loans)
    {
    currentLoad["key"];
    
    }
    */
    
    func fetchResultsWithQuery() -> Void
    {
        //URL to access
        //let urlString = "https://testsite.com/var/www/html/UploadPost.php?"
        let urlString = "http://api.kivaws.org/v1/loans/search.json?status=fundraising"
        let url: NSURL = NSURL(string: urlString)!
        
        //Request for NSURLSessionDataTask.dataTaskWithRequest
        let request: NSURLRequest = NSURLRequest(URL: url)
        
        //Create NSURL Session with default configuration
        let sessionConfiguration: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session: NSURLSession = NSURLSession(configuration: sessionConfiguration)
        
        //Define data task what to do with response
        let dataTask: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            //Completion Handler runs in background thread
            //Must use wrapper to call an nsnotification to update teh UI
            let httpResponse: NSHTTPURLResponse = response as! NSHTTPURLResponse
            
            if httpResponse.statusCode == 200
            {
                var error: NSError?
                let json: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &error) as! NSDictionary
                
                if let err = error {
                    println(error?.localizedDescription)
                    
                } else {
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.dictionary = json
                        self.printResults()
                    })
                    
                }
            }
        })
        //Start the Data Task
        dataTask.resume()
    }
    
    func postInfoToDatabase(info: Dictionary<String,String>)
    {
        //Create URL
        let urlString = "https://testsite.com/var/www/html/PHPFileGetPosts.php?"
        let url: NSURL = NSURL(string: urlString)!
        
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 15.0)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        //For POST Request
        request.HTTPMethod = "POST"
        
        let mapData: Dictionary = [
            "name" : "David",
            "address" : "216 Sweet Gum Rd"
        ]
        
        var error: NSError?
        let postData: NSData = NSJSONSerialization.dataWithJSONObject(mapData, options: nil, error: &error)!
        request.HTTPBody = postData
        
        
        //Create NSURL Session with default configuration
        let sessionConfiguration: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session: NSURLSession = NSURLSession(configuration: sessionConfiguration)
        
        //Define data task what to do with response
        let dataTask: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            //Completion Handler runs in background thread
            //Must use wrapper to call an nsnotification to update teh UI
            let httpResponse: NSHTTPURLResponse = response as! NSHTTPURLResponse
            
            if httpResponse.statusCode == 200
            {
                if let err = error {
                    println(error?.localizedDescription)
                    
                } else {
                    println("Success")
                }
            }
        })
        //Start the Data Task
        dataTask.resume()
    }
}

