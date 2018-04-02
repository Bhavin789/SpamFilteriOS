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


class ViewController: MSMessagesAppViewController,UITextFieldDelegate {
    @IBOutlet weak var classifiedLabel: UILabel!
    @IBOutlet weak var textForClassification: UITextField!
    
    @IBOutlet weak var classifyButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        textForClassification.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotificationForHide), name: .UIKeyboardWillHide, object: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func pushed(_ sender: Any){
        print("Pressed")
        let vec = tfidf(sms: textForClassification.text!)
        do{
            let textPrediction = try MessageClassifier().prediction(message: vec).label
            print(textPrediction)
            print(try MessageClassifier().prediction(message: vec).classProbability["spam"])
            classifiedLabel.text = textPrediction
        }catch{
            classifiedLabel.text = "Sorry, No prediction"
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification){
        print("Working***********************")
        if (textForClassification.isFirstResponder && (view.frame.origin.y == 0)) {
            if let userInfo = notification.userInfo{
                if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue{
                    print(keyboardSize.height)
                    view.frame.origin.y-=100
                }
            }
        }
    }
    
    @objc func handleKeyboardNotificationForHide(notification: NSNotification){
        print("hiding*******************")
        if let userInfo = notification.userInfo{
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue{
                print(keyboardSize)
                view.frame.origin.y = 0
            }
        }
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
            for i in 0..<wordsData.count{
                let word = wordsData[i]
                if sms.contains(word){
                    var wordCount = 0
                    for substr in wordsInMessage{
                        if substr.elementsEqual(word){
                            wordCount += 1
                        }
                    }
                    let tf = Double(wordCount) / Double(wordsInMessage.count)
                    var docCount = 0
                    for sms in smsData{
                        if sms.contains(word) {
                            docCount += 1
                        }
                    }
                    let idf = log(Double(smsData.count) / Double(docCount))
                    vectorized[i] = NSNumber(value: tf * idf)
                } else {
                    vectorized[i] = 0.0
                }
            }
            return vectorized
        } catch {
            return MLMultiArray()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

