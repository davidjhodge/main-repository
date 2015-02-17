//
//  ViewController.swift
//  WorkingWithJSON
//
//  Created by David Hodge on 2/13/15.
//  Copyright (c) 2015 Genesis Apps, LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSURLSessionDelegate {
    var dictionary: NSDictionary = NSDictionary()
    var loanArray: Array<Loan> = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchResultsWithQuery()
    }
    
    func printResults()
    {
        println(self.dictionary)
    }
    
    func loadJSONData()
    {
        if let loans: Array<Dictionary<String,AnyObject>> = self.dictionary["loans"] as? Array<Dictionary<String,AnyObject>>
        {
            for loan in loans
            {
                var currentLoan: Loan = Loan()
                
                if let activity: String = loan["activity"] as? String
                {
                    currentLoan.name = activity
                }
                
                if let location: Dictionary<String,AnyObject> = loan["location"] as? Dictionary<String,AnyObject>
                {
                    if let country: String = location["country"] as? String
                    {
                        currentLoan.location = country
                    }
                }
                loanArray.append(currentLoan)
            }
        }
        self.tableView.reloadData()
    }
    
    //MARK : GET/POST Requests
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
                        self.loadJSONData()
                    })
                    
                }
            }
        })
        //Start the Data Task
        dataTask.resume()
    }
    
    @IBAction func uploadPost(sender: AnyObject) {
        
        let mapData: Dictionary<String,String> = [
            "name" : "David",
            "address" : "216 Sweet Gum Rd"
        ]
        postInfoToDatabase(mapData)
    }
    
    //MARK : TableViewDelegate/DataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: LoanTableCell = tableView.dequeueReusableCellWithIdentifier("LoanTableCell") as! LoanTableCell
        
        let loan: Loan = self.loanArray[indexPath.row]
        cell.nameLabel.text = loan.name
        cell.locationLabel.text = loan.location
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.loanArray.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //MARK: NSURLSessionDelegate
    
    
}

