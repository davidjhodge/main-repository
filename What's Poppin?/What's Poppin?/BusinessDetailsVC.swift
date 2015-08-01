//
//  BusinessDetailsVC.swift
//  What's Poppin?
//
//  Created by David Hodge on 2/1/15.
//  Copyright (c) 2015 Genesis Apps, LLC. All rights reserved.
//

import UIKit
import MapKit

class BusinessDetailsVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var business: Business!
    @IBOutlet weak var headcountLabel: UILabel!
    @IBOutlet weak var capacityLabel: UILabel!
    @IBOutlet weak var starRatingView: FloatRatingView!
    @IBOutlet weak var openClosedLabel: UILabel!
    @IBOutlet weak var addressButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addressButton.titleLabel?.adjustsFontSizeToFitWidth = true
        addressButton.titleLabel?.minimumScaleFactor = 0.75
        addressButton.layer.cornerRadius = 0.5 * addressButton.bounds.size.height
        
        configureAttributes()
    }

    func configureAttributes()
    {
        navigationItem.title = business.name
        headcountLabel.text = String(business.headcount)
        capacityLabel.text = "out of \(business.capacity)"
        starRatingView.rating = business.rating
        setOpenClosedLabel()
        //Ensures button title is dynamically set when view is loaded and does not change under any circumstances
        addressButton.titleLabel?.text = business.address
        addressButton.setTitle(business.address, forState: UIControlState.Normal)
        addressButton.setTitle(business.address, forState: UIControlState.Highlighted)

        //Photos
        getPhotos()
    }
    
    func getPhotos()
    {
        let image: UIImage = UIImage(named: "Pour House Image")!
        business.photos = [image, image, image, image, image]
    }
    
    func setOpenClosedLabel()
    {
        let hours: Hours = business.hours["monday"] as Hours
        let open: Bool = isBarOpen(startTimeString: hours.openingTime, endTimeString: hours.closingTime)
        
        if (open) {
            self.openClosedLabel.text = "Closes at \(hours.closingTime)"
        } else {
            //If bar is not open, I should not include it in the list of bars
            self.openClosedLabel.text = "Closed"
        }
    }
    
    func isBarOpen(startTimeString startTimeAsString: String, endTimeString endTimeAsString: String) -> Bool
    {
        //Indicates bar is closed
        if (startTimeAsString == "-1" || endTimeAsString == "-1")
        {
            return false
        }
        
        func minutesSinceMidnight(date: NSDate) -> Int
        {
            let gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
            let unitFlags = NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit
            let components: NSDateComponents = gregorian.components(unitFlags, fromDate: date)
            
            return 60 * components.hour + components.minute
        }
        
        //Format date to hours:minutes
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm"
        
        //Set Locale
        let locale: NSLocale = NSLocale.currentLocale()
        
        //Get current time as string
        let nowTimeString: String = formatter.stringFromDate(NSDate())
        
        //Start Time
        let startDate: NSDate = formatter.dateFromString(startTimeAsString)!
        let startTime: Int = minutesSinceMidnight(startDate)
        
        //End Time
        let endDate: NSDate = formatter.dateFromString(endTimeAsString)!
        var endTime: Int = minutesSinceMidnight(endDate)
        
        //Store initial end time
        var oldEndTime: Int = endTime
        
        //If business stays open past midnight
        if (startTime > endTime)
        {
            endTime += (24*60)
        }
        
        //Now Time
        let nowDate: NSDate = formatter.dateFromString(nowTimeString)!
        var nowTime: Int = minutesSinceMidnight(nowDate)
        
        //Store initial now time
        var oldNowTime: Int = nowTime
        
        if (startTime > oldEndTime && nowTime < endTime)
        {
            nowTime += (24*60)
        }
        
        func print()
        {
            println("Start Time: \(startTime)")
            println("End Time: \(endTime)")
            println("Now Time: \(nowTime)")
            println("Old End Time: \(oldEndTime)")
            println("Old Now Time: \(oldNowTime)")
        }
        
        func isOpen(startingTime startTime: Int, endingTime endTime: Int, currentTime nowTime: Int) -> Bool {
            return (nowTime >= startTime) && (nowTime <= endTime)
        }
        
        return isOpen(startingTime: startTime, endingTime: endTime, currentTime: nowTime)
    }
    
    @IBAction func getDirections(sender: AnyObject) {
        showMapsAlertView()
    }
    
    func showMapsAlertView()
    {
        let alertController = UIAlertController(title: nil, message: "You want directions?", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (action) in
            self.openAppleMaps()
        }))
        
        alertController.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: { (action) in
            println("Nevermind on directions")
        }))
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func openAppleMaps()
    {
        println("Open apple maps called")
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.geocodeAddressString(business.address, {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            if let geocodedPlacemark = placemarks?[0] as? CLPlacemark
            {
                //Convert CLPlacemark to MKPlacemark
                let placemark: MKPlacemark = MKPlacemark(coordinate: geocodedPlacemark.location.coordinate, addressDictionary: geocodedPlacemark.addressDictionary)
                
                let mapItem: MKMapItem = MKMapItem(placemark: placemark)
                mapItem.name = geocodedPlacemark.name
                
                //Set directions mode to "Walking"
                let launchOptions: Dictionary = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking]
                
                //Current user location
                let currentLocationMapItem: MKMapItem = MKMapItem.mapItemForCurrentLocation()
                
                //Pass current location and destination to Apple Maps
                //Include launch options
                MKMapItem.openMapsWithItems([currentLocationMapItem, mapItem], launchOptions: launchOptions)
            }
        })
    }
    
    //MARK: - Collection View Data Source and Delegate
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return business.photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: PhotoCell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as PhotoCell
        
        cell.imageView.image = business.photos[indexPath.row]
        
        return cell
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
