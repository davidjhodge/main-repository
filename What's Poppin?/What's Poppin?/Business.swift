//
//  Business.swift
//  What's Poppin?
//
//  Created by David Hodge on 2/1/15.
//  Copyright (c) 2015 Genesis Apps, LLC. All rights reserved.
//

import UIKit

class Business: NSObject {
    var name: String
    var headcount: Int
    var capacity: Int
    var rating: Float
    var hours: Dictionary<String,AnyObject>
    var address: String
    var position: (latitude: Double, longitude: Double)
    var specials: Array< Array<String> > //Array of arrays. Multiple specials possible per day
    var photos: Array<UIImage>
    
    override init() {
        name = ""
        headcount = 0
        capacity = 0
        rating = 0
        hours = Dictionary()
        address = ""
        position = (latitude: 0, longitude: 0)
        specials = Array()
        photos = Array()
    }
    
    func print()
    {
        println("Business Name: \(name)")
        println("Headcount: \(headcount)")
        println("Capacity: \(capacity)")
        println("Rating: \(rating)")
        println("HoursArrayCount \(hours.count)")
        println("Address: \(address)")
        println("Latitude: \(position.latitude), Longitude: \(position.longitude)")
        println("SpecialsCount: \(specials.count)")
        println("Photo count: \(photos.count)")
    }
}

//Public
func businessWithAttributes(attributes: Dictionary <String,Any>) -> (Business)
{
    var business: Business = Business()

    business.name = attributes["name"] as String
    business.headcount = attributes["headcount"] as Int
    business.capacity = attributes["capacity"] as Int
    business.rating = attributes["rating"] as Float
    business.hours = attributes["hours"] as Dictionary <String,AnyObject>
    business.address = attributes["address"] as String
    business.position = attributes["position"] as (Double,Double)
    business.specials = attributes["specials"] as Array< Array<String> >
    business.photos = attributes["photos"] as Array<UIImage>
    
    return business
}

func createBusinessDictionary(
    aName: String,
    headcount currentHeadcount: Int,
    capacity aCapacity: Int,
    rating aRating: Float,
    hours hoursDictionary: Dictionary<String,AnyObject>,
    address anAddress: String,
    position aPosition: (latitude: Double, longitude: Double),
    specials specialsArray: Array< Array<String> >,
    photos thePhotos: Array<UIImage>)-> (Dictionary <String,Any>)
{
    var businessDictionary: Dictionary<String,Any> = Dictionary<String,Any>()
    
    businessDictionary["name"] = aName
    businessDictionary["headcount"] = currentHeadcount
    businessDictionary["capacity"] = aCapacity
    businessDictionary["rating"] = aRating
    businessDictionary["hours"] = hoursDictionary
    businessDictionary["address"] = anAddress
    businessDictionary["position"] = aPosition
    businessDictionary["specials"] = specialsArray
    businessDictionary["photos"] = thePhotos
    
    return businessDictionary
}

