//
//  SignUpApiClient.swift
//  SmartSecureApp
//
//  Created by Ranadheer on 21/12/2022.
//

import Foundation
import Alamofire


struct SignUpList {
    static var SignUpResponse = [String:Any]()
}


class SignUpAPIClient {
    static let shared = SignUpAPIClient()
    
    func userRegistrationApiIntegration(email:String,password:String,funct:String,first_name:String,last_name:String,gender:String,phone: String,role:Int,location:String,completion: @escaping (Bool, Error?) -> Void) {
        
        let url = RequestURL.BASEURL
        //"https://skyhighcloud.tech/smartSecure/routes/actions/users.php"
        
        let parameters : [String : Any] = ["email":email,"password":password,"func":funct,"first_name": first_name,"last_name":last_name,"gender":gender,"phone":phone,"role":role,"location":location]
        
        
        print(parameters)
        AlamofireManager.request(url, method: .post, parameters: parameters, encoding: URLEncoding(destination: .httpBody)) { (response) -> Void in
            switch response.result {
            case .success:
                if let details = response.result.value as? [String:Any] {
                    SignUpList.SignUpResponse = details
                }
                completion(true, nil)
            case .failure(let error):
                print(error)
                completion(false, error)
            }
        }
    }
}
