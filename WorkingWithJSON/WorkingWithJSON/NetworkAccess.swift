//
//  NetworkAccess.swift
//  WorkingWithJSON
//
//  Created by David Hodge on 2/16/15.
//  Copyright (c) 2015 Genesis Apps, LLC. All rights reserved.
//

import UIKit

class NetworkAccess: NSObject {
   
    }

func postInfoToDatabase(mapData: Dictionary<String,String>)
{
    //Create URL
    let urlString = "http://ec2-54-84-9-63.compute-1.amazonaws.com/php/WorkingWithJSON.php?"
    let url: NSURL = NSURL(string: urlString)!
    
    let request: NSMutableURLRequest = NSMutableURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 15.0)
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    //For POST Request
    request.HTTPMethod = "POST"
    
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
            var error: NSError?

            if let err = error {
                println(error?.localizedDescription)
                
            } else {
                if let output: NSString = NSString(data: data, encoding: NSUTF8StringEncoding)
                {
                    println("Post Response: \(output)")
                }
            }
        }
    })
    //Start the Data Task
    dataTask.resume()
}
