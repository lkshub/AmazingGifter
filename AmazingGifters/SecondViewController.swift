//
//  SecondViewController.swift
//  AmazingGifters
//
//  Created by 陆恺 on 6/18/16.
//  Copyright © 2016 Kai Lu. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    var contactsList:[Dictionary<String,String>?] = []
    
    var facebookID:String?

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var contactsView: UIView!
    
    @IBOutlet weak var progressView: UIView!
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            contactsView.hidden = false
            progressView.hidden = true
        case 1:
            contactsView.hidden = true
            progressView.hidden = false
        default:
            break
        }
    }
    
    private func populateContacts(){
        
    }
    private func populateProgress(){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateContacts();
        populateProgress();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

