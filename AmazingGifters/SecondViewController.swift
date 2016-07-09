//
//  SecondViewController.swift
//  AmazingGifters
//
//  Created by 陆恺 on 6/18/16.
//  Copyright © 2016 Kai Lu. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController,UISearchBarDelegate {
    
    
    let brain = dataBrain.sharedDataBrain

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
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

