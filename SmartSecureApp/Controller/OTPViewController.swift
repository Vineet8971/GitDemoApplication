//
//  OTPViewController.swift
//  SmartSecureApp
//
//  Created by Ranadheer on 21/12/2022.
//

import UIKit

class OTPViewController: UIViewController, UITextFieldDelegate {
    

    @IBOutlet weak var tf_first: UITextField!
    @IBOutlet weak var tf_second: UITextField!
    @IBOutlet weak var tf_fourth: UITextField!
    @IBOutlet weak var tf_three: UITextField!
    var email = String()
    var password = String()
    var isComingFrom = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        tf_first.layer.borderColor = UIColor.systemGray.cgColor
        tf_first.layer.borderWidth = 1
        
        tf_second.layer.borderColor = UIColor.systemGray.cgColor
        tf_second.layer.borderWidth = 1
        
        tf_three.layer.borderColor = UIColor.systemGray.cgColor
        tf_three.layer.borderWidth = 1
        
        tf_fourth.layer.borderColor = UIColor.systemGray.cgColor
        tf_fourth.layer.borderWidth = 1
        
        tf_first.textAlignment = .center
        tf_second.textAlignment = .center
        tf_three.textAlignment = .center
        tf_fourth.textAlignment = .center
        
        tf_first.delegate = self
        tf_second.delegate = self
        tf_three.delegate = self
        tf_fourth.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tf_first.becomeFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (range.length == 0){
            if textField == tf_first {
                tf_second.becomeFirstResponder()
            }
            if textField == tf_second {
                tf_three.becomeFirstResponder()
            }
            if textField == tf_three {
                tf_fourth.becomeFirstResponder()
            }
            if textField == tf_fourth {
                tf_fourth.resignFirstResponder()
                var tot = "\((tf_first?.text)!)\((tf_second?.text)!)\((tf_three?.text)!)\((tf_fourth?.text)!)\(string)"
            }
            textField.text = string
            return false
        } else if (range.length == 1){
            if textField == tf_fourth {
                tf_three.becomeFirstResponder()
            }
            if textField == tf_three {
                tf_second.becomeFirstResponder()
            }
            if textField == tf_second {
                tf_first.becomeFirstResponder()
            }
            if textField == tf_first {
                tf_first.resignFirstResponder()
            }
            textField.text = ""
            return false
        }
        return true
    }
    

    @IBAction func backBtnTapped(_ sender: Any) {
        self.isComingFrom = ""
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        if ((tf_first.text != "") && (tf_second.text != "") && (tf_three.text != "") && (tf_fourth.text != "")){
            
            if isComingFrom == "SignUp" || isComingFrom == "SignIn"{
                emailOtpCall()
            } else {
                otpApiCall()
            }
        } else {
            
            AlertHelper.shared.toShowAlert(title: "Alert", message: "OTP Incorrect", viewController: self)
          //  self.showToast(message: "OTP Incorrect")
        }
    }
    
    func emailOtpCall() {
        let combine = "\(tf_first.text ?? "")\(tf_second.text ?? "")\(tf_three.text ?? "")\(tf_fourth.text ?? "")"
        print(combine)
        LoadingUtils.shared.showActivityIndicator(uiView: self.view)
        OTPAPIClient.shared.emailotpApiIntegration(email: email, funct: "email_verify", code: combine) { success, error in
            if success {
                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                let alert = EmailOTPList.EmailOTPResponse["alert"] as? String
                let msg = EmailOTPList.EmailOTPResponse["msg"] as? String
                let err = EmailOTPList.EmailOTPResponse["error"] as? String
                if msg == "success" {
                    self.isComingFrom = ""
                    let data = EmailOTPList.EmailOTPResponse["0"] as? Dictionary<String, Any>
                    
                    if let userId = data?["id"] as? String {
                        UserDefaults.standard.set(userId, forKey: "userid")
                        print("userid:",userId)
                    }
                    if let userName = data?["username"] as? String {
                        UserDefaults.standard.set(userName, forKey: "userName")
                    }
                    
                    UserDefaults.standard.setValue(self.password, forKey: "userPassword")
                    UserDefaults.standard.set(true, forKey: "autoLogin")
                    
                    AlertHelper.shared.ShowAlertWithCompletionMethod(title: "Alert", message: alert ?? "", viewController: self) {
                        let loginVC = self.storyboard?.instantiateViewController(identifier: "TabsVC") as? TabsVC
                        self.navigationController?.pushViewController(loginVC!, animated: true)
                    }
                } else{
                    
                    AlertHelper.shared.toShowAlert(title: "Alert", message: msg ?? "", viewController: self)
                   // self.showToast(message: err ?? "")
                }
            } else if let error = error {
                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                print("error.localizedDescription\(error.localizedDescription)")
            }
        }
    }
    
    func otpApiCall(){
        let combine = "\(tf_first.text ?? "")\(tf_second.text ?? "")\(tf_three.text ?? "")\(tf_fourth.text ?? "")"
        print(combine)
        LoadingUtils.shared.showActivityIndicator(uiView: self.view)
        OTPAPIClient.shared.otpApiIntegration(email: email, funct: "forgot_password_second", code: combine) { success, error in
            if success {
                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                let msg = OTPList.OTPResponse["msg"] as? String
                let err = OTPList.OTPResponse["error"] as? String
                if msg == "success" {
                    let nextVC = self.storyboard?.instantiateViewController(identifier: "EnterNewDetailsVC") as? EnterNewDetailsVC
                    nextVC?.code = combine
                    nextVC?.email = self.email
                    self.navigationController?.pushViewController(nextVC!, animated: true)
                } else{
                    
                    AlertHelper.shared.toShowAlert(title: "Alert", message: msg ?? "", viewController: self)
                   // self.showToast(message: err ?? "")
                }
            } else if let error = error {
                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                print("error.localizedDescription\(error.localizedDescription)")
            }
        }
    }
}
