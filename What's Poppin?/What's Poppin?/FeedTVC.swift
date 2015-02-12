//
//  FeedTVC.swift
//  What's Poppin?
//
//  Created by David Hodge on 2/1/15.
//  Copyright (c) 2015 Genesis Apps, LLC. All rights reserved.
//

import UIKit
import CoreLocation

class FeedTVC: UITableViewController {
    let barArray: NSMutableArray = NSMutableArray();
    var coordinates: (latitude: Double, longitude: Double) = (latitude: 0, longitude: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        //super.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: "HelveticaNeue-Light", NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationItem.title = "WhatsPoppin"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        let mondayHours: Hours = Hours(openingTime: "08:00", closingTime: "02:00")
        let saturdayHours: Hours = Hours(openingTime: "08:00", closingTime: "04:00")
        let pourHouseHoursDictionary: Dictionary<String,Hours> = ["monday" : mondayHours, "saturday" : saturdayHours]
        
        let birdDogMondayHours: Hours = Hours(openingTime: "07:00", closingTime: "12:00")
        let birdDogSaturdayHours: Hours = Hours(openingTime: "07:30", closingTime: "02:30")
        let birdDogHoursDictionary: Dictionary<String,Hours> = ["monday" : birdDogMondayHours, "saturday" : birdDogSaturdayHours]
        
        let specialsArray: Array<Array<String>> = Array<Array<String>>()
        
        let dict1: Dictionary<String,Any> = createBusinessDictionary(
            "Pour House",
            headcount: 143,
            capacity: 200,
            rating: 3.6,
            hours: pourHouseHoursDictionary as Dictionary,
            address: "800 Harden Street, Columbia, SC 29205",
            position: (34.000595, -81.016401),
            specials: specialsArray,
            photos: Array()
        )
        let pourHouse: Business = businessWithAttributes(dict1)
        barArray.addObject(pourHouse);
        
        let dict2: Dictionary<String,Any> = createBusinessDictionary(
            "Bird Dog",
            headcount: 78,
            capacity: 140,
            rating: 4.4,
            hours: birdDogHoursDictionary as Dictionary,
            address: "715 Harden Street, Columbia, SC 29205",
            position: (33.999253 ,-81.01629),
            specials: specialsArray,
            photos: Array()
        )
        let birdDog: Business = businessWithAttributes(dict2)
        barArray.addObject(birdDog)
        
        //Print Bars
        for business in barArray
        {
            if let currentBusiness = business as? Business
            {
                currentBusiness.print()
                println()
            }
        }
        
        //Accesses Instance Variable called "coordinates"
        //Will be used only when business is created, because it is quicker to refer to lat/long then look up all the addresses
        getCoordinatesFromAddress(pourHouse.address)
    }
    
    func getCoordinatesFromAddress(address: String) -> Void
    {
        println(address)
        let geocoder: CLGeocoder = CLGeocoder()
        var addressLatitude: CLLocationDegrees = 0
        var addressLongitude: CLLocationDegrees = 0
        
        geocoder.geocodeAddressString(address, { (placemarks: [AnyObject]!, error: NSError!) -> Void in
            if let geocodedPlacemark = placemarks?[0] as? CLPlacemark
            {
                //CLLocationDegrees is a type alias for Double
                addressLatitude = geocodedPlacemark.location.coordinate.latitude
                addressLongitude = geocodedPlacemark.location.coordinate.longitude
                self.coordinates = (latitude: addressLatitude, longitude: addressLongitude)
                
                println("Latitude: \(self.coordinates.latitude), Longitude: \(self.coordinates.longitude)")
            }
        })
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return barArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as BusinessCell

        // Configure the cell...
        let business: Business = barArray.objectAtIndex(indexPath.row) as Business
        
        cell.nameLabel.text = business.name
        cell.headcountLabel.text = String(business.headcount)

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("DetailSegue", sender: tableView)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if (segue.identifier == "DetailSegue")
        {
            let bdvc: BusinessDetailsVC = segue.destinationViewController as BusinessDetailsVC
            let ip: NSIndexPath = self.tableView.indexPathForSelectedRow()!
            
            let business: Business = self.barArray.objectAtIndex(ip.row) as Business
            
            bdvc.business = business //Show the details of the business that the selected cell represents
            
            //Set back button to have no title; Must be done here to work
            var backButton: UIBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = backButton
        }
    }
    

}
