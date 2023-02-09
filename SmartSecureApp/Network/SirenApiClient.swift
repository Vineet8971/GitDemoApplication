//
//  SirenApiClient.swift
//  SmartSecureApp
//
//  Created by Vineet Sharma on 20/01/23.
//

import Foundation
import Alamofire

struct SirenList {
    static var SirenResponse = [String:Any]()
}


class SirenAPIClient {
    static let shared = SirenAPIClient()
    
    func SirenApiIntegration(userid:String,funct:String,siren:String,callPreferences:String,completion: @escaping (Bool, Error?) -> Void) {
        
        let url = "https://skyhighcloud.tech/smartSecure/routes/actions/users.php"
        
        let parameters : [String : Any] = ["user_id":userid, "func":funct,"siren":siren,"call_preference":callPreferences]
        
        print(parameters)
        AlamofireManager.request(url, method: .post, parameters: parameters, encoding: URLEncoding(destination: .httpBody)) { (response) -> Void in
            switch response.result {
            case .success:
                if let details = response.result.value as? [String:Any] {
                    SirenList.SirenResponse = details
                }
                completion(true, nil)
            case .failure(let error):
                print(error)
                completion(false, error)
            }
        }
    }
}

