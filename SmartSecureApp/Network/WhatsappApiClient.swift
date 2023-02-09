//
//  WhatsappApiClient.swift
//  SmartSecureApp
//
//  Created by Vineet Sharma on 20/01/23.
//

import Foundation
import Alamofire

struct getWhatsappList {
    static var getWhatsappResponse = [String:Any]()
}

class WhatsappApiClient {
    static let shared = WhatsappApiClient()
    
    func getWhatsappApiIntegration(userid:String,funct:String,completion: @escaping (Bool, Error?) -> Void) {
        
        let url = "https://skyhighcloud.tech/smartSecure/routes/actions/users.php"
        let parameters : [String : Any] = ["user_id":userid, "func":funct]
        
        print(parameters)
        AlamofireManager.request(url, method: .post, parameters: parameters, encoding: URLEncoding(destination: .httpBody)) { (response) -> Void in
            switch response.result {
            case .success:
                if let details = response.result.value as? [String:Any] {
                    getWhatsappList.getWhatsappResponse = details
                }
                completion(true, nil)
            case .failure(let error):
                print(error)
                completion(false, error)
            }
        }
    }
}
