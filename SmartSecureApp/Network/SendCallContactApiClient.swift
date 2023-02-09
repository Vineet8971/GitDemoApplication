//
//  SendCallContactApiClient.swift
//  SmartSecureApp
//
//  Created by Ranadheer on 28/12/2022.
//

import Foundation
import Alamofire

struct sentCallContactsList {
    static var sendCallContactResponse = [String:Any]()
}


class sendCallContactAPIClient {
    static let shared = sendCallContactAPIClient()
    
    func sendCallContactApiIntegration(funct:String,userId:Int,created:String,contactNames:String,contactPhones:String,contactOrder:String,primary:String,secondary:String,completion: @escaping (Bool, Error?) -> Void) {
        
        let url = "https://skyhighcloud.tech/smartSecure/routes/actions/users.php"
        
        let parameters : [String : Any] = ["func":funct,"user_id":userId,"created":created,"contact_names":contactNames,"contact_phones":contactPhones,"contact_order":contactOrder,"primary":primary,"secondary":secondary]
        
        print(parameters)
        AlamofireManager.request(url, method: .post, parameters: parameters, encoding: URLEncoding(destination: .httpBody)) { (response) -> Void in
            switch response.result {
            case .success:
                if let details = response.result.value as? [String:Any] {
                    sentCallContactsList.sendCallContactResponse = details
                }
                completion(true, nil)
            case .failure(let error):
                print(error)
                completion(false, error)
            }
        }
    }
}
