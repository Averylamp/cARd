//
//  Person.swift
//  cARd
//
//  Created by Avery on 9/15/18.
//  Copyright © 2018 card. All rights reserved.
//

import UIKit

enum LinkType: String{
    case twitter = "twitter"
    case facebook = "facebook"
    case devpost = "devpost"
    case linkedin = "linkedin"
    case phoneCall = "phone-call"
    case phoneText = "phone-text"
    case phoneFacetime = "phone-facetime"
    case website = "website"
    case unknown = "unknown"
}



class Person: NSObject,  NSCoding {
    
    var links: [String: [String]] = [:]
    let name: String
    let timestamp: Date
    var phoneNumber: String?
    
    private enum CodingKeys: CodingKey {
        case links
        case name
        case timestamp
        case phoneNumber
    }
    
    init(name: String) {
        self.name = name
        self.timestamp = Date()
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.timestamp, forKey: "date")
        aCoder.encode(self.phoneNumber, forKey: "number")
        aCoder.encode(self.links, forKey: "links")
    }
    
    func addLink(type:LinkType, link: String){
        if var linksArray = self.links[type.rawValue] as? [String]{
            linksArray.append(link)
        }else{
            self.links.updateValue([link], forKey: type.rawValue)
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.timestamp = aDecoder.decodeObject(forKey: "date") as! Date
        self.phoneNumber = aDecoder.decodeObject(forKey: "number") as? String
        self.links = aDecoder.decodeObject(forKey: "links") as! [String: [String]]
    }

    func printDump(){
        print("Name: \(self.name)\nDate: \(self.timestamp)\nLiks: \(self.links)")
    }
    
    

}
