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
    
    @IBAction func pushed(_ sender: Any){
        
    }
    
    func tfidf(sms: String) -> MLMultiArray{
        let wordsFile = Bundle.main.path(forResource: "words_ordered", ofType: "txt")
        let smsFile = Bundle.main.path(forResource: "SMSSpamCollection", ofType: "txt")
        do {
            let wordsFileText = try String(contentsOfFile: wordsFile!, encoding: String.Encoding.utf8)
            var wordsData = wordsFileText.components(separatedBy: .newlines)
            wordsData.removeLast() // Trailing newline.
            let smsFileText = try String(contentsOfFile: smsFile!, encoding: String.Encoding.utf8)
            var smsData = smsFileText.components(separatedBy: .newlines)
            smsData.removeLast() // Trailing newline.
            let wordsInMessage = sms.split(separator: " ")
            var vectorized = try MLMultiArray(shape: [NSNumber(integerLiteral: wordsData.count)], dataType: MLMultiArrayDataType.double)
            
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

