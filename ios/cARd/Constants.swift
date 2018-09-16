//
//  Constants.swift
//  cARd
//
//  Created by Avery on 9/15/18.
//  Copyright © 2018 Avery Lamp. All rights reserved.
//

import Foundation
import UIKit
import VideoToolbox

class Constants{
    
    static let NewPersonNotification = "PersonNotification"
    
    static let selectionHapticFeedback = UISelectionFeedbackGenerator()
    static let notificationHapticFeedback = UINotificationFeedbackGenerator()
    
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
    
    class func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
}


class Routing{
    
    class func openURL(url: URL){
        DispatchQueue.main.async {
            if  UIApplication.shared.canOpenURL(url){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    class func callPhoneNumber(number: String){
        let urlstr = "tel://\(number)"
        if let url = URL(string: urlstr){
            Routing.openURL(url: url)
        }
    }
    
    class func sendText(number: String){
        let urlstr = "sms://\(number)"
        if let url = URL(string: urlstr){
            Routing.openURL(url: url)
        }
    }
    
    class func sendEmail(email: String){
        let urlstr = "mailto://\(email)"
        if let url = URL(string: urlstr){
            Routing.openURL(url: url)
        }
    }
    
    class func openLinkedIn(urlstr: String){
        if let url = URL(string: urlstr){
            Routing.openURL(url: url)
        }
    }
    
    class func openFacebook(profileID: String){
        let urlstr = "fb://profile/\(profileID)"
        if let url = URL(string: urlstr){
            Routing.openURL(url: url)
        }
    }
    
    class func openTwitter(urlstr: String){
        if let url = URL(string: urlstr){
            Routing.openURL(url: url)
        }
    }
    
    class func openDevpost(urlstr: String){
        if let url = URL(string: urlstr){
            Routing.openURL(url: url)
        }
    }
    
    class func openWebsite(urlstr: String){
        if let url = URL(string: urlstr){
            Routing.openURL(url: url)
        }
    }
}



extension UIViewController{
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
}

extension UIImage {
    public convenience init?(pixelBuffer: CVPixelBuffer) {
        var cgImage: CGImage?
        VTCreateCGImageFromCVPixelBuffer(pixelBuffer, nil, &cgImage)
        
        if let cgImage = cgImage {
            self.init(cgImage: cgImage)
        } else {
            return nil
        }
    }
    
    func cropImage(toRect rect:CGRect) -> UIImage{
        let imageRef:CGImage = self.cgImage!.cropping(to: rect)!
        let cropped:UIImage = UIImage(cgImage:imageRef)
        return cropped
    }

    
}

