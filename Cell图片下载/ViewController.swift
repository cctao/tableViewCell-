//
//  ViewController.swift
//  Cell图片下载
//
//  Created by cctao on 15/3/11.
//  Copyright (c) 2015年 cctao. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    lazy var imageCatch:NSMutableDictionary? = {
       var dict = NSMutableDictionary()
        return dict
        
    }()
    lazy var gloabQueue:NSOperationQueue? = {
        var queue  = NSOperationQueue()
        return queue
    }()
    
    lazy var operationCatch:NSMutableDictionary? = {
          var dict  = NSMutableDictionary()
          return dict
    }()
    
    lazy var appList:NSArray? = {
        var path =  NSBundle.mainBundle().pathForResource("apps.plist", ofType: nil)
        var array = NSArray(contentsOfFile: path!)
        var tempArray = NSMutableArray()
        var count = array!.count
        var i = 0
        
        for i in 0..<count{
            var app = AppDemo()
            var dict: NSDictionary = array![i] as! NSDictionary
             app.setValuesForKeysWithDictionary(dict as! [NSObject : AnyObject])
            tempArray.addObject(app)
        }
        
        return tempArray
        
        }()

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("iconCell") as! UITableViewCell
        var appInfo: AppDemo = appList![indexPath.row] as! AppDemo

        
        cell.textLabel!.text = appInfo.name
        cell.detailTextLabel?.text = appInfo.download
     
        //异步下载图片
        //避免循环yinyong

        var wearkself = self
        var urlString = appInfo.icon
        
       let icon:UIImage? = imageCatch?.valueForKey(urlString!) as? UIImage
        
        
       if icon == nil  {
        cell.imageView?.image = UIImage(named: "user_default")
        
        let str:String? = operationCatch!.valueForKey(urlString!) as? String
        if str != nil{
            return cell
        }
        
        var opblock:NSBlockOperation? = NSBlockOperation(block: { () -> Void in
            var url = NSURL(string: urlString!)
            var data:NSData = NSData(contentsOfURL: url!)!
            
            var image:UIImage?
            if indexPath.row == 1{
                NSThread.sleepForTimeInterval(10)
                println("捕鱼达人-----")
                image = UIImage(data: data)!
            }else{
                //                NSThread.sleepForTimeInterval(0.5)
                image = UIImage(data: data)!
            }
            
            self.imageCatch?.setValue(image, forKey: urlString!)
            self.operationCatch?.removeObjectForKey(urlString!)
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                //主线程内刷新UI
                cell.imageView?.image = image
                //刷新该行
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
                
            })

            
            
        })
        
       gloabQueue?.addOperation(opblock!)
    
       operationCatch?.setValue("cctao", forKey: urlString!)
      }else{
        cell.imageView?.image = icon
        }
        
//        NSData
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appList?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }

}

