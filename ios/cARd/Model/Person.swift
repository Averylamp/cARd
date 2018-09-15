//
//  Person.swift
//  cARd
//
//  Created by Avery on 9/15/18.
//  Copyright © 2018 card. All rights reserved.
//

import UIKit

enum LinkTypes: String{
    case twitter = "twitter"
    case facebook = "facebook"
    case devpost = "devpost"
    case linkedin = "linkedin"
    case phoneCall = "phone-call"
    case phoneText = "phone-text"
    case phoneFacetime = "phone-facetime"
    case website = "website"
}



class Person: NSObject, NSCoding {
    
    var links: [LinkTypes: String] = [:]
    let name: String
    let timestamp: Date
    var phoneNumber: String?
    
    
    init(name: String) {
        self.name = name
        self.timestamp = Date()
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.timestamp = aDecoder.decodeObject(forKey: "date") as! Date
        self.phoneNumber = aDecoder.decodeObject(forKey: "number") as? String
        self.links = aDecoder.decodeObject(forKey: "links") as! [LinkTypes: String]
    }
    
    func printDump(){
        print("Name: \(self.name))")
        
    }
    
    

}
