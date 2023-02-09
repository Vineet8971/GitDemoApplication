//
//  LocationApiClient.swift
//  SmartSecureApp
//
//  Created by Vineet Sharma on 16/01/23.
//

import Foundation
import Alamofire

struct LocationList {
    static var LocationResponse = [String:Any]()
}


class LocationApiClient {
    
    static let shared = LocationApiClient()
    
func insertLoctionApiIntegration(funct:String,userId:String,lat:String,lng:String,location:String,completion:
    @escaping (Bool, Error?) -> Void) {
    let url = RequestURL.BASEURL
    //"https://skyhighcloud.tech/smartSecure/routes/actions/users.php"

    let parameters : [String : Any] = ["func":funct,"user_id":userId,"lat":lat,"lng":lng,"location":location]
    
    print(parameters)
    AlamofireManager.request(url, method: .post, parameters: parameters, encoding: URLEncoding(destination: .httpBody)) { (response) -> Void in
        switch response.result {
        case .success:
            if let details = response.result.value as? [String:Any] {
                LocationList.LocationResponse = details
            }
            completion(true, nil)
        case .failure(let error):
            print(error)
            completion(false, error)
        }
    }
    }
}
