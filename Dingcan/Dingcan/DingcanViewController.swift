//
//  DingcanViewController.swift
//  Dingcan
//
//  Created by ligulfzhou on 2/26/16.
//  Copyright © 2016 ligulfzhou. All rights reserved.
//

import UIKit
import Alamofire

class DingcanViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    var tableView:UITableView!
    var tableViewCellIdentifier = "canfeiIdentifier"
    var tableViewData:[[String:String]]!
    var segment:UISegmentedControl!
    var scrollView:UIScrollView!
    
    var total:Double!
    var data:[Canfei]? = [Canfei]()

    enum WhichMonth{
        case ThisMonth, LastMonth
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segment = UISegmentedControl(items: ["本月", "上个月"])
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: "segmentValueChanged:", forControlEvents: .ValueChanged)
        self.navigationItem.titleView = segment
        
        let rightPlusButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "rightBarPlusButtonClicked:")
        rightPlusButton.style = .Done
        self.navigationItem.rightBarButtonItem = rightPlusButton
        
        let logoutButton = UIBarButtonItem(title: "logout", style: .Plain, target: self, action: "logout:")
        self.navigationItem.leftBarButtonItem = logoutButton
        
        tableView = UITableView(frame: view.bounds, style: .Plain)
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier:tableViewCellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        fetchData(1)
    }
    
    //MARK: func logout
    func logout(sender: UIBarButtonItem){
        NSUserDefaults.standardUserDefaults().removeObjectForKey("token")
        UIApplication.sharedApplication().delegate?.window??.rootViewController = ViewController()
    }
    
    //MARK: segment target method: segmentValueChange
    func segmentValueChanged(sender: UISegmentedControl){
        let pageIndex = sender.selectedSegmentIndex

        fetchData(pageIndex)
    }
    
    //MARK: tableview datasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data!.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(tableViewCellIdentifier, forIndexPath: indexPath)

        cell.textLabel?.text = "\(self.data![indexPath.row].month)-\(self.data![indexPath.row].day) -- \(self.data![indexPath.row].money)元"
        return cell
    }
    
    func fetchData(thisMonth: Int) {
        NSLog("\(thisMonth)")
        let token:String? = NSUserDefaults.standardUserDefaults().stringForKey("token")

        let headers = ["Authorization": "Basic \(token!)"]
        Alamofire.request(.GET, "http://192.168.1.100:8888/api/statistics", parameters: ["flag": thisMonth], encoding: .URL, headers: headers).validate().responseJSON { [unowned self]response in

            switch response.result{
            case .Success:
                let statistics = response.result.value?["statistics"] as? [[String: AnyObject]]
                
                var tmp = [Canfei]()
                for item in statistics!{
                    tmp.append(Canfei(json: item))
                }
                self.data = tmp
                self.tableView.reloadData()
            case .Failure:
                print("errrrrrrrroooooooooooo")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func rightBarPlusButtonClicked(sender: UIBarButtonItem){
        let addCanfeiVC = AddCanfeiViewController()
        addCanfeiVC.modalTransitionStyle = .FlipHorizontal
        presentViewController(addCanfeiVC, animated: true) { () -> Void in
            
        }
    }

}
