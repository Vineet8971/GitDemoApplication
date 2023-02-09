//
//  ContactusVC.swift
//  SmartSecureApp
//
//  Created by Ranadheer on 26/12/2022.
//

import UIKit

class ContactusVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var tf_subject: UITextField!
    @IBOutlet weak var txt_message: UITextView!
    
    var firstName = String()
    var lastName = String()
    var userId = String()
    var phoneNumber = String()
    var email = String()
    var message = String()
    var subject = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txt_message.delegate = self
        txt_message.layer.borderColor = UIColor.systemGray.cgColor
        txt_message.layer.borderWidth = 1
        
        tf_subject.layer.borderColor = UIColor.systemGray.cgColor
        tf_subject.layer.borderWidth = 1
        
        tf_subject.attributedPlaceholder = NSAttributedString(string: " Subject",attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        txt_message.text = " Write a message here"
        
        tf_subject.addPadding(.left(10))
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userId = "\(UserDefaults.standard.value(forKey: "userid") ?? "")"
        self.getUserDetail()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func getUserDetail() {
        LoadingUtils.shared.showActivityIndicator(uiView: self.view)
        UserDetailApiClient.shared.userDetailApiIntegration(userId: userId, funct: "fetchUser_id") { success, error in
            if success {
                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                let msg = UserDetailList.UserDetailResponse["msg"] as? String
                let err = UserDetailList.UserDetailResponse["error"] as? String
                if msg == "success" {
                    let data = UserDetailList.UserDetailResponse["data"] as? [[String:Any]]
                    for detail in data! {
                    
                        self.firstName = "\(detail["first_name"] ?? "")"
                        self.lastName = "\(detail["last_name"] ?? "")"
                        self.phoneNumber = "\(detail["phone"] ?? "")"
                        self.email = "\(detail["email"] ?? "")"
                       
                        self.lblName.text = "Name: \(self.firstName)"
                        self.lblEmail.text = "Email: \(self.email)"
                        
//                        self.txt_message.text = "\(self.firstName)\n"
//                        + "\(self.email)\n"
                    }
                    
                } else{
                    AlertHelper.shared.toShowAlert(title: "Alert", message: msg ?? "", viewController: self)
                  //  self.showToast(message: err ?? "")
                }
            } else if let error = error {
                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                print("error.localizedDescription\(error.localizedDescription)")
            }
        }
    }
    
    func contactUsApiCall() {
     
        self.subject = self.tf_subject.text ?? ""
    
        LoadingUtils.shared.showActivityIndicator(uiView: self.view)
        ContactUsApiClient.shared.ContactUsApiIntegration(funct: "contact_us", email: self.email, phone: self.phoneNumber, name: "\(self.firstName + " " + self.lastName)", message: "\(self.self.subject + " " + self.message)", userId: self.userId) { success, error in
            if success {
                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                let msg = ContactUsList.ContactUsResponse["msg"] as? String
                let err = ContactUsList.ContactUsResponse["error"] as? String
                let alert = ContactUsList.ContactUsResponse["alert"] as? String
                if msg == "success" {
                   
                    AlertHelper.shared.ShowAlertWithCompletionMethod(title: "Alert", message: alert ?? "", viewController: self) {
                        self.navigationController?.popViewController(animated: true)
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        txt_message.text = ""
      //  txt_message.textColor = .white
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == self.txt_message {
            self.txt_message.text = textView.text
            self.message = self.txt_message.text
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func privacyTapped(_ sender: UIButton) {
        let loginVC = self.storyboard?.instantiateViewController(identifier: "PrivacyViewController") as? PrivacyViewController
        loginVC?.isSelect = "Privacy"
        self.navigationController?.pushViewController(loginVC!, animated: true)
    }
    @IBAction func termsTapped(_ sender: UIButton) {
        let loginVC = self.storyboard?.instantiateViewController(identifier: "PrivacyViewController") as? PrivacyViewController
        loginVC?.isSelect = "Terms"
        self.navigationController?.pushViewController(loginVC!, animated: true)
    }
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        
        if self.txt_message.text != "" && self.tf_subject.text != "" {
            self.contactUsApiCall()
        } else {
            
            AlertHelper.shared.toShowAlert(title: "Alert", message: "All fields are required", viewController: self)
           // showToast(message: "All fields are required")
        }
        
    }
    
}
