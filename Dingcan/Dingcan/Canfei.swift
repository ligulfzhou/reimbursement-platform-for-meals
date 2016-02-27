//
//  Canfei.swift
//  Dingcan
//
//  Created by ligulfzhou on 2/27/16.
//  Copyright © 2016 ligulfzhou. All rights reserved.
//

import UIKit

class Canfei: NSObject {
    let username: String
    let date:String
    let canfei:Int
    let mobile:String
    
    init(username: String, andDate date:String, andCanfei canfei:Int, andMobile mobile:String){
        self.username = username
        self.date = date
        self.canfei = canfei
        self.mobile = mobile
    }
    
    init(json: [String:AnyObject]) {
        self.username = json["username"] as! String
        self.date = json["date"] as! String
        self.canfei = json["canfei"] as! Int
        self.mobile = json["mobile"] as! String
    }
}
