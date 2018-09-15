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



class Person: NSObject {
    
    var links: [LinkTypes: String] = [:]
    let name: String
    let timestamp: Date
    var phoneNumber: String?
    
    
    init(name: String) {
        self.name = name
        self.timestamp = Date()
        super.init()
    }
    
    

}
