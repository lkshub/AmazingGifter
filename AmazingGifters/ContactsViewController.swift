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
    
    fileprivate var tappedUser : User!
    fileprivate let brain  = dataBrain.sharedDataBrain
    fileprivate var contacts : [User] = []{
        didSet{
            self.tableView.reloadData()
            
        }
    }
    fileprivate var searchText:String?{
        didSet{
            //contacts.removeAll()
            searchForContacts()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination
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
    
    fileprivate func searchForContacts(){
        var contacts : [User] = []
        if let text = searchText, !text.isEmpty{
            for user in brain.user.contactsList{
                if let profile = user.profile{
                    let name = profile["name"] as! String
                    if name.range(of: text) != nil{
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
        //searchBar.showsCancelButton = true
    }

    override func viewDidAppear(_ animated: Bool) {
        self.contacts = allContacts()

    }
    
    fileprivate func allContacts()->[User]{
        var contacts : [User] = []
        for contact in brain.user.contactsList{
            if contact.profile != nil{
                contacts.append(contact)
            }
        }
        return contacts
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchText = ""
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contacts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contacts", for: indexPath) as! ContactsTableViewCell
        
        let contact = contacts[indexPath.row]
        
        
        cell.contactName?.text = contact.profile!["name"] as? String
        if let url = contact.profile!["picture_url"] {
            print("get picture url!")
            let thisURL = URL(string: url as! String)
            if let data = try? Data(contentsOf: thisURL!){
                cell.contactPicture.image = UIImage(data:data)
            }
        }
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tappedUser = contacts[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: false)
        performSegue(withIdentifier: "showFriendGifts", sender: nil)

    }

    
}
