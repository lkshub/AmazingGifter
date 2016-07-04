//
//  EditMeViewController.swift
//  AmazingGifters
//
//  Created by 陆恺 on 6/27/16.
//  Copyright © 2016 Kai Lu. All rights reserved.
//

import Foundation
import UIKit


class EditMeViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func btnCancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
}