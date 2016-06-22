//
//  AddGiftUIViewController.swift
//  AmazingGifters
//
//  Created by Chong Wu Guo on 6/22/16.
//  Copyright © 2016 Kai Lu. All rights reserved.
//

import UIKit

class AddGiftUIViewController: UIViewController {
    
    @IBAction func pickDueDateValue(sender: UIButton) {
         datePickerChanged()
    }
    @IBOutlet weak var pickDueDate: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!

    
    var datePickerHidden = true
    
    @IBAction func datePickerValue(sender: UIDatePicker) {
        datePickerChanged()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        datePickerChanged ()

        let tap = UITapGestureRecognizer(target: self, action: #selector(AddGiftUIViewController.tapFunction(_:)))
                pickDueDate.addGestureRecognizer(tap)
        datePicker.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func datePickerChanged () {
      
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        let dateString = dateFormatter.stringFromDate(datePicker.date)
        pickDueDate.setTitle("\(dateString)", forState: .Normal)
    }
    func tapFunction(sender:UITapGestureRecognizer) {
        toggleDatepicker()
    }
    
    func toggleDatepicker() {
        
        datePickerHidden = !datePickerHidden
        datePickerChanged()
        if datePickerHidden {
            datePicker.hidden = true
        }else{
            datePicker.hidden = false;
        }
    }
    
    
}

