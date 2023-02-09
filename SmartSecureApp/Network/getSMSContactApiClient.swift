//
//  getSMSContactApiClient.swift
//  SmartSecureApp
//
//  Created by Ranadheer on 29/12/2022.
//

import Foundation
import Alamofire

struct getSMSList {
    static var getSMSResponse = [String:Any]()
}

class getSMSAPIClient {
    static let shared = getSMSAPIClient()
    
    func getSMSApiIntegration(userid:String,funct:String,completion: @escaping (Bool, Error?) -> Void) {
        
        let url = "https://skyhighcloud.tech/smartSecure/routes/actions/users.php"
        let parameters : [String : Any] = ["user_id":userid, "func":funct]
        
        print(parameters)
        AlamofireManager.request(url, method: .post, parameters: parameters, encoding: URLEncoding(destination: .httpBody)) { (response) -> Void in
            switch response.result {
            case .success:
                if let details = response.result.value as? [String:Any] {
                    getSMSList.getSMSResponse = details
                }
                completion(true, nil)
            case .failure(let error):
                print(error)
                completion(false, error)
            }
        }
    }
}
