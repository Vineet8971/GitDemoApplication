//
//  AlamofireManager.swift
//  SmartSecureApp
//
//  Created by Ranadheer on 21/12/2022.
//

import Alamofire

struct AlamofireManager {

    static var requestId = 1

    static func request(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil,
        completionHandler: @escaping (DataResponse<Any>) -> Void)
        
    {
        _ = requestId
        requestId += 1
        let start = Date()
        Alamofire.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON(completionHandler: { (data) in
            let end = Date()
            _ = end.timeIntervalSince(start)
            completionHandler(data)
        })
    }
}

class AlertHelper: NSObject {
    static let shared = AlertHelper()
    private override init() { }
    
    //To Show Pop-Up/Alert
    func toShowAlert(title: String?, message: String?, viewController: UIViewController){
        
        viewController.view.endEditing(true)
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    func ShowAlertWithCompletion(title: String?, message: String?, viewController: UIViewController,completion: @escaping () -> ()){
        
        viewController.view.endEditing(true)
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: {
        action in
            
            completion()
            
            
        }))
        
        
        viewController.present(alert, animated: true, completion: nil)
    }
    func ShowAlertWithCompletionMethod(title: String?, message: String?, viewController: UIViewController,completion: @escaping () -> ()){
        
        viewController.view.endEditing(true)
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {
        action in
            
            completion()
            
            
        }))
        viewController.present(alert, animated: true, completion: nil)
    }
}
