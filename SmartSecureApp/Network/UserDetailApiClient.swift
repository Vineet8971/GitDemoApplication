//
//  UserDetailApiClient.swift
//  SmartSecureApp
//
//  Created by Vineet Sharma on 18/01/23.
//

import Foundation
import Alamofire

struct UserDetailList {
    static var UserDetailResponse = [String:Any]()
}


class UserDetailApiClient {
    static let shared = UserDetailApiClient()
    
    func userDetailApiIntegration(userId:String,funct:String,completion: @escaping (Bool, Error?) -> Void) {
        
        let url = RequestURL.BASEURL
        //"https://skyhighcloud.tech/smartSecure/routes/actions/users.php"
   
        let parameters : [String : Any] = ["id":userId,"func":funct]
        
        print(parameters)
        AlamofireManager.request(url, method: .post, parameters: parameters, encoding: URLEncoding(destination: .httpBody)) { (response) -> Void in
            switch response.result {
            case .success:
                if let details = response.result.value as? [String:Any] {
                    UserDetailList.UserDetailResponse = details
                }
                completion(true, nil)
            case .failure(let error):
                print(error)
                completion(false, error)
            }
        }
    
    }
    
    func udateUserDetailApiIntegration(funct:String,email:String,firstName:String,lastName:String,dob:String,gender:String,profilePic:String,phone:String,location:String,completion: @escaping (Bool, Error?) -> Void) {
        let url = RequestURL.BASEURL
        //"https://skyhighcloud.tech/smartSecure/routes/actions/users.php"
   
        let parameters : [String : Any] = ["func":funct,"email":email,"first_name":firstName,"last_name":lastName,"dob":dob,"gender":gender,"profile_pic":profilePic,"phone":phone,"location":location]
        
        print(parameters)
        AlamofireManager.request(url, method: .post, parameters: parameters, encoding: URLEncoding(destination: .httpBody)) { (response) -> Void in
            switch response.result {
            case .success:
                if let details = response.result.value as? [String:Any] {
                    UserDetailList.UserDetailResponse = details
                }
                completion(true, nil)
            case .failure(let error):
                print(error)
                completion(false, error)
            }
        }
    }
    
}
