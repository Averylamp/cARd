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
    
    var name: String
    var email: String?
    let timestamp: Date
    var phoneNumber: String?
    var information: [String:JSON]?
    var uid: String = Constants.randomString(length: 15)
    
    var personStatus:PersonStatus = .Unfiltered
    var profileImage: UIImage?
    
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
        
        
        if let info =  json["information"].dictionary{
            
            self.information = info
            if let links = info["links"]?.dictionary{
                for (linktype, link) in links{
                    let firstLink = link.arrayValue[0].stringValue
                    switch linktype{
                    case "devpost":
                        self.addLink(type: .devpost, link: firstLink)
                        break
                    case "facebook":
                        self.addLink(type: .facebook, link: firstLink)
                        break
                    case "twitter":
                        self.addLink(type: .twitter, link: firstLink)
                        break
                    case "linkedin":
                        self.addLink(type: .linkedin, link: firstLink)
                        break
                    case "personal":
                        self.addLink(type: .website, link: firstLink)
                        break
                    default:
                        self.addLink(type: .unknown, link: firstLink)
                        break
                        
                    }
                }
            }
            
            if let education = info["currentEducation"]?.string{
                
            }
            
            if let name = info["name"]?.string{
                self.name = name
            }
            
            if let email = info["email"]?.string{
                self.email = email
                self.addLink(type: .email, link: "mailto://\(email)")
            }
            
            if let phoneNumber = info["phone_number"]?.string, phoneNumber.count > 0{
                self.setPhoneNumber(number: phoneNumber)
            }
            
            if let profilePicture = info["profile_picture"]?.string, let dataDecoded = Data(base64Encoded: profilePicture, options: .ignoreUnknownCharacters), let decodedImage = UIImage(data: dataDecoded){
                self.profileImage = decodedImage
            }else{
                self.profileImage = UIImage(named: "pikachu")
            }
            
        }
        print(self.links.count)
        
        if name == "Unknown"{
            links["devpost"] = "http://devpost.com/averylamp"
            links["facebook"] = "https://www.facebook.com/avery.lamp"
            links["linkedin"] = "https://www.linkedin.com/in/averylamp/"
            links["twitter"] = "https://twitter.com/averylamp"
            links["personal"] = "http://averylamp.me/"
            setPhoneNumber(number: "9738738225")
            
//            let imageURL = "https://media.licdn.com/dms/image/C4E03AQHu5yxY8L5vfw/profile-displayphoto-shrink_200_200/0?e=1542844800&v=beta&t=ivEJzB1az6jDHlIq3J0N2PjON2lG0hLJPSeLXTzz2_8"
//            profileImageURL = imageURL
            
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.email, forKey: "email")
        aCoder.encode(self.uid, forKey:"uid")
        aCoder.encode(self.timestamp, forKey: "date")
        aCoder.encode(self.phoneNumber, forKey: "number")
        aCoder.encode(self.links, forKey: "links")
        aCoder.encode(self.unfilteredLinks, forKey:"unfilteredLinks")
        aCoder.encode(self.profileImage, forKey:"profileImageURL")
        aCoder.encode(self.information, forKey:"informationKey")
    }
    
    func addLink(type:LinkType, link: String){
        self.links.updateValue(link, forKey: type.rawValue)
    }
    
    func setPhoneNumber(number: String){
        self.addLink(type: LinkType.phoneCall, link: "tel://\(number)")
        self.addLink(type: LinkType.phoneText, link: "sms://\(number)")
        self.phoneNumber = number
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.email = aDecoder.decodeObject(forKey: "email") as! String
        self.uid = aDecoder.decodeObject(forKey: "uid") as! String
        self.timestamp = aDecoder.decodeObject(forKey: "date") as! Date
        self.phoneNumber = aDecoder.decodeObject(forKey: "number") as? String
        self.links = aDecoder.decodeObject(forKey: "links") as! [String: String]
        self.unfilteredLinks = aDecoder.decodeObject(forKey: "unfilteredLinks") as! [String:[String]]
        if let imageData = aDecoder.decodeObject(forKey: "profileImageURL" ) as? Data, let image = UIImage(data: imageData){
            self.profileImage = image
        }
        self.information = aDecoder.decodeObject(forKey: "informationKey") as? [String: JSON]
        
    }

    func printDump(){
        print("Name: \(self.name)\nDate: \(self.timestamp)\nLiks: \(self.links)")
    }
    
    

}
