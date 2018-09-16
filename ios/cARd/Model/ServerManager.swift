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
        if let base64Image = UIImagePNGRepresentation(image)?.base64EncodedString(){
            let request = NSMutableURLRequest(url: NSURL(string: "http://turtle.mit.edu:5000/handle_image")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 45.0)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.timeoutInterval = 50
            let postData = ["image_data": base64Image]
            print(postData)
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: postData, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }

            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error)
                } else {
                    guard let data = data else{return}
                    let httpResponse = response as? HTTPURLResponse
                    print(httpResponse)
                    let responseData = String(data: data, encoding: String.Encoding.utf8)
                    print(responseData)
                    
                }
            })
            
            dataTask.resume()
            
            
            
            let returnedTarget = UIImage(named: "palantir")
            
//            completion(returnedTarget!, person)
            
        }
    }
    
}
