//
//  GiftSearchUIViewController.swift
//  
//
//  Created by Chong Wu Guo on 6/29/16.
//
//



import Foundation
import UIKit

class GiftSearchUIViewController: UIViewController {
    
    var responseString : NSString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let headers = [
            "cache-control": "no-cache",
            "postman-token": "99feddfb-2e37-22b4-2e0f-edfec3cffe6b"
        ]
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SERVICE-VERSION=1.0.0&SECURITY-APPNAME=chongguo-AmazingG-PRD-199ea60ea-41dab7fe&RESPONSE-DATA-FORMAT=XML&REST-PAYLOAD=&keywords=harry%20potter%20phoenix&paginationInput.entriesPerPage=10")!,
                                          cachePolicy: .UseProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.HTTPMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? NSHTTPURLResponse
                self.responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                print("responseString = \(self.responseString)")
            }
        })
        
        dataTask.resume()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}



