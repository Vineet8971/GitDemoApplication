//
//  LoginApiClient.swift
//  SmartSecureApp
//
//  Created by Ranadheer on 21/12/2022.
//

import Foundation
import Alamofire

struct SignInList {
    static var SignInResponse = [String:Any]()
}


class SignInAPIClient {
    static let shared = SignInAPIClient()
    
    func signInApiIntegration(email:String,password:String,funct:String,completion: @escaping (Bool, Error?) -> Void) {
        
        let url = RequestURL.BASEURL
        //"https://skyhighcloud.tech/smartSecure/routes/actions/users.php"
   
        let parameters : [String : Any] = ["email":email,"func":funct,"password":password]
        
        print(parameters)
        AlamofireManager.request(url, method: .post, parameters: parameters, encoding: URLEncoding(destination: .httpBody)) { (response) -> Void in
            switch response.result {
            case .success:
                if let details = response.result.value as? [String:Any] {
                    SignInList.SignInResponse = details
                }
                completion(true, nil)
            case .failure(let error):
                print(error)
                completion(false, error)
            }
        }
    
    }
    
}
