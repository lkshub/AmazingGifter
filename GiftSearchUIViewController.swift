//
//  GiftSearchUIViewController.swift
//  
//
//  Created by Chong Wu Guo on 6/29/16.
//
//



import Foundation

let headers = [
    "cache-control": "no-cache",
    "postman-token": "ff477cb1-97a4-11fe-a8d1-140a62392b35"
]
let map = {"tes23":
    let postData = NSData(data: {"tes23": "tt"}.dataUsingEncoding(NSUTF8StringEncoding)!)
    
    var request = NSMutableURLRequest(URL: NSURL(string: "http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SERVICE-VERSION=1.0.0&SECURITY-APPNAME=chongguo-AmazingG-PRD-199ea60ea-41dab7fe&RESPONSE-DATA-FORMAT=XML&REST-PAYLOAD=&keywords=harry%2520potter%2520phoenix&paginationInput.entriesPerPage=10")!,
                                      cachePolicy: .UseProtocolCachePolicy,
                                      timeoutInterval: 10.0)
    request.HTTPMethod = "GET"
    request.allHTTPHeaderFields = headers
    request.HTTPBody = postData
    
    let session = NSURLSession.sharedSession()
    let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            print(error)
        } else {
            let httpResponse = response as? NSHTTPURLResponse
            println(httpResponse)
        }
    })
    
    dataTask.resume()