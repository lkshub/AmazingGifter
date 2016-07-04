//
//  FirstViewController.swift
//  AmazingGifters
//
//  Created by 陆恺 on 6/18/16.
//  Copyright © 2016 Kai Lu. All rights reserved.
//

import UIKit

class FirstViewController: UITableViewController {
    
    var facebookID:String?
    let brain = dataBrain.sharedDataBrain
    
    override func viewDidLoad() {
           super.viewDidLoad()
            print(brain.user.profile["name"]!)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
}

