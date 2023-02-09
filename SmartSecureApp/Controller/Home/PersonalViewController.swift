//
//  PersonalViewController.swift
//  SmartSecureApp
//
//  Created by Ranadheer on 23/12/2022.
//

import UIKit

class PersonalViewController: UIViewController {

    @IBOutlet weak var female_radioButton: UIButton!
    @IBOutlet weak var male_radioButton: UIButton!
    @IBOutlet weak var other_radioButton: UIButton!
    @IBOutlet weak var tf_name: UITextField!
    @IBOutlet weak var tf_LastName: UITextField!
    @IBOutlet weak var tf_city: UITextField!
    @IBOutlet weak var tf_phoneNumber: UITextField!
    @IBOutlet weak var tf_email: UITextField!
    var isSelected = String()
    var firstName = String()
    var lastName = String()
    var userId = String()
    var dob = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tf_name.layer.borderColor = UIColor.systemGray.cgColor
        tf_name.layer.borderWidth = 1
        tf_LastName.layer.borderColor = UIColor.systemGray.cgColor
        tf_LastName.layer.borderWidth = 1
        tf_city.layer.borderColor = UIColor.systemGray.cgColor
        tf_city.layer.borderWidth = 1
        tf_phoneNumber.layer.borderColor = UIColor.systemGray.cgColor
        tf_phoneNumber.layer.borderWidth = 1
        tf_email.layer.borderColor = UIColor.systemGray.cgColor
        tf_email.layer.borderWidth = 1
        
