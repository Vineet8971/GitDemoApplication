//
//  HistoryApiClient.swift
//  SmartSecureApp
//
//  Created by Vineet Sharma on 06/02/23.
//

import Foundation
import Alamofire

struct HistoryList {
    static var HistoryResponse = [String:Any]()
}


class HistoryApiClient {
    static let shared = HistoryApiClient()

    func fetchHistoryApiIntegration(funct:String,userId:String,completion: @escaping (Bool, Error?) -> Void) {
    let url = RequestURL.BASEURL
    //"https://skyhighcloud.tech/smartSecure/routes/actions/users.php"

        let parameters : [String : Any] = ["func":funct,"user_id":userId]
    
    print(parameters)
    AlamofireManager.request(url, method: .post, parameters: parameters, encoding: URLEncoding(destination: .httpBody)) { (response) -> Void in
        switch response.result {
        case .success:
            if let details = response.result.value as? [String:Any] {
                HistoryList.HistoryResponse = details
            }
            completion(true, nil)
        case .failure(let error):
            print(error)
            completion(false, error)
        }
    }
    }
    
    func deleteHistoryApiIntegration(funct:String,id:String,completion: @escaping (Bool, Error?) -> Void) {
        let url = RequestURL.BASEURL
        //"https://skyhighcloud.tech/smartSecure/routes/actions/users.php"

            let parameters : [String : Any] = ["func":funct,"id":id]
        
        print(parameters)
        AlamofireManager.request(url, method: .post, parameters: parameters, encoding: URLEncoding(destination: .httpBody)) { (response) -> Void in
            switch response.result {
            case .success:
                if let details = response.result.value as? [String:Any] {
                    HistoryList.HistoryResponse = details
                }
                completion(true, nil)
            case .failure(let error):
                print(error)
                completion(false, error)
            }
        }
    }
    
}

