//
//  SignInViewController.swift
//  SmartSecureApp
//
//  Created by Ranadheer on 20/12/2022.
//
import Foundation
import UIKit
import Contacts
import ContactsUI

class SignInViewController: UIViewController, UINavigationBarDelegate, UITextFieldDelegate,CNContactPickerDelegate {

    @IBOutlet weak var lbl_email: UILabel!
    @IBOutlet weak var lbl_passRequired: UILabel!
    @IBOutlet weak var lockBtn: UIButton!
    @IBOutlet weak var tf_password: UITextField!
    @IBOutlet weak var tf_email: UITextField!
    
    var mobileCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        tf_email.delegate = self
        tf_email.attributedPlaceholder = NSAttributedString(string: "Email",attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        tf_password.attributedPlaceholder = NSAttributedString(string: "Password",attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        
//        tf_email.addPadding(.left(10))
//        tf_password.addPadding(.left(10))
        navigationController?.navigationBar.delegate = self

        requestContactPermissions { didGrantPermission in

              if didGrantPermission {
                 //this is the part where you know if the user granted permission:
                 // This is where the view change is occurring.
              }
           }
        
        // Do any additional setup after loading the view.
    }
      
    func requestContactPermissions(completion: @escaping (Bool) -> ()) {
        let store = CNContactStore()
        var authStatus = CNContactStore.authorizationStatus(for: .contacts)
        switch authStatus {
        case .notDetermined:
           print("You need to request authorization via the API now.")
           store.requestAccess(for: .contacts) { success, error in
              if let error = error {
                 print("Not authorized to access contacts. Error = \(String(describing: error))")
                exit(1)
                //call completion for failure
                completion(false)
              }

              if success {
                //call completion for success
                completion(true)
                print("Access granted")
              }
          }
        case .restricted:
            print("Access granted")
        case .denied:
            print("Access granted")
        case .authorized:
            print("Access granted")
        @unknown default:
            print("Access granted")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        if (UserDefaults.standard.value(forKey: "autoLogin") != nil) == true {
//            let loginVC = self.storyboard?.instantiateViewController(identifier: "TabsVC") as? TabsVC
//            self.navigationController?.pushViewController(loginVC!, animated: true)
//        }
//        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func lockIconTapped(_ sender: Any) {
        if lockBtn.tag == 0 {
            tf_password.isSecureTextEntry = false
            lockBtn.tag = 1
            lockBtn.setImage(UIImage(systemName: "lock.open.fill"), for: .normal)
        } else{
            tf_password.isSecureTextEntry = true
            lockBtn.tag = 0
            lockBtn.setImage(UIImage(systemName: "lock.fill"),for: .normal)
        }
    }

    @IBAction func emailTapped(_ sender: Any) {
//        if isValidEmail(email: tf_email.text!)  {
//            print("working")
//        } else {
//
//            AlertHelper.shared.toShowAlert(title: "", message: "invalid email address", viewController: self)
//          //  self.showToast(message: "invalid email address")
//        }
    }
    
    
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        let loginVC = self.storyboard?.instantiateViewController(identifier: "ForgotDetailsViewController") as? ForgotDetailsViewController
        self.navigationController?.pushViewController(loginVC!, animated: true)
    }
    
    @IBAction func signUpBtnTapped(_ sender: Any) {
        let loginVC = self.storyboard?.instantiateViewController(identifier: "SignUpViewController") as? SignUpViewController
        self.navigationController?.pushViewController(loginVC!, animated: true)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        if tf_email.text != "" {
            if isValidEmail(email: tf_email.text!)  {
                if tf_password.text != "" {
                    loginApiCall()
                } else {
                    
                    AlertHelper.shared.toShowAlert(title: "Alert", message: "Password cannot be empty", viewController: self)
                  //  self.showToast(message: "Password cannot be empty")
                }
                
            } else {
                
                AlertHelper.shared.toShowAlert(title: "Alert", message: "invalid email address", viewController: self)
              //  self.showToast(message: "invalid email address")
            }
        } else {
            AlertHelper.shared.toShowAlert(title: "Alert", message: "Email cannot be empty", viewController: self)
          //  self.showToast(message: "Email cannot be empty")
        }
    }
   
    @IBAction func privacyBtnTapped(_ sender: Any) {
        let loginVC = self.storyboard?.instantiateViewController(identifier: "PrivacyViewController") as? PrivacyViewController
        loginVC?.isSelect = "Privacy"
        self.navigationController?.pushViewController(loginVC!, animated: true)
    }
    
    @IBAction func termConditionBtnTapped(_ sender: Any) {
        let loginVC = self.storyboard?.instantiateViewController(identifier: "PrivacyViewController") as? PrivacyViewController
        loginVC?.isSelect = "Terms"
        self.navigationController?.pushViewController(loginVC!, animated: true)
    }
    
    //MARK:- API CALL
    func loginApiCall(){
        let device = UserDefaults.standard.value(forKey: "devicetoken") as? String ?? "12345"
        guard let email = tf_email.text?.trimmingCharacters(in: .whitespaces) else {return}
        guard let password = tf_password.text?.trimmingCharacters(in: .whitespaces) else {return}
        
        
        
        LoadingUtils.shared.showActivityIndicator(uiView: self.view)
        SignInAPIClient.shared.signInApiIntegration(email: email, password: password, funct: "login") { success, error in
            if success {
                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                let msg = SignInList.SignInResponse["msg"] as? String
                let alert = SignInList.SignInResponse["alert"] as? String
                let err = SignInList.SignInResponse["error"] as? String
                if msg == "success" {
                    let data = SignInList.SignInResponse["0"] as? Dictionary<String, Any>
                    
                    if let userId = data?["id"] as? String {
                        UserDefaults.standard.set(userId, forKey: "userid")
                        print("userid:",userId)
                    }
                    if let userName = data?["username"] as? String {
                        UserDefaults.standard.set(userName, forKey: "userName")
                    }
                    
                    UserDefaults.standard.setValue(self.tf_password.text ?? "", forKey: "userPassword")
                    
                    UserDefaults.standard.set(true, forKey: "autoLogin")
                    
                    AlertHelper.shared.ShowAlertWithCompletionMethod(title: "Alert", message: alert ?? "", viewController: self) {
                        let loginVC = self.storyboard?.instantiateViewController(identifier: "TabsVC") as? TabsVC
                        self.navigationController?.pushViewController(loginVC!, animated: true)
                    }
                    
                } else if alert == "User Account not yet activated!" {
                    
                    AlertHelper.shared.ShowAlertWithCompletionMethod(title: "Alert", message: alert ?? "", viewController: self) {
                        let otpVC = self.storyboard?.instantiateViewController(identifier: "OTPViewController") as? OTPViewController
                        otpVC?.email = self.tf_email.text ?? ""
                        otpVC?.isComingFrom = "SignIn"
                        self.navigationController?.pushViewController(otpVC!, animated: true)
                    }
                } else{
                    AlertHelper.shared.toShowAlert(title: "Alert", message: msg ?? "", viewController: self)
                   // self.showToast(message: msg ?? "")
                }
            } else if let error = error {
                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                AlertHelper.shared.toShowAlert(title: "Error", message: "\(error.localizedDescription)", viewController: self)
            }
        }
    }
}
