//
//  SendEmailApiClient.swift
//  SmartSecureApp
//
//  Created by Ranadheer on 29/12/2022.
//

import Foundation
import Alamofire

struct sendEmailList {
    static var sendEmailResponse = [String:Any]()
}

class sendEmailAPIClient {
    static let shared = sendEmailAPIClient()
    
    func sendEmailAPIClientApiIntegration(funct:String,userId:Int,created:String,contactNames:String,contactEmail:String,contactOrder:String,completion: @escaping (Bool, Error?) -> Void) {
        
        let url = "https://skyhighcloud.tech/smartSecure/routes/actions/users.php"
        
        let parameters : [String : Any] = ["func":funct,"user_id":userId,"created":created,"contact_names":contactNames,"contact_emails":contactEmail,"contact_order":contactOrder]
        
        print(parameters)
        AlamofireManager.request(url, method: .post, parameters: parameters, encoding: URLEncoding(destination: .httpBody)) { (response) -> Void in
            switch response.result {
            case .success:
                if let details = response.result.value as? [String:Any] {
                    sendEmailList.sendEmailResponse = details
                }
                completion(true, nil)
            case .failure(let error):
                print(error)
                completion(false, error)
            }
        }
    }
}
