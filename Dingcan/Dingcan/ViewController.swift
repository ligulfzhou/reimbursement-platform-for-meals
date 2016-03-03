//
//  ViewController.swift
//  Dingcan
//
//  Created by ligulfzhou on 2/18/16.
//  Copyright © 2016 ligulfzhou. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire

class ViewController: UIViewController, UITextFieldDelegate {

    var tokenIdentifier:String = "token"
    var contentScrollView:UIScrollView?
    var welcomeLable:UILabel?
    var mobileTextField: UITextField?
    var passwordTextField: UITextField?
    var loginButton:UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let userLogined = checkUserLogin()
        if userLogined != nil {
            NSLog("已登录")
            print(NSUserDefaults.standardUserDefaults().stringForKey("token"))
            goToDingcanController()
        }else{
            NSLog("未登陆")
            layoutView()
        }
    }

    func layoutView(){
        contentScrollView = UIScrollView(frame: view.bounds)
        contentScrollView?.contentSize = view.bounds.size
        view.addSubview(contentScrollView!)
        
        
        welcomeLable = UILabel()
        welcomeLable?.textAlignment = .Center
        welcomeLable?.text = "welcome"
        contentScrollView!.addSubview(welcomeLable!)
        welcomeLable?.snp_makeConstraints(closure: { (make) -> Void in
            make.top.equalTo(contentScrollView!).offset(50)
            make.left.equalTo(contentScrollView!).offset(20)
            make.right.equalTo(contentScrollView!).offset(-20)
            make.height.equalTo(40)
            make.centerX.equalTo(contentScrollView!)
        })

        mobileTextField = UITextField()
        mobileTextField?.borderStyle = .RoundedRect
        mobileTextField?.returnKeyType = .Next
        mobileTextField?.placeholder = "Mobile: "
        mobileTextField?.delegate = self
        contentScrollView!.addSubview(mobileTextField!)
        mobileTextField?.snp_makeConstraints(closure: { (make) -> Void in
            make.top.equalTo(welcomeLable!).offset(40)
            make.left.equalTo(contentScrollView!).offset(20)
            make.right.equalTo(contentScrollView!).offset(-20)
            make.height.equalTo(40)
        })

        passwordTextField = UITextField()
        passwordTextField?.borderStyle = .RoundedRect
        passwordTextField?.returnKeyType = .Done
        passwordTextField?.placeholder = "Password: "
        passwordTextField?.delegate = self
        contentScrollView!.addSubview(passwordTextField!)
        passwordTextField?.snp_makeConstraints(closure: { (make) -> Void in
            make.top.equalTo(mobileTextField!).offset(50)
            make.left.equalTo(contentScrollView!).offset(20)
            make.right.equalTo(contentScrollView!).offset(-20)
            make.height.equalTo(40)
        })

        loginButton = UIButton(type: .System)
        loginButton?.setTitle("Login", forState: .Normal)
        loginButton?.addTarget(self, action: "checkLogin:", forControlEvents: .TouchUpInside)
        contentScrollView!.addSubview(loginButton!)
        loginButton?.snp_makeConstraints(closure: { (make) -> Void in
            make.top.equalTo(passwordTextField!).offset(50)
            make.left.equalTo(contentScrollView!).offset(20)
            make.right.equalTo(contentScrollView!).offset(-20)
            make.height.equalTo(40)
        })
    }
    
    func goToDingcanController(){
        let navigationController = UINavigationController(rootViewController: DingcanViewController())
//        presentViewController(navigationController, animated: true) { () -> Void in }
        UIApplication.sharedApplication().delegate?.window??.rootViewController = navigationController
    }

    func checkUserLogin() -> String?{
        let userLogin = NSUserDefaults.standardUserDefaults().valueForKey("token") as? String
        return userLogin
    }
    
    func checkLogin(sender:UIButton){
        let mobile = mobileTextField?.text
        let password = passwordTextField?.text
        if mobile == nil || password == nil{
            NSLog("还没有填写表单")
            return
        }else{
            loginWithMobile(mobile!, andPassword: password!)
        }
    }
    
    func loginWithMobile(mobile: String, andPassword password:String){
        Alamofire.request(.POST, "http://192.168.1.100:8888/api/login", parameters: ["mobile": mobile, "password": password], encoding: .URL, headers: nil).validate().responseJSON { [unowned self]response in
            switch response.result {
            case .Success:
                NSUserDefaults.standardUserDefaults().setValue(response.result.value?["user"]?!["token"], forKey: "token")
                self.goToDingcanController()
                
            case .Failure(let error):
                print("登陆失败\(error)， 请稍后重试")
            }
        }
    }
    
    //MARK: textfield delegate
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
        if textField.placeholder == "Password: " {
            if mobileTextField?.text != nil{
                checkLogin(loginButton!)
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if string == "\n"{
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidDisappear(animated: Bool) {
        NSLog("disappear.......")
    }
}
