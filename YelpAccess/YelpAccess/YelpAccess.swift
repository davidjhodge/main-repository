//
//  YelpAccess.swift
//  YelpAccess
//
//  Created by David Hodge on 3/13/15.
//  Copyright (c) 2015 Genesis Apps, LLC. All rights reserved.
//

import UIKit
import Foundation

class YelpAccess: NSObject {
    var consumer: OAConsumer = OAConsumer()
    var requestToken: OAToken = OAToken()
    var accessToken: OAToken = OAToken()
    
    //Uses OAuth to communicate with Yelp API and returns an array of data from Yelp
    func getYelpData() -> Array<String>
    {
        fetchUnauthorizedRequestToken()

        return Array<String>()
    }
    
    func fetchUnauthorizedRequestToken()
    {
        //Get Unauthorized Request Token
        consumer = OAConsumer(key: "90xNGJslDMbn9VZZyKGHXg", secret: "5OlQlVUn8ZFdp_mDNFuXELFh6rc")
        let url: NSURL = NSURL(string: "http://genesisappsonline.com")!
        let request: OAMutableURLRequest = OAMutableURLRequest(
            URL: url,
            consumer: consumer,
            token: nil,
            realm: nil,
            signatureProvider: nil)
        
        request.HTTPMethod = "POST"
        
        let fetcher: OADataFetcher = OADataFetcher()
        fetcher.fetchDataWithRequest(request, delegate: self, didFinishSelector: "requestTokenTick:didFinishWithData:", didFailSelector: "requestTokenTicket:didFailWithError:")
    }
    
    //Unauthorized Request Delegate Methods
    func requestTokenTicket(ticket: OAServiceTicket, didFinishWithData data: NSData)
    {
        if ticket.didSucceed
        {
            if let responseBody: String = NSString(data: data, encoding: NSUTF8StringEncoding) as? String
            {
                requestToken = OAToken(HTTPResponseBody: responseBody)
            }
        }
     
        //Authorize the Request Token
        authorizeRequestToken()
    }
    
    func requestTokenTicken(ticket: OAServiceTicket, didFailWithError error: NSError)
    {
        if !ticket.didSucceed
        {
            println(error, error.localizedDescription)
        }
    }
    
    func authorizeRequestToken()
    {
        let url: NSURL = NSURL(string: "example.authorize.com")!
        UIApplication.sharedApplication().openURL(url)
    }
    
    func obtainAccessToken()
    {
        //Get Unauthorized Request Token
        let url: NSURL = NSURL(string: "Example")!
        let request: OAMutableURLRequest = OAMutableURLRequest(
            URL: url,
            consumer: consumer,
            token: requestToken,
            realm: nil,
            signatureProvider: nil)
        
        request.HTTPMethod = "POST"
        
        let fetcher: OADataFetcher = OADataFetcher()
        fetcher.fetchDataWithRequest(request, delegate: self, didFinishSelector: "requestTokenTick:didFinishWithData:", didFailSelector: "requestTokenTicket:didFailWithError:")
    }
    
    //Authorized Token Delegate Methods
    func accessTokenTicket(ticket: OAServiceTicket, didFinishWithData data: NSData)
    {
        if ticket.didSucceed
        {
            if let responseBody: String = NSString(data: data, encoding: NSUTF8StringEncoding) as? String
            {
                accessToken = OAToken(HTTPResponseBody: responseBody)
                
                //Store AccessToken in Keychain
                accessToken.storeInUserDefaultsWithServiceProviderName("YelpAccess", prefix: "Yelp.com")
            }
        }
        
        //Authorize the Request Token
        accessResources()
    }
    
    func accessTokenTicket(ticket: OAServiceTicket, didFailWithError error: NSError)
    {
        if !ticket.didSucceed
        {
            println(error, error.localizedDescription)
        }
    }
    
    func accessResources()
    {
        let url: NSURL = NSURL(string: "http://api.yelp.com/v2/search?")!
        let request: OAMutableURLRequest = OAMutableURLRequest(
            URL: url,
            consumer: consumer,
            token: accessToken,
            realm: nil,
            signatureProvider: OAPlaintextSignatureProvider())
        
        request.HTTPMethod = "GET"
        
        let termParam = OARequestParameter(name: "term", value: "cream puffs")
        let locationParam = OARequestParameter(name: "location", value: "San Francisco")
        let params: Array<OARequestParameter> = [termParam, locationParam]
        request.parameters = params
        
        let fetcher: OADataFetcher = OADataFetcher()
        fetcher.fetchDataWithRequest(request, delegate: self, didFinishSelector: "apiTicket:didFinishWithData:", didFailSelector: "apiTicket:didFailWithError:")
    }
    
    func apiTicket(ticket: OAServiceTicket, didFinishWithData data: NSData)
    {
        if ticket.didSucceed
        {
            
        }
    }
    
    func apiTicket(ticket: OAServiceTicket, didFailWithError error: NSError)
    {
        if !ticket.didSucceed
        {
            println(error, error.localizedDescription)
        }
    }

    //MARK : Existing Access Token
    func retrieveExistingAccessToken() -> OAToken
    {
        let accessToken: OAToken = OAToken(userDefaultsUsingServiceProviderName:"YelpAccess", prefix:"Yelp.com")
        return accessToken
    }

}
