//
//  Constants.swift
//  cARd
//
//  Created by Avery on 9/15/18.
//  Copyright © 2018 Avery Lamp. All rights reserved.
//

import Foundation
import UIKit

class Constants{
    static let selectionHapticFeedback = UISelectionFeedbackGenerator()
    static let notificationHapticFeedback = UINotificationFeedbackGenerator()
    static let currentDay: Date = Date().addingTimeInterval(-60 * 60 * 24 * 3)
    
    static var diningHallMapping: [String: String] = [
        "mccormick":"diningHallPreview0",
        "simmons":"diningHallPreview1",
        "baker":"diningHallPreview2",
        "next":"diningHallPreview3",
        "maseeh":"diningHallPreview5"
    ]
    
    
    
    class func generateSelectionHapticFeedback(){
        selectionHapticFeedback.selectionChanged()
    }
    
    class func generateNotificationHapticFeedback(feedback:UINotificationFeedbackGenerator.FeedbackType){
        notificationHapticFeedback.notificationOccurred(feedback)
    }
    

    class func getMotionEffectGroup(xDistance: CGFloat, yDistance: CGFloat)-> UIMotionEffectGroup{
        let xMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = -xDistance
        xMotion.maximumRelativeValue = xDistance
        
        let yMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = -yDistance
        yMotion.maximumRelativeValue = yDistance
        
        let motionEffectGroup = UIMotionEffectGroup()
        motionEffectGroup.motionEffects = [xMotion,yMotion]
        return motionEffectGroup
    }
    
    class func getShadowMotionEffectGroup(xDistance: CGFloat, yDistance: CGFloat) -> UIMotionEffectGroup{
        let xMotion = UIInterpolatingMotionEffect(keyPath: "layer.shadowOffset.width", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = -xDistance
        xMotion.maximumRelativeValue = xDistance
        
        let yMotion = UIInterpolatingMotionEffect(keyPath: "layer.shadowOffset.height", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = -yDistance
        yMotion.maximumRelativeValue = yDistance
        
        let motionEffectGroup = UIMotionEffectGroup()
        motionEffectGroup.motionEffects = [xMotion,yMotion]
        return motionEffectGroup
    }
    
    class func getMotionEffectGroup(maxDistance: CGFloat) -> UIMotionEffectGroup{
        return getMotionEffectGroup(xDistance: maxDistance, yDistance: maxDistance)
    }
}



extension UIViewController{
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
}


extension Date{
    
    func distanceStringFromDate(date: Date) -> String {
        let currentDate = date
        let calendar = Calendar.current
        let now = currentDate
        let earliest = (now as NSDate).earlierDate(self)
        let latest = (earliest == now) ? self : now
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
        
        if (components.year! >= 2) {
            return "\(components.year!) years"
        } else if (components.year! >= 1){
            return "1 year"
        } else if (components.month! >= 2) {
            return "\(components.month!) months"
        } else if (components.month! >= 1){
            return "1 month"
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks"
        } else if (components.weekOfYear! >= 1){
            return "1 week"
        } else if (components.day! >= 2) {
            return "\(components.day!) days"
        } else if (components.day! >= 1){
            return "1 day"
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours"
        } else if (components.hour! >= 1){
            return "1 hour"
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes"
        } else if (components.minute! >= 1){
            return "1 minute"
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds"
        } else {
            return "Now"
        }
        
    }
    
    
    func timeAgoSinceDate(numericDates: Bool = false) -> String {
        let currentDate = Date()
        let calendar = Calendar.current
        let now = currentDate
        let earliest = (now as NSDate).earlierDate(self)
        let latest = (earliest == now) ? self : now
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
        
    }
    
}
