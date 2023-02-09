//
//  PrivacyApiClient.swift
//  SmartSecureApp
//
//  Created by Ranadheer on 27/12/2022.
//

import Foundation
import Alamofire

struct PrivacyList {
    static var PrivacyResponse = [String:Any]()
}


class PrivacyAPIClient {
    static let shared = PrivacyAPIClient()
    
    func privacyApiIntegration(funct:String,completion: @escaping (Bool, Error?) -> Void) {
        
        let url = "https://skyhighcloud.tech/smartSecure/routes/actions/pages.php"
        
        let parameters : [String : Any] = ["func":funct]
        
        print(parameters)
        AlamofireManager.request(url, method: .post, parameters: parameters, encoding: URLEncoding(destination: .httpBody)) { (response) -> Void in
            switch response.result {
            case .success:
                if let details = response.result.value as? [String:Any] {
                    PrivacyList.PrivacyResponse = details
                }
                completion(true, nil)
            case .failure(let error):
                print(error)
                completion(false, error)
            }
        }
    }
    
    func termsApiIntegration(funct:String,completion: @escaping (Bool, Error?) -> Void) {
        
        let url = "https://skyhighcloud.tech/smartSecure/routes/actions/pages.php"
        
        let parameters : [String : Any] = ["func":funct]
        
        print(parameters)
        AlamofireManager.request(url, method: .post, parameters: parameters, encoding: URLEncoding(destination: .httpBody)) { (response) -> Void in
            switch response.result {
            case .success:
                if let details = response.result.value as? [String:Any] {
                    PrivacyList.PrivacyResponse = details
                }
                completion(true, nil)
            case .failure(let error):
                print(error)
                completion(false, error)
            }
        }
    }
}
