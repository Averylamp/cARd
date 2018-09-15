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
    
    class func generateNotificationHapticFeedback(feedback: UINotificationFeedbackGenerator.FeedbackType){
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

