//
//  SignUpViewController.swift
//  SmartSecureApp
//
//  Created by Ranadheer on 20/12/2022.
//

import UIKit

class SignUpViewController: UIViewController,UITextFieldDelegate {

    
    @IBOutlet weak var lbl_confirmRequired: UILabel!
    @IBOutlet weak var lbl_passRequired: UILabel!
    @IBOutlet weak var lbl_phoneNumberRequired: UILabel!
    @IBOutlet weak var lbl_lastNameRequired: UILabel!
    @IBOutlet weak var lbl_firstNameRequired: UILabel!
    
    @IBOutlet weak var lockBtn: UIButton!
    @IBOutlet weak var tf_firstName: UITextField!
    @IBOutlet weak var tf_lastName: UITextField!
    @IBOutlet weak var tf_phonenumber: UITextField!
    @IBOutlet weak var male_radioBtn: UIButton!
    @IBOutlet weak var female_radioBtn: UIButton!
    @IBOutlet weak var other_radioBtn: UIButton!
    @IBOutlet weak var tf_confirmPassword: UITextField!
    @IBOutlet weak var tf_password: UITextField!
    @IBOutlet weak var tf_email: UITextField!
    var isSelected = "1"
    var mobileCount = 0
    var isChecked = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tf_phonenumber.delegate = self
        tf_firstName.attributedPlaceholder = NSAttributedString(string: "First Name",attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        tf_lastName.attributedPlaceholder = NSAttributedString(string: "Last Name",attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        tf_phonenumber.attributedPlaceholder = NSAttributedString(string: "Phone Number",attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        
        tf_email.attributedPlaceholder = NSAttributedString(string: "Email",attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        tf_password.attributedPlaceholder = NSAttributedString(string: "Password",attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        tf_confirmPassword.attributedPlaceholder = NSAttributedString(string: "Confirm Password",attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        
//        tf_phonenumber.addPadding(.left(10))
//        tf_firstName.addPadding(.left(10))
//        tf_lastName.addPadding(.left(10))
//        tf_email.addPadding(.left(10))
//        tf_password.addPadding(.left(10))
//        tf_confirmPassword.addPadding(.left(10))
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }

    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func emailTapped(_ sender: Any) {
        if isValidEmail(email: tf_email.text!) && tf_email.text != "" {
            print("working")
        } else {
            showToast(message: "Please Enter valid Email")
        }
    }
    
    
    @IBAction func phoneNumberTapped(_ sender: Any) {
        if tf_phonenumber.text!.count < 10 {
            
            AlertHelper.shared.toShowAlert(title: "Alert", message: "Phone number is less than 10 numbers", viewController: self)
           // showToast(message: "Phone number is less than 10 numbers")
        } else {
            self.isValidPhone(phone: tf_phonenumber.text!)
        }
    }
    
    @IBAction func maleBtnTapped(_ sender: Any) {
        isSelected = "male"
        male_radioBtn.setImage(UIImage(systemName: "circle.inset.filled"), for: .normal)
        female_radioBtn.setImage(UIImage(systemName: "circle"), for: .normal)
        other_radioBtn.setImage(UIImage(systemName: "circle"), for: .normal)
    }
    
    @IBAction func femaleBtnTapped(_ sender: Any) {
        isSelected = "female"
        male_radioBtn.setImage(UIImage(systemName: "circle"), for: .normal)
        other_radioBtn.setImage(UIImage(systemName: "circle"), for: .normal)
        female_radioBtn.setImage(UIImage(systemName: "circle.inset.filled"), for: .normal)
    }
    @IBAction func otherBtnTapped(_ sender: UIButton) {
        isSelected = "other"
        male_radioBtn.setImage(UIImage(systemName: "circle"), for: .normal)
        female_radioBtn.setImage(UIImage(systemName: "circle"), for: .normal)
        other_radioBtn.setImage(UIImage(systemName: "circle.inset.filled"), for: .normal)
    }
    
    
    @IBAction func lockBtnTapped(_ sender: Any) {
        if lockBtn.tag == 0 {
            tf_confirmPassword.isSecureTextEntry = false
            lockBtn.tag = 1
            lockBtn.setImage(UIImage(systemName: "lock.open.fill"), for: .normal)
        } else{
            tf_confirmPassword.isSecureTextEntry = true
            lockBtn.tag = 0
            lockBtn.setImage(UIImage(systemName: "lock.fill"),for: .normal)
        }
    }
    
    @IBAction func submitBtnTapped(_ sender: Any) {
                    if tf_email.text != "" {
                        if tf_password.text == tf_confirmPassword.text {
                            userRegistrationApi()
                        } else {
                            AlertHelper.shared.toShowAlert(title: "Alert", message: "Both passwords are not matching", viewController: self)
                         //   self.showToast(message: "Both passwords are not matching")
                        }
                    } else {
                        AlertHelper.shared.toShowAlert(title: "Alert", message: "Email Field cannot be empty.", viewController: self)
                       // self.showToast(message: "Email Field cannot be empty")
                    }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == tf_phonenumber {
            guard let textFieldText = tf_phonenumber.text,
                  let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                      return false
                  }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            mobileCount = count

            return count <= 15
        }else {
            return true
        }
    }
    
    @IBAction func privacyBtnTapped(_ sender: Any) {
        let loginVC = self.storyboard?.instantiateViewController(identifier: "PrivacyViewController") as? PrivacyViewController
        loginVC?.isSelect = "Privacy"
        self.navigationController?.pushViewController(loginVC!, animated: true)
    }
    
    @IBAction func termsConditonBtnTapped(_ sender: Any) {
        let loginVC = self.storyboard?.instantiateViewController(identifier: "PrivacyViewController") as? PrivacyViewController
        loginVC?.isSelect = "Terms"
        self.navigationController?.pushViewController(loginVC!, animated: true)
    }
    
    //MARK:- API Service
    func userRegistrationApi(){
        let device = UserDefaults.standard.value(forKey: "devicetoken") as? String ?? "12345"
        guard let firstName = tf_firstName.text?.trimmingCharacters(in: .whitespaces) else {return}
        guard let lastName = tf_lastName.text?.trimmingCharacters(in: .whitespaces) else {return}
        guard let phone = tf_phonenumber.text?.trimmingCharacters(in: .whitespaces) else {return}
        guard let email = tf_email.text?.trimmingCharacters(in: .whitespaces) else {return}
        guard let password = tf_password.text?.trimmingCharacters(in: .whitespaces) else {return}
        guard let confirm = tf_confirmPassword.text?.trimmingCharacters(in: .whitespaces) else {return}
        
        LoadingUtils.shared.showActivityIndicator(uiView: self.view)
        SignUpAPIClient.shared.userRegistrationApiIntegration(email: email, password: password, funct: "signup", first_name: firstName, last_name: lastName, gender: isSelected, phone: phone, role: 2, location: "India") { success, error in
            if success {
                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                let msg = SignUpList.SignUpResponse["msg"] as? String
                let err = SignUpList.SignUpResponse["error"] as? String
                if msg == "success" {
//                    let loginVC = self.storyboard?.instantiateViewController(identifier: "SignInViewController") as? SignInViewController
//                    self.navigationController?.pushViewController(loginVC!, animated: true)
                    let loginVC = self.storyboard?.instantiateViewController(identifier: "OTPViewController") as? OTPViewController
                    loginVC?.email = self.tf_email.text ?? ""
                    loginVC?.password = self.tf_password.text ?? ""
                    loginVC?.isComingFrom = "SignUp"
                    self.navigationController?.pushViewController(loginVC!, animated: true)
                } else {
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
