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
    var tableViewData:[[String:String]]!
    var segment:UISegmentedControl!
    var scrollView:UIScrollView!
    
    var total:Double!
    var data:[Canfei]! = []

    enum WhichMonth{
        case ThisMonth, LastMonth
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segment = UISegmentedControl(items: ["本月", "上个月"])
        segment.addTarget(self, action: "segmentValueChanged:", forControlEvents: .ValueChanged)
        self.navigationItem.titleView = segment
        
        let rightPlusButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "rightBarPlusButtonClicked:")
        rightPlusButton.style = .Done
        self.navigationItem.rightBarButtonItem = rightPlusButton
        
        tableView = UITableView(frame: view.bounds, style: .Plain)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
//    
//        scrollView = UIScrollView()
//        let uiview1 = UIView(frame: view.bounds)
//        
//        uiview1.backgroundColor = UIColor.redColor()
//        let uiview2 = UIView(frame: CGRect(origin: CGPoint(x: view.bounds.width, y: view.frame.height - view.bounds.height), size: CGSize(width: view.bounds.width, height: view.bounds.height)))
//        uiview2.backgroundColor = UIColor.blackColor()
//        scrollView.addSubview(uiview1)
//        scrollView.addSubview(uiview2)
//        scrollView.frame = view.bounds
//        scrollView.contentSize = CGSizeMake(2 * view.frame.width, view.bounds.height)
//        scrollView.delegate = self
//        view.addSubview(scrollView)
    }
    

    //MARK: segment target method: segmentValueChange
    func segmentValueChanged(sender: UISegmentedControl){
        let pageIndex = sender.selectedSegmentIndex
//        scrollView.scrollRectToVisible(CGRect(origin: CGPoint(x: CGFloat(pageIndex) * view.bounds.width , y: view.frame.height - view.bounds.height), size: view.bounds.size), animated: true)
        fetchData(pageIndex)
    }
    
    //MARK: tableview datasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "benyue"
        return cell
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
    }
    
    func fetchData(thisMonth: Int) {
        NSLog("\(thisMonth)")
        let token:String? = NSUserDefaults.standardUserDefaults().stringForKey("token")

        let headers = ["Authorization": "Basic \(token!)"]
        Alamofire.request(.GET, "http://localhost:8888/api/statistics", parameters: ["flag": thisMonth], encoding: .URL, headers: headers).validate().responseJSON { [unowned self]response in

            switch response.result{
            case .Success:
                print(response.result.value)
                
                let statistics = response.result.value?["statistics"] as! [[String: AnyObject]]
                print(statistics)
                for item in statistics{
                    self.data.append(Canfei(json: item))
                }
                self.tableView.reloadData()
            case .Failure:
                print("errrrrrrrroooooooooooo")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func rightBarPlusButtonClicked(sender: UIBarButtonItem){
        let alert = UIAlertController(title: "title", message: "message", preferredStyle: .Alert)
        presentViewController(alert, animated: true, completion: nil)
    }

}
