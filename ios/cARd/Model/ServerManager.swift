//
//  ServerManager.swift
//  
//
//  Created by Avery on 9/15/18.
//

import UIKit

class ServerManager {
    
    
    static let sharedInstance = ServerManager()
    
    var profiles:[Person]
    
    private init() {
        print("Shared Instance initialized")
        if let profiles = UserDefaults.standard.object(forKey: "allProfiles") as? [Person]{
            self.profiles = profiles
        }else{
            self.profiles = []
        }
    }
    
    
    func addPerson(person: Person){
        self.profiles.append(person)
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: self.profiles, requiringSecureCoding: false){
            UserDefaults.standard.set(data, forKey: "allProfiles")
        }
        
    }
    
    
    func analyzeCardImage(image: UIImage, completion: ((UIImage, Person) -> Void)) {
        
        let person = Person(name: "Avery Lamp")
        person.phoneNumber = "0000000000"
        person.links["devpost"] = ""
        person.links["facebook"] = "https://www.facebook.com/avery.lamp"
        person.links["linkedin"] = "https://www.linkedin.com/in/averylamp/"
        person.setPhoneNumber(number: "973-873-8225")
        person.links["twitter"] = ""
        person.links["website"] = ""
        
        let imageURL = "https://media.licdn.com/dms/image/C5603AQGYLlhGhN_JNA/profile-displayphoto-shrink_800_800/0?e=1542844800&v=beta&t=kaDq5HhrULTZ8jUiv8BTELnpdyMH6cmArRIazcZ7KtM"
        person.profileImageURL = imageURL
        
        
        let returnedTarget = UIImage(named: "palantir")
        
        completion(returnedTarget!, person)
    }
    
}
