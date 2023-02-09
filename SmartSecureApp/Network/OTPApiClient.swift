//
//  OTPApiClient.swift
//  SmartSecureApp
//
//  Created by Ranadheer on 26/12/2022.
//

import Foundation
import Alamofire

struct OTPList {
    static var OTPResponse = [String:Any]()
}

struct EmailOTPList {
    static var EmailOTPResponse = [String:Any]()
}


class OTPAPIClient {
    static let shared = OTPAPIClient()
    
    func otpApiIntegration(email:String,funct:String,code:String,completion: @escaping (Bool, Error?) -> Void) {
        
        let url = RequestURL.BASEURL
        
        //"https://skyhighcloud.tech/smartSecure/routes/actions/users.php"
        
        let parameters : [String : Any] = ["email":email,"func":funct,"code":code]
        
        print(parameters)
        AlamofireManager.request(url, method: .post, parameters: parameters, encoding: URLEncoding(destination: .httpBody)) { (response) -> Void in
            switch response.result {
            case .success:
                if let details = response.result.value as? [String:Any] {
                    OTPList.OTPResponse = details
                }
                completion(true, nil)
            case .failure(let error):
                print(error)
                completion(false, error)
            }
        }
    }
    
    func emailotpApiIntegration(email:String,funct:String,code:String,completion: @escaping (Bool, Error?) -> Void) {
        
        let url = RequestURL.BASEURL
        
        //"https://skyhighcloud.tech/smartSecure/routes/actions/users.php"
        
        let parameters : [String : Any] = ["email":email,"func":funct,"code":code]
        
        print(parameters)
        AlamofireManager.request(url, method: .post, parameters: parameters, encoding: URLEncoding(destination: .httpBody)) { (response) -> Void in
            switch response.result {
            case .success:
                if let details = response.result.value as? [String:Any] {
                    EmailOTPList.EmailOTPResponse = details
                }
                completion(true, nil)
            case .failure(let error):
                print(error)
                completion(false, error)
            }
        }
    }
    
}
