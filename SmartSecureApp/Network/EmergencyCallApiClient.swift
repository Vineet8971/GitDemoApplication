//
//  EmergencyCallApiClient.swift
//  SmartSecureApp
//
//  Created by Vineet Sharma on 16/01/23.
//

import Foundation
import Alamofire

struct EmergenyCallList {
    static var GetCallContactResponse = [String:Any]()
    static var MakeCallResponse = [String:Any]()
    static var SendEmailResponse = [String:Any]()
    static var GetSMSContactsResponse = [String:Any]()
    static var SendSMSResponse = [String:Any]()
}

class EmergencyCallApiClient {
    
    static let shared = EmergencyCallApiClient()
    
    func  getCallContactsAPI(userId:String,funct:String,completion:
                             @escaping (Bool, Error?) -> Void) {
        let url = RequestURL.BASEURL
        //"https://skyhighcloud.tech/smartSecure/routes/actions/users.php"
        
        let parameters : [String : Any] = ["user_id":userId,"func":funct]
        
        print(parameters)
        AlamofireManager.request(url, method: .post, parameters: parameters, encoding: URLEncoding(destination: .httpBody)) { (response) -> Void in
            switch response.result {
            case .success:
                if let details = response.result.value as? [String:Any] {
                    EmergenyCallList.GetCallContactResponse = details
                }
                completion(true, nil)
            case .failure(let error):
                print(error)
                completion(false, error)
            }
        }
    }
    
    func  makeCallAPI(funct:String,phoneNumber:String,message:String,completion:
                             @escaping (Bool, Error?) -> Void) {
        let url = "http://34.202.185.201/make_call.php"
//        RequestURL.BASEURL
        //"https://skyhighcloud.tech/smartSecure/routes/actions/users.php"
        
        
        
        let parameters : [String : Any] = ["func":funct,"phone_number":phoneNumber,"message":message]
        
        AlamofireManager.request(url, method: .post, parameters: parameters, encoding: URLEncoding(destination: .httpBody)) { (response) -> Void in
            switch response.result {
            case .success:
                if let details = response.result.value as? [String:Any] {
                    EmergenyCallList.MakeCallResponse = details
                }
                completion(true, nil)
            case .failure(let error):
                print(error)
                completion(false, error)
            }
        }
    }
    
    func sendEmailContactsAPI(funct:String,userId:String,userName:String,location:String,completion:
                           @escaping (Bool, Error?) -> Void) {
      let url = RequestURL.BASEURL
      //"https://skyhighcloud.tech/smartSecure/routes/actions/users.php"
      
      
      
        let parameters : [String : Any] = ["func":funct,"user_id":userId,"username":userName,"location":location]
      
      AlamofireManager.request(url, method: .post, parameters: parameters, encoding: URLEncoding(destination: .httpBody)) { (response) -> Void in
          switch response.result {
          case .success:
              if let details = response.result.value as? [String:Any] {
                  EmergenyCallList.SendEmailResponse = details
              }
              completion(true, nil)
          case .failure(let error):
              print(error)
              completion(false, error)
          }
      }
  }
    
    func getSMSContactAPI(funct:String,userId:String,completion:
                          @escaping (Bool, Error?) -> Void) {
        let url = RequestURL.BASEURL
        //"https://skyhighcloud.tech/smartSecure/routes/actions/users.php"
        
        let parameters : [String : Any] = ["func":funct,"user_id":userId]
        
        AlamofireManager.request(url, method: .post, parameters: parameters, encoding: URLEncoding(destination: .httpBody)) { (response) -> Void in
            switch response.result {
            case .success:
                if let details = response.result.value as? [String:Any] {
                    EmergenyCallList.GetSMSContactsResponse = details
                }
                completion(true, nil)
            case .failure(let error):
                print(error)
                completion(false, error)
            }
        }
    }
    func sendSMSAPI(funct:String,phoneNumber:String,message:String,completion:
                          @escaping (Bool, Error?) -> Void) {
        let url = "http://34.202.185.201/send_sms.php"
         //RequestURL.BASEURL
        //"https://skyhighcloud.tech/smartSecure/routes/actions/users.php"
        
        let parameters : [String : Any] = ["func":funct,"phone_number":phoneNumber,"message":message]
        
        AlamofireManager.request(url, method: .post, parameters: parameters, encoding: URLEncoding(destination: .httpBody)) { (response) -> Void in
            switch response.result {
            case .success:
                if let details = response.result.value as? [String:Any] {
                    EmergenyCallList.SendSMSResponse = details
                }
                completion(true, nil)
            case .failure(let error):
                print(error)
                completion(false, error)
            }
        }
    }
    
    func request(funct: String?,userId: String?, location: String?, audioFilePath: URL, completion: @escaping (Bool, Error?) -> Void) {
        let url = "https://skyhighcloud.tech/smartSecure/routes/actions/users.php"

        //let headers: HTTPHeaders = [:]
        
        let voiceData = (try? Data(contentsOf: audioFilePath))!
        
            var parameters: [String: Any] = [:]


            if userId != nil {   parameters["user_id"] = userId }
            if location != nil {   parameters["location"] = location }
            if funct != nil {   parameters["func"] = funct }
            // Let's check the data
            //print(parameters)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-hh:mm"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let date = Date()
        let nameOfFile = dateFormatter.string(from: date)+".m4a"

        Alamofire.upload(multipartFormData: { multipartFormData in

                for (key,value) in parameters {
                    multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
                }
            multipartFormData.append(voiceData, withName: "audio",fileName: nameOfFile, mimeType: "audio/m4a")

            }, to: url){(result) in
                switch result {
                case .success(let upload, _, _):
                    print(upload.responseJSON(completionHandler: { response in
                        print(response.result)
                    }))
                        completion(true, nil)
                    case .failure(let encodingError):
                        print("error:\(encodingError)")
                        completion(false, encodingError)
                    }
            }
    }
    
    func GetFormatedDate(date_string:String,dateFormat:String)-> String{

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = dateFormat

        let dateFromInputString = dateFormatter.date(from: date_string)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // Here you can use any dateformate for output date
        if(dateFromInputString != nil){
            return dateFormatter.string(from: dateFromInputString!)
        }
        else{
            debugPrint("could not convert date")
            return "N/A"
        }
    }
    
}
