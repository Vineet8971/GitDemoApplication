//
//  ContactUsApiClient.swift
//  SmartSecureApp
//
//  Created by Vineet Sharma on 22/01/23.
//

import Foundation
import Alamofire

struct ContactUsList {
    static var ContactUsResponse = [String:Any]()
}


class ContactUsApiClient {
    static let shared = ContactUsApiClient()

    func ContactUsApiIntegration(funct:String,email:String,phone:String,name:String,message:String,userId:String,completion: @escaping (Bool, Error?) -> Void) {
    let url = RequestURL.BASEURL
    //"https://skyhighcloud.tech/smartSecure/routes/actions/users.php"

        let parameters : [String : Any] = ["func":funct,"email":email,"phone":phone,"name":name,"message":message,"user_id":userId]
    
    print(parameters)
    AlamofireManager.request(url, method: .post, parameters: parameters, encoding: URLEncoding(destination: .httpBody)) { (response) -> Void in
        switch response.result {
        case .success:
            if let details = response.result.value as? [String:Any] {
                ContactUsList.ContactUsResponse = details
            }
            completion(true, nil)
        case .failure(let error):
            print(error)
            completion(false, error)
        }
    }
    }
}
