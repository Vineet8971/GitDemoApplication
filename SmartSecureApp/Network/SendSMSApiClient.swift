//
//  SendSMSApiClient.swift
//  SmartSecureApp
//
//  Created by Ranadheer on 29/12/2022.
//

import Foundation
import Alamofire

struct sendSMSList {
    static var sendSMSResponse = [String:Any]()
}

class sendSMSAPIClient {
    static let shared = sendSMSAPIClient()
    
    func sendSMSAPIClientApiIntegration(funct:String,userId:Int,created:String,contactNames:String,contactSMS:String,contactOrder:String,completion: @escaping (Bool, Error?) -> Void) {
        
        let url = "https://skyhighcloud.tech/smartSecure/routes/actions/users.php"
        
        let parameters : [String : Any] = ["func":funct,"user_id":userId,"created":created,"contact_names":contactNames,"contact_sms":contactSMS,"contact_order":contactOrder]
        
        print(parameters)
        AlamofireManager.request(url, method: .post, parameters: parameters, encoding: URLEncoding(destination: .httpBody)) { (response) -> Void in
            switch response.result {
            case .success:
                if let details = response.result.value as? [String:Any] {
                    sendSMSList.sendSMSResponse = details
                }
                completion(true, nil)
            case .failure(let error):
                print(error)
                completion(false, error)
            }
        }
    }
}
