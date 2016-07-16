//
//  GiftSearchUIViewController.swift
//  
//
//  Created by Chong Wu Guo on 6/29/16.
//
//



import Foundation
import UIKit

class GiftSearchUIViewController: UIViewController,NSXMLParserDelegate,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    var parser = NSXMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var title1 = NSMutableString()
    var galleryURL = NSMutableString()
    var convertedCurrentPrice = NSMutableString()
    var itemId = NSMutableString()
    var viewItemURL = NSMutableString()
    var responseString : NSString = ""
    var category = NSMutableString()
  
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
       // self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
       // self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "SearchItemCell")
      
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func beginParsing()
    {
        posts = []
        let xmldata = responseString.dataUsingEncoding(NSUTF8StringEncoding)
        parser = NSXMLParser(data: xmldata!)
        parser.delegate = self
        parser.parse()
     //   tbData!.reloadData()
    }
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        element = elementName
        if (elementName as NSString).isEqualToString("item")
        {
            elements = NSMutableDictionary()
            elements = [:]
            title1 = NSMutableString()
            title1 = ""
            galleryURL = NSMutableString()
            galleryURL = ""
            convertedCurrentPrice = NSMutableString()
            convertedCurrentPrice = ""
            itemId = NSMutableString()
            itemId = ""
            viewItemURL = NSMutableString()
            viewItemURL = ""
            category = NSMutableString()
            category = ""
        }
    }
    func parser(parser: NSXMLParser, foundCharacters string: String)
    {
        if element.isEqualToString("title") {
            title1.appendString(string)
        } else if element.isEqualToString("galleryURL") {
            galleryURL.appendString(string)
        } else if element.isEqualToString("currentPrice") {
            convertedCurrentPrice.appendString(string + " USD")
        }else if element.isEqualToString("itemId") {
            itemId.appendString(string)
        }else if element.isEqualToString("viewItemURL") {
            viewItemURL.appendString(string)
        }else if element.isEqualToString("categoryName"){
            category.appendString(string)
        }
    }
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName as NSString).isEqualToString("item") {
            if !title1.isEqual(nil) {
                elements.setObject(title1, forKey: "title")
            }
            if !galleryURL.isEqual(nil) {
                elements.setObject(galleryURL, forKey: "galleryURL")
            }
            if !convertedCurrentPrice.isEqual(nil) {
                elements.setObject(convertedCurrentPrice, forKey: "convertedCurrentPrice")
            }
            if !itemId.isEqual(nil) {
                elements.setObject(itemId, forKey: "itemId")
            }
            if !viewItemURL.isEqual(nil) {
                elements.setObject(viewItemURL, forKey: "viewItemURL")
            }
            if !category.isEqual(nil) {
                elements.setObject(category, forKey: "category")
                print(category)
            }
            posts.addObject(elements)
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       
        return posts.count
    }
    
    
    
    @IBAction func search(sender: UIButton) {
        self.tableView.reloadData()
    }
    
    
    /*

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        var cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell")!
        if(cell.isEqual(NSNull)) {
            cell = NSBundle.mainBundle().loadNibNamed("Cell", owner: self, options: nil)[0] as! UITableViewCell;
            print("tce")
        }
        cell.textLabel?.text = posts.objectAtIndex(indexPath.row).valueForKey("title") as! NSString as String
        cell.detailTextLabel?.text = posts.objectAtIndex(indexPath.row).valueForKey("galleryURL") as! NSString as String
        return cell as UITableViewCell
    }
 
*/
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "SearchTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SearchTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        cell.itemTitle?.text = posts.objectAtIndex(indexPath.row).valueForKey("title") as! NSString as String
        cell.itemPrice?.text = posts.objectAtIndex(indexPath.row).valueForKey("convertedCurrentPrice") as! NSString as String
        let url = NSURL(string: posts.objectAtIndex(indexPath.row).valueForKey("galleryURL") as! NSString as String)
        let data = NSData(contentsOfURL: url!)
        cell.itemImage.contentMode = .ScaleAspectFit
        cell.itemImage.image = UIImage(data: data!)
        return cell
    }

    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print(searchBar.text)
        
        let headers = [
            "cache-control": "no-cache",
            "postman-token": "99feddfb-2e37-22b4-2e0f-edfec3cffe6b"
        ]
        let requestString1 = "http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SERVICE-VERSION=1.0.0&SECURITY-APPNAME=chongguo-AmazingG-PRD-199ea60ea-41dab7fe&RESPONSE-DATA-FORMAT=XML&REST-PAYLOAD=&keywords="
        let searchKeyword = searchBar.text
        let requestString2:String = searchKeyword!.stringByAddingPercentEncodingWithAllowedCharacters( NSCharacterSet.URLQueryAllowedCharacterSet())!
        let requestString3 = "&paginationInput.entriesPerPage=50"
        
        let request = NSMutableURLRequest(URL: NSURL(string: requestString1 + requestString2 + requestString3)!,
                                          cachePolicy: .UseProtocolCachePolicy,
                                          timeoutInterval: 10.0)

        /*
        let request = NSMutableURLRequest(URL: NSURL(string: "http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SERVICE-VERSION=1.0.0&SECURITY-APPNAME=chongguo-AmazingG-PRD-199ea60ea-41dab7fe&RESPONSE-DATA-FORMAT=XML&REST-PAYLOAD=&keywords=harry%20potter%20phoenix&paginationInput.entriesPerPage=10")!,
                                          cachePolicy: .UseProtocolCachePolicy,
                                          timeoutInterval: 10.0)
         */
        request.HTTPMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                _ = response as? NSHTTPURLResponse
                self.responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                //print("responseString = \(self.responseString)")
                self.beginParsing()
                self.tableView.reloadData()
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            }
        })

        dataTask.resume()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowItemDetailSegue"
        {
            if let destinationVC = segue.destinationViewController as? SearchItemDetailViewController {
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPathForCell(cell) {
                    destinationVC.itemDic = posts[indexPath.row] as! NSMutableDictionary
                  
                }
            }
        }
    }
    
}



