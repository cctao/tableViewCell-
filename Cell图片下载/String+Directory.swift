//
//  String+Directory.swift
//  Cell图片下载
//
//  Created by cctao on 15/3/12.
//  Copyright (c) 2015年 cctao. All rights reserved.
//

import Foundation
extension String {
    
    func catchPath()->String{
        var str = String()
        var path: String =  NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, false).last as! String
        
         str = path.stringByAppendingPathComponent(str)
        return str
        
    }
    
    
    
    
    
}