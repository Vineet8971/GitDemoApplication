//
//  ForgotDetailsViewController.swift
//  SmartSecureApp
//
//  Created by Ranadheer on 20/12/2022.
//

import UIKit

class ForgotDetailsViewController: UIViewController {

    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var lbl_content: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        if tf_email.text != ""{
            forgotPasswordApiCall()
        } else {
            
            AlertHelper.shared.toShowAlert(title: "Alert", message: "Please enter email address", viewController: self)
           // self.showToast(message: "Please enter email address")
        }
    }
    

    @IBAction func loginBtnTapped(_ sender: Any) {
        let loginVC = self.storyboard?.instantiateViewController(identifier: "SignInViewController") as? SignInViewController
        self.navigationController?.pushViewController(loginVC!, animated: true)
    }

    @IBAction func creatAccountTapped(_ sender: Any) {
        let loginVC = self.storyboard?.instantiateViewController(identifier: "SignUpViewController") as? SignUpViewController
        self.navigationController?.pushViewController(loginVC!, animated: true)
    }
    
    func forgotPasswordApiCall(){
        guard let email = tf_email.text?.trimmingCharacters(in: .whitespaces) else {return}
        LoadingUtils.shared.showActivityIndicator(uiView: self.view)
        ForgotAPIClient.shared.forgotApiIntegration(email: email, funct: "forgot_password_one") { success, error in
            if success {
                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                let msg = ForgotList.ForgotResponse["msg"] as? String
                let err = ForgotList.ForgotResponse["error"] as? String
                if msg == "success" {
                    let nextVC = self.storyboard?.instantiateViewController(identifier: "OTPViewController") as? OTPViewController
                    nextVC?.email = self.tf_email.text ?? ""
                    self.navigationController?.pushViewController(nextVC!, animated: true)
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
}