        tf_name.attributedPlaceholder = NSAttributedString(string: "First Name",attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemRed])
        tf_LastName.attributedPlaceholder = NSAttributedString(string: "Last Name",attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemRed])
        
        tf_city.attributedPlaceholder = NSAttributedString(string: "City",attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemRed])
        tf_phoneNumber.attributedPlaceholder = NSAttributedString(string: "Phone Number",attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemRed])
        tf_email.attributedPlaceholder = NSAttributedString(string: "Email",attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemRed])
        
        tf_name.addPadding(.left(10))
        tf_email.addPadding(.left(10))
        tf_LastName.addPadding(.left(10))
        tf_city.addPadding(.left(10))
        tf_phoneNumber.addPadding(.left(10))
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userId = "\(UserDefaults.standard.value(forKey: "userid") ?? "")"
        getUserDetail()
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
                        
                        self.dob = "\(detail["dob"] ?? "")"
                        self.tf_name.text = "\(detail["first_name"] ?? "")"
                        self.tf_LastName.text = "\(detail["last_name"] ?? "")"
                        self.tf_city.text = "\(detail["location"] ?? "")"
                        self.tf_phoneNumber.text = "\(detail["phone"] ?? "")"
                        self.tf_email.text = "\(detail["email"] ?? "")"
                        self.isSelected = "\(detail["gender"] ?? "")"
                        if self.isSelected == "male" {
                            self.male_radioButton.setImage(UIImage(systemName: "circle.inset.filled"), for: .normal)
                            self.female_radioButton.setImage(UIImage(systemName: "circle"), for: .normal)
                            self.other_radioButton.setImage(UIImage(systemName: "circle"), for: .normal)
                        } else if self.isSelected == "other" {
                            self.other_radioButton.setImage(UIImage(systemName: "circle.inset.filled"), for: .normal)
                            self.female_radioButton.setImage(UIImage(systemName: "circle"), for: .normal)
                            self.male_radioButton.setImage(UIImage(systemName: "circle"), for: .normal)
                            
                    } else if self.isSelected == "female" {
                            self.male_radioButton.setImage(UIImage(systemName: "circle"), for: .normal)
                            self.other_radioButton.setImage(UIImage(systemName: "circle"), for: .normal)
                            self.female_radioButton.setImage(UIImage(systemName: "circle.inset.filled"), for: .normal)
                    } else {
                        self.male_radioButton.setImage(UIImage(systemName: "circle"), for: .normal)
                        self.other_radioButton.setImage(UIImage(systemName: "circle"), for: .normal)
                        self.female_radioButton.setImage(UIImage(systemName: "circle"), for: .normal)
                    }
                    }
                    
                } else{
                   // LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                    AlertHelper.shared.toShowAlert(title: "Alert", message: msg ?? "", viewController: self)
                }
            } else if let error = error {
                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                print("error.localizedDescription\(error.localizedDescription)")
            }
        }
    }
    
    func updateUserProfile() {
        LoadingUtils.shared.showActivityIndicator(uiView: self.view)
        UserDetailApiClient.shared.udateUserDetailApiIntegration(funct: "update_profile",email: tf_email.text ?? "", firstName: tf_name.text ?? "", lastName: tf_LastName.text ?? "", dob: self.dob, gender: self.isSelected, profilePic: "", phone: tf_phoneNumber.text ?? "", location: tf_city.text ?? "") { success, error in
            if success {
                let msg = UserDetailList.UserDetailResponse["msg"] as? String
                let err = UserDetailList.UserDetailResponse["error"] as? String
                let alert = UserDetailList.UserDetailResponse["alert"] as? String
            
                if msg == "success" {
                    AlertHelper.shared.ShowAlertWithCompletionMethod(title: "Alert", message: alert ?? "", viewController: self) {
                        self.getUserDetail()
                    }
                } else{
                    // LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                     AlertHelper.shared.toShowAlert(title: "Alert", message: msg ?? "", viewController: self)
                 }
            } else if let error = error {
                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                print("error.localizedDescription\(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnMaleTapped(_ sender: Any) {
        isSelected = "male"
        male_radioButton.setImage(UIImage(systemName: "circle.inset.filled"), for: .normal)
        female_radioButton.setImage(UIImage(systemName: "circle"), for: .normal)
        other_radioButton.setImage(UIImage(systemName: "circle"), for: .normal)
    }
    
    @IBAction func btnFemaleTapped(_ sender: Any) {
        isSelected = "female"
        male_radioButton.setImage(UIImage(systemName: "circle"), for: .normal)
        other_radioButton.setImage(UIImage(systemName: "circle"), for: .normal)
        female_radioButton.setImage(UIImage(systemName: "circle.inset.filled"), for: .normal)
    }
    @IBAction func btnOtherTapped(_ sender: UIButton) {
        isSelected = "other"
        other_radioButton.setImage(UIImage(systemName: "circle.inset.filled"), for: .normal)
        male_radioButton.setImage(UIImage(systemName: "circle"), for: .normal)
        female_radioButton.setImage(UIImage(systemName: "circle"), for: .normal)
    }
    
    
    @IBAction func emailTapped(_ sender: Any) {
        if isValidEmail(email: tf_email.text!) && tf_email.text != "" {
            print("working")
        } else {
           // LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
            AlertHelper.shared.toShowAlert(title: "Alert", message: "Please Enter valid Email", viewController: self)
          //  showToast(message: "Please Enter valid Email")
        }
    }
    
    @IBAction func phoneNumberTapped(_ sender: Any) {
        if tf_phoneNumber.text!.count < 10 {
          //  LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
            AlertHelper.shared.toShowAlert(title: "Alert", message: "Phone number is less than 10 numbers", viewController: self)
          //  showToast(message: "Phone number is less than 10 numbers")
        } else {
            self.isValidPhone(phone: tf_phoneNumber.text!)
        }
    }
    
    @IBAction func saveBtnTapped(_ sender: Any) {
        if tf_email.text != "" {
            self.updateUserProfile()
        } else {
            
          //  LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
            AlertHelper.shared.toShowAlert(title: "Alert", message: "Email Field cannot be empty.", viewController: self)
            
           // self.showToast(message: "fileds are missing")
        }
    }

}

extension UITextField {

    enum PaddingSide {
        case left(CGFloat)
        case right(CGFloat)
        case both(CGFloat)
    }

    func addPadding(_ padding: PaddingSide) {

        self.leftViewMode = .always
        self.layer.masksToBounds = true


        switch padding {

        case .left(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.leftView = paddingView
            self.rightViewMode = .always

        case .right(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.rightView = paddingView
            self.rightViewMode = .always

        case .both(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            // left
            self.leftView = paddingView
            self.leftViewMode = .always
            // right
            self.rightView = paddingView
            self.rightViewMode = .always
        }
    }
}
