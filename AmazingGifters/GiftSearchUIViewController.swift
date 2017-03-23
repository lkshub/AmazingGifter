//
//  GiftSearchUIViewController.swift
//  
//
//  Created by Chong Wu Guo on 6/29/16.
//
//



import Foundation
import UIKit

class GiftSearchUIViewController: UIViewController,XMLParserDelegate,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    var parser = XMLParser()
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
        let xmldata = responseString.data(using: String.Encoding.utf8.rawValue)
        parser = XMLParser(data: xmldata!)
        parser.delegate = self
        parser.parse()
     //   tbData!.reloadData()
    }
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        element = elementName as NSString
        if (elementName as NSString).isEqual(to: "item")
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
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        if element.isEqual(to: "title") {
            title1.append(string)
        } else if element.isEqual(to: "galleryURL") {
            galleryURL.append(string)
        } else if element.isEqual(to: "currentPrice") {
            convertedCurrentPrice.append(string + " USD")
        }else if element.isEqual(to: "itemId") {
            itemId.append(string)
        }else if element.isEqual(to: "viewItemURL") {
            viewItemURL.append(string)
        }else if element.isEqual(to: "categoryName"){
            category.append(string)
        }
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName as NSString).isEqual(to: "item") {
            if !title1.isEqual(nil) {
                elements.setObject(title1, forKey: "title" as NSCopying)
            }
            if !galleryURL.isEqual(nil) {
                elements.setObject(galleryURL, forKey: "galleryURL" as NSCopying)
            }
            if !convertedCurrentPrice.isEqual(nil) {
                elements.setObject(convertedCurrentPrice, forKey: "convertedCurrentPrice" as NSCopying)
            }
            if !itemId.isEqual(nil) {
                elements.setObject(itemId, forKey: "itemId" as NSCopying)
            }
            if !viewItemURL.isEqual(nil) {
                elements.setObject(viewItemURL, forKey: "viewItemURL" as NSCopying)
            }
            if !category.isEqual(nil) {
                elements.setObject(category, forKey: "category" as NSCopying)
                print(category)
            }
            posts.add(elements)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       
        return posts.count
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "SearchTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SearchTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        cell.itemTitle?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "title") as! NSString as String
        cell.itemPrice?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "convertedCurrentPrice") as! NSString as String
        let url = URL(string: (posts.object(at: indexPath.row) as AnyObject).value(forKey: "galleryURL") as! NSString as String)
        let data = try? Data(contentsOf: url!)
        cell.itemImage.contentMode = .scaleAspectFit
        cell.itemImage.image = UIImage(data: data!)
        return cell
    }

    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let headers = [
            "cache-control": "no-cache",
            "postman-token": "99feddfb-2e37-22b4-2e0f-edfec3cffe6b"
        ]
        let requestString1 = "http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SERVICE-VERSION=1.0.0&SECURITY-APPNAME=chongguo-AmazingG-PRD-199ea60ea-41dab7fe&RESPONSE-DATA-FORMAT=XML&REST-PAYLOAD=&keywords="
        let searchKeyword = searchBar.text
        let requestString2:String = searchKeyword!.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let requestString3 = "&paginationInput.entriesPerPage=50"
        
        let request = NSMutableURLRequest(url: URL(string: requestString1 + requestString2 + requestString3)!,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)

        /*
        let request = NSMutableURLRequest(URL: NSURL(string: "http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SERVICE-VERSION=1.0.0&SECURITY-APPNAME=chongguo-AmazingG-PRD-199ea60ea-41dab7fe&RESPONSE-DATA-FORMAT=XML&REST-PAYLOAD=&keywords=harry%20potter%20phoenix&paginationInput.entriesPerPage=10")!,
                                          cachePolicy: .UseProtocolCachePolicy,
                                          timeoutInterval: 10.0)
         */
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let dataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            } else {
                _ = response as? HTTPURLResponse
                self.responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                //print("responseString = \(self.responseString)")
                self.beginParsing()
                self.tableView.reloadData()
                DispatchQueue.main.async(execute: { () -> Void in
                    self.tableView.reloadData()
                })
            }
        })

        dataTask.resume()
        self.searchBar.endEditing(true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowItemDetailSegue"
        {
            if let destinationVC = segue.destination as? SearchItemDetailViewController {
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                    destinationVC.itemDic = posts[indexPath.row] as! NSMutableDictionary
                  
                }
            }
        }
    }
    
}



