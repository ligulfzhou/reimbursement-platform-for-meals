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
    let month:String
    let day:String
    let money:Int
    let mobile:String
    
    init(username: String, andMonth month:String, andDay day:String, andCanfei canfei:Int, andMobile mobile:String){
        self.username = username
        self.month = month
        self.day = day
        self.money = canfei
        self.mobile = mobile
    }
    
    init(json: [String:AnyObject]) {
        self.username = json["username"] as! String
        self.month = json["month"] as! String
        self.day = json["day"] as! String
        self.money = json["money"] as! Int
        self.mobile = json["mobile"] as! String
    }
}
