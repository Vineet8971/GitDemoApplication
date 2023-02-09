//
//  PrivacyViewController.swift
//  SmartSecureApp
//
//  Created by Ranadheer on 20/12/2022.
//

import UIKit
import WebKit

class PrivacyViewController: UIViewController {

    @IBOutlet weak var wkWebView: WKWebView!
    @IBOutlet weak var controllerTitle: UILabel!
    var isChecked = Bool()
    var agreeTC = Int()
    var evnt = String()
    var isSelect = String()
    @IBOutlet weak var btn_check: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isSelect == "Privacy" {
            self.controllerTitle.text = "Privacy Policy"
            privacyApiCall()
        } else {
            self.controllerTitle.text = "Terms And Condition"
            termsApiCall()
        }
        
        wkWebView.backgroundColor = .clear
        btn_check.setImage(UIImage(systemName: "circle"), for: .normal)
        btn_check.addTarget(self, action: #selector(agreeBtnTapped), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func agreeBtnTapped(){
        isChecked = !isChecked
        if isChecked == true {
            print("checked")
            self.agreeTC = 1
            btn_check.setImage(UIImage(systemName: "circle.inset.filled"), for: .normal)
        } else {
            print("unchecked")
            self.agreeTC = 0
            btn_check.setImage(UIImage(systemName: "circle"), for: .normal)
            AlertHelper.shared.toShowAlert(title: "Alert", message: "Please agree to the Privacy Policy", viewController: self)
           // showToast(message: "Please agree to the Privacy Policy")
        }
    }
    
    @IBAction func acceptBtnTpped(_ sender: Any) {
        if agreeTC == 1  {
            let loginVC = self.storyboard?.instantiateViewController(identifier: "SignInViewController") as? SignInViewController
            self.navigationController?.pushViewController(loginVC!, animated: true)
        } else {
            
            AlertHelper.shared.toShowAlert(title: "Alert", message: "Please agree to the Privacy Policy", viewController: self)
          //  showToast(message: "Please agree to the Privacy Policy")
        }
    }
    
    func privacyApiCall(){
        LoadingUtils.shared.showActivityIndicator(uiView: self.view)
        PrivacyAPIClient.shared.privacyApiIntegration(funct: "pages") { success, error in
            if success {
                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                let msg = PrivacyList.PrivacyResponse["msg"] as? String
                _ = PrivacyList.PrivacyResponse["error"] as? String
                if msg == "success" {
                    let data = PrivacyList.PrivacyResponse["data"] as? [[String:Any]]
                    print("data:\(data!)")
                    if let disc = data?[0]["content"] as? String {
                    
                            self.evnt = disc
                            let headerString = "<head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></head>"
                            self.wkWebView.loadHTMLString(headerString + self.evnt, baseURL: nil)
                        _ = 14
                        _ = UIColor.init(named: "Dark Colour")
                        } else{
                            AlertHelper.shared.toShowAlert(title: "Alert", message: msg ?? "", viewController: self)
                            //self.showToast(message: err ?? "")
                        }
                }else if let error = error {
                    LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                    print("error.localizedDescription\(error.localizedDescription)")
                }
            }
        }
    }
    
    func termsApiCall(){
        LoadingUtils.shared.showActivityIndicator(uiView: self.view)
        PrivacyAPIClient.shared.privacyApiIntegration(funct: "pages") { success, error in
            if success {
                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                let msg = PrivacyList.PrivacyResponse["msg"] as? String
                _ = PrivacyList.PrivacyResponse["error"] as? String
                if msg == "success" {
                    let data = PrivacyList.PrivacyResponse["data"] as? [[String:Any]]
                    print("data:\(data!)")
                    if let disc = data?[1]["content"] as? String {
                       
                            self.evnt = disc
                            let headerString = "<head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></head>"
                            self.wkWebView.loadHTMLString(headerString + self.evnt, baseURL: nil)
                        _ = 14
                        _ = UIColor.init(named: "Dark Colour")
                        } else{
                            AlertHelper.shared.toShowAlert(title: "Alert", message: msg ?? "", viewController: self)
                            //self.showToast(message: err ?? "")
                        }
                }else if let error = error {
                    LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                    print("error.localizedDescription\(error.localizedDescription)")
                }
            }
        }
    }
    
}

