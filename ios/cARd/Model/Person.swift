//
//  Person.swift
//  cARd
//
//  Created by Avery on 9/15/18.
//  Copyright © 2018 card. All rights reserved.
//

import UIKit
import SwiftyJSON

enum LinkType: String{
    case twitter = "twitter"
    case facebook = "facebook"
    case devpost = "devpost"
    case email = "email"
    case linkedin = "linkedin"
    case phoneCall = "phone-call"
    case phoneText = "phone-text"
    case phoneFacetime = "phone-facetime"
    case website = "website"
    case unknown = "unknown"
}


enum PersonStatus{
    case Completed
    case Unfiltered
}

class Person: NSObject,  NSCoding {
    
    var links: [String: String] = [:]
    var unfilteredLinks: [String: [String]] = [:]
    
    let name: String
    let timestamp: Date
    var phoneNumber: String?
    var uid: String = Constants.randomString(length: 15)
    
    var personStatus:PersonStatus = .Unfiltered
    var profileImageURL: String?
    
    private enum CodingKeys: CodingKey {
        case links
        case name
        case timestamp
        case phoneNumber
    }
    
    init(json: JSON) {
        self.name = ""
        self.timestamp = Date()
        super.init()
        if name == "Unknown"{
            links["devpost"] = "http://devpost.com/averylamp"
            links["facebook"] = "https://www.facebook.com/avery.lamp"
            links["linkedin"] = "https://www.linkedin.com/in/averylamp/"
            links["twitter"] = "https://twitter.com/averylamp"
            links["website"] = "http://averylamp.me/"
            setPhoneNumber(number: "9738738225")
            
            let imageURL = "https://media.licdn.com/dms/image/C4E03AQHu5yxY8L5vfw/profile-displayphoto-shrink_200_200/0?e=1542844800&v=beta&t=ivEJzB1az6jDHlIq3J0N2PjON2lG0hLJPSeLXTzz2_8"
            profileImageURL = imageURL
            
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.uid, forKey:"uid")
        aCoder.encode(self.timestamp, forKey: "date")
        aCoder.encode(self.phoneNumber, forKey: "number")
        aCoder.encode(self.links, forKey: "links")
        aCoder.encode(self.unfilteredLinks, forKey:"unfilteredLinks")
        aCoder.encode(self.profileImageURL, forKey:"profileImageURL")
    }
    
    func addLink(type:LinkType, link: String){
        self.links.updateValue(link, forKey: type.rawValue)
    }
    
    func setPhoneNumber(number: String){
        self.links["phoneCall"] = number
        self.links["phoneFacetime"] = number
        self.links["phoneText"] = number
        self.phoneNumber = number
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.uid = aDecoder.decodeObject(forKey: "uid") as! String
        self.timestamp = aDecoder.decodeObject(forKey: "date") as! Date
        self.phoneNumber = aDecoder.decodeObject(forKey: "number") as? String
        self.links = aDecoder.decodeObject(forKey: "links") as! [String: String]
        self.unfilteredLinks = aDecoder.decodeObject(forKey: "unfilteredLinks") as! [String:[String]]
        self.profileImageURL = aDecoder.decodeObject(forKey: "profileImageURL" ) as? String
    }

    func printDump(){
        print("Name: \(self.name)\nDate: \(self.timestamp)\nLiks: \(self.links)")
    }
    
    

}
