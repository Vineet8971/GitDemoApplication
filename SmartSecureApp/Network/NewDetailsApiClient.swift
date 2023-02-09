//
//  NewDetailsApiClient.swift
//  SmartSecureApp
//
//  Created by Ranadheer on 26/12/2022.
//

import Foundation
import Alamofire

struct NDetailsList {
    static var NDetailsResponse = [String:Any]()
}


class NDetailsAPIClient {
    static let shared = NDetailsAPIClient()
    
    func nDetailsApiIntegration(email:String,funct:String,password:String,completion: @escaping (Bool, Error?) -> Void) {
        
        let url = RequestURL.BASEURL
        "https://skyhighcloud.tech/smartSecure/routes/actions/users.php"
        
        let parameters : [String : Any] = ["email":email,"func":funct,"password":password]
        
        print(parameters)
        AlamofireManager.request(url, method: .post, parameters: parameters, encoding: URLEncoding(destination: .httpBody)) { (response) -> Void in
            switch response.result {
            case .success:
                if let details = response.result.value as? [String:Any] {
                    NDetailsList.NDetailsResponse = details
                }
                completion(true, nil)
            case .failure(let error):
                print(error)
                completion(false, error)
            }
        }
    }
}
