//
//  ViewController.swift
//  SpamFilteriOSApp
//
//  Created by Bhavin on 01/04/18.
//  Copyright © 2018 Bhavin. All rights reserved.
//

import UIKit
import Messages
import CoreML


class ViewController: MSMessagesAppViewController {
    @IBOutlet weak var classifiedLabel: UILabel!
    @IBOutlet weak var textForClassification: UITextField!
    
    @IBOutlet weak var classifyButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

