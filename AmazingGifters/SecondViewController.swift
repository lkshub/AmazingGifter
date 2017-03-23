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
    
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            contactsView.isHidden = false
            progressView.isHidden = true
        case 1:
            contactsView.isHidden = true
            progressView.isHidden = false
        default:
            break
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

