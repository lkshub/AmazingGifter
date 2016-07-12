//
//  ContactsViewController.swift
//  AmazingGifters
//
//  Created by 陆恺 on 7/7/16.
//  Copyright © 2016 Kai Lu. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var tappedUser : User!
    private let brain  = dataBrain.sharedDataBrain
    private var contacts : [User] = []{
        didSet{
            self.tableView.reloadData()
            
        }
    }
    private var searchText:String?{
        didSet{
            //contacts.removeAll()
            searchForContacts()
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationVC = segue.destinationViewController
        if let identifier =  segue.identifier{
            if let giftVC = destinationVC as? FirstViewController{
                switch identifier {
                case "showFriendGifts":
                    giftVC.user = tappedUser
                    giftVC.title = "\(tappedUser.profile!["name"] as! String)'s Gifts"
                default:
                    break
                }
            }
        }
    }
    
    private func searchForContacts(){
        var contacts : [User] = []
        if let text = searchText where !text.isEmpty{
            for user in brain.user.contactsList{
                if let profile = user.profile{
                    let name = profile["name"] as! String
                    if name.rangeOfString(text) != nil{
                        contacts.append(user)
                    }
                }
            }
            self.contacts = contacts
        }else{
            self.contacts = allContacts()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsetsMake(-65, 0, 0, 0)
    }

    override func viewDidAppear(animated: Bool) {
        self.contacts = allContacts()

    }
    
    private func allContacts()->[User]{
        var contacts : [User] = []
        for contact in brain.user.contactsList{
            if contact.profile != nil{
                contacts.append(contact)
            }
        }
        return contacts
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.contacts = allContacts()

    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contacts.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("contacts", forIndexPath: indexPath) as! ContactsTableViewCell
        
        let contact = contacts[indexPath.row]
        
        
        cell.contactName?.text = contact.profile!["name"] as? String
        if let url = contact.profile!["picture_url"] {
            print("get picture url!")
            let thisURL = NSURL(string: url as! String)
            let data = NSData(contentsOfURL: thisURL!)
            cell.contactPicture.image = UIImage(data:data!)
        }
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tappedUser = contacts[indexPath.row]
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        performSegueWithIdentifier("showFriendGifts", sender: nil)

    }

    
}
