//
//  SearchItemDetailViewController.swift
//  AmazingGifters
//
//  Created by Chong Wu Guo on 7/5/16.
//  Copyright © 2016 Kai Lu. All rights reserved.
//

import UIKit

class SearchItemDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var itemImage: UIImageView!

    @IBAction func pickThisAction(sender: AnyObject) {
    }
    @IBAction func openURLAction(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: itemDic["viewItemURL"] as! String)!)
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var openURLButton: UIButton!
    var itemDic = NSMutableDictionary()
    
    var table = [String]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let url = NSURL(string: itemDic["galleryURL"] as! NSString as String)
        let data = NSData(contentsOfURL: url!)
        itemImage.contentMode = .ScaleAspectFit
        itemImage.image = UIImage(data: data!)
        table.append(itemDic["itemId"] as! String)
        table.append(itemDic["title"] as! String)
        table.append(itemDic["convertedCurrentPrice"] as! String)
        tableView.rowHeight = UITableViewAutomaticDimension

        self.tableView.reloadData()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print("testing333")

        print(table.count)
        return table.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "itemMenuCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SearchItemDetailTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        cell.rightLabel?.text = table[indexPath.row]
        switch indexPath.row {
            case 0:
                cell.leftLabel.text = "Item ID"
                print("lable1")
            case 1:
                cell.leftLabel.text = "Item Name"
               // cell.rightLabel.numberOfLines = 3
                print("lable2")
            case 2:
                cell.leftLabel.text = "Price"
                cell.leftLabel.sizeToFit()
                tableView.rowHeight = UITableViewAutomaticDimension
                print("lable3")
            default:  print(indexPath.row)
        
        }
        print("testing")
        print(cell.rightLabel?.text)
        return cell
    }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        if indexPath.row == 1 {
//            print("testinggg")
//            print(UITableViewAutomaticDimension)
//            return UITableViewAutomaticDimension
//        } else {
//            return UITableViewAutomaticDimension
//        }
//    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "pickThisSegue"
        {
            if let destinationVC = segue.destinationViewController as? AddGiftTableViewContonller {
                
                destinationVC.searchItem = itemDic
                destinationVC.picked = true
                
            }
        }
    }
    
}