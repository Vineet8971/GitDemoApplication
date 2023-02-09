//
//  EnterNewDetailsVC.swift
//  SmartSecureApp
//
//  Created by Ranadheer on 21/12/2022.
//

import UIKit

class EnterNewDetailsVC: UIViewController {

    @IBOutlet weak var tf_newPassword: UITextField!
    @IBOutlet weak var tf_confirmPasword: UITextField!
    var code = String()
    var email = String()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if tf_newPassword.text == tf_confirmPasword.text {
            newDetailsApiCall()
        } else {
            
            AlertHelper.shared.toShowAlert(title: "Alert", message: "both passwords are not same", viewController: self)
           // self.showToast(message: "both passwords are not same")
        }
    }
    
    func newDetailsApiCall(){
        LoadingUtils.shared.showActivityIndicator(uiView: self.view)
        NDetailsAPIClient.shared.nDetailsApiIntegration(email: email, funct: "forgot_password_third", password: tf_newPassword.text ?? "") { success, error in
            if success {
                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                let msg = NDetailsList.NDetailsResponse["msg"] as? String
                let err = NDetailsList.NDetailsResponse["error"] as? String
                if msg == "success" {
                    let nextVC = self.storyboard?.instantiateViewController(identifier: "TabsVC") as? TabsVC
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
