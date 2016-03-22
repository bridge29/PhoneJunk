//
//  settings.swift
//  PhoneJunk
//
//  Created by Scott Bridgman on 12/18/15.
//  Copyright © 2015 Tohism. All rights reserved.
//
// TODO:
// Menu
// -Upgrade functionality
// -Menu table view
//    - What is PhoneFiles, Upgrade: Unlimited Files for $1.99, Folder Suggestions, File Suggestions, Rate Us, Contact Us
// VERSION 2:
//     - cloud/non-cloud option 
//     - Photo shoot feature (also will be in separate app)
//     - Cropping functionality

import UIKit
import EasyTipView

let APP_NAME       = "PhoneFiles"
let PRE_TITLE_TEXT = "Title..."
let PRE_DESC_TEXT  = "Description..."
let PREMIUM_COST   = "1.99"
let fileTypes      = ["Photo","Video"] //,"Audio","Text"]
let fullTipList    = ["folder_1","folder_2","folder_3","folder_4","folder_5","folder_6",
                      "file_1","file_2","file_3","file_4","file_5","file_6","file_7","file_8"]
let MAX_RATE_HITS   = 20 // Number of hits to wait to pop up rate us message
let VC_FG_COLOR     = UIColor(red: 150/255, green: 190/255, blue: 225/255, alpha: 1)
let VC_BG_COLOR     = UIColor(red: 255/255, green: 100/255, blue: 100/255, alpha: 1)
let VC_BORDER_COLOR = UIColor(red: 255/255, green: 255/255, blue: 100/255, alpha: 1)

enum FilesView: Int {
    case Small  = 0
    case Medium = 1
    case Large  = 2
}

enum SortBy: Int16 {
    case CreateRecent = 0
    case CreateOldest = 1
    case EditRecent   = 2
    case EditOldest   = 3
}

var rateNumber:Int{
    get {
        let returnValue = NSUserDefaults.standardUserDefaults().objectForKey("rateNumber") as? Int
        if returnValue == nil {
            return 10
        }
        return returnValue!
    }
    set {
        NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "rateNumber")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}

var activeTips:[String]{
    get {
        let returnValue = NSUserDefaults.standardUserDefaults().objectForKey("activeTips") as? [String]
        if returnValue == nil {
            return fullTipList
        }
        return returnValue!
    }
    set {
        NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "activeTips")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}

var securityMethod : String {
    get {
        let returnValue = NSUserDefaults.standardUserDefaults().objectForKey("securityMethod") as? String
        if returnValue == nil {
            return "touch_id" // securityMethod can be finger or pass.
        }
        return returnValue!
    }
    set {
        NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "securityMethod")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}

var maxFileCount : Int {
    get {
        let returnValue = NSUserDefaults.standardUserDefaults().objectForKey("maxFileCount") as? Int
        if returnValue == nil {
            return 10
        }
        return returnValue!
    }
    set {
        NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "maxFileCount")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}

func getDocumentPath() -> String{
    return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
}

func getFilePath(fileName:String) -> String{
    return getDocumentPath().stringByAppendingString("/" + fileName)
}

func getFileCount() -> Int{
    do {
        let allFiles = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(getDocumentPath())
        var files:[String] = []
        for file in allFiles{
            if file.hasPrefix("1") && (file.hasSuffix("jpg") || file.hasSuffix("mov")) {
                files.append(file)
            }
        }
        return files.count
    } catch {
        print("Error: \(error)")
    }
    return 0
}

func printFiles(){
    do {
        let allFiles = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(getDocumentPath())
        var files:[String] = []
        for file in allFiles{
            if file.hasPrefix("14") && (file.hasSuffix("jpg") || file.hasSuffix("mov")) {
                files.append(file)
            }
        }
        print("\(files.count) files:")
        for file in files{
            print(file)
        }
    } catch {
        print("Error: \(error)")
    }
}

func getTipPreferences() -> EasyTipView.Preferences{
    
    var tipPreferences = EasyTipView.Preferences()
    tipPreferences.drawing.font = UIFont(name: "Futura-Medium", size: 13)!
    tipPreferences.drawing.foregroundColor = UIColor.whiteColor()
    tipPreferences.drawing.backgroundColor = UIColor(hue:0.46, saturation:0.99, brightness:0.6, alpha:1)
    tipPreferences.drawing.arrowPosition = EasyTipView.ArrowPosition.Top
    return tipPreferences
}


func getSortName(sortBy:SortBy) -> String{
    
    switch (sortBy) {
    case .CreateRecent:
        return "Created date, recent first"
    case .CreateOldest:
        return "Created date, oldest first"
    case .EditRecent:
        return "Edited date, recent first"
    case .EditOldest:
        return "Edited date, oldest first"
    }
}

func getFileDateLabelText(date:NSTimeInterval, useDateFormat:Bool=true) ->String{
    
    if (useDateFormat){
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        formatter.dateFormat = "MM/dd"
        return formatter.stringFromDate(NSDate(timeIntervalSinceReferenceDate:date))
        
    }else{
        
        let seconds = Int(NSDate.timeIntervalSinceReferenceDate() - date)
        var num = 1
        var unit = "min"
        
        switch(seconds){
        case 0..<60:
            num  = 1
            unit = "min"
        case 60..<3600:
            num  = seconds/60
            unit = "min"
        case 3600..<86400:
            num  = seconds/3600
            unit = "hour"
        case  86400..<1209600:
            num  = seconds/86400
            unit = "day"
        default:
            return "\(seconds/604800)w"
        }
        unit = (num == 1) ? unit : unit + "s"
        return "\(num) \(unit)"
    }
}
