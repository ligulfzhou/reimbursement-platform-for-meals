//
//  AddCanfeiViewController.swift
//  Dingcan
//
//  Created by ligulfzhou on 3/3/16.
//  Copyright © 2016 ligulfzhou. All rights reserved.
//

import UIKit
import Alamofire

class AddCanfeiViewController: UIViewController, UITextFieldDelegate {

    var datePickerView:UIDatePicker!
    var moneyTextField:UITextField!
    var addCanfeiButton:UIButton!
    var closeButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        datePickerView = UIDatePicker(frame: CGRect(x: 0, y: 100, width: view.bounds.width, height: 200))
        datePickerView.datePickerMode = .Date
        view.addSubview(datePickerView)
        
        moneyTextField = UITextField(frame: CGRect(x: 0, y: 300, width: view.bounds.width, height: 50))
        moneyTextField.delegate = self
        moneyTextField.borderStyle = .RoundedRect
        moneyTextField.keyboardType = .NumberPad
        view.addSubview(moneyTextField)
        
        addCanfeiButton = UIButton(type: .System)
        addCanfeiButton.frame = CGRect(x: 0, y: 350, width: view.bounds.width, height: 50)
        addCanfeiButton.setTitle("添加", forState: .Normal)
        addCanfeiButton.addTarget(self, action: "addCanfei:", forControlEvents: .TouchUpInside)
        view.addSubview(addCanfeiButton)
        
        closeButton = UIButton(type: .System)
//        closeButton.frame.origin = CGPoint(x: view.bounds.width - 30, y: 50)
        closeButton.frame = CGRect(x: view.bounds.width - 50, y: 50, width: 50, height: 50)
                closeButton.setImage(UIImage(named: "shutdown"), forState: .Normal)
//        closeButton.setTitle("close", forState: .Normal)
        closeButton.addTarget(self, action: "closeVC:", forControlEvents: .TouchUpInside)
        view.addSubview(closeButton)
    }

    //MARK: closeButton touchupinside
    func closeVC(sender: UIButton){
        self.dismissViewControllerAnimated(true) { () -> Void in
            NSLog("ddddd")
        }
    }
    
    //MARK: addCanfeiButton target
    func addCanfei(sender: UIButton){
        let money:String? = moneyTextField.text
        if money == nil{
            NSLog("未输入餐费")
            return
        }
        let date:NSDate = datePickerView.date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString:String = dateFormatter.stringFromDate(date)
        
        addCanfeiApiWithCanfei(money!, andDate: dateString)
    }
    
    func addCanfeiApiWithCanfei(canfei:String, andDate date:String){
        let token:String? = NSUserDefaults.standardUserDefaults().stringForKey("token")
        
        let headers = ["Authorization": "Basic \(token!)"]
        Alamofire.request(.POST, "http://192.168.1.100:8888/api/add_canfei", parameters: ["date": date, "money": canfei], encoding: .URL, headers: headers).validate().responseJSON { response in
            NSLog("\(response)")
        }
        
        self.dismissViewControllerAnimated(true) { () -> Void in
        }
    }
    
    //MARK: money textfield delegates
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
