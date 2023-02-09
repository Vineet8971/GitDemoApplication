//
//  SettingsViewController.swift
//  SmartSecureApp
//
//  Created by Ranadheer on 22/12/2022.
//

import UIKit
class SettingsViewController: UIViewController {

    @IBOutlet weak var settingTableview: UITableView!
    
    var listNames = ["Personal","Call","Email","Whatsapp","SMS","Siren","History","Privacy Policy","Password Reset","Contact Us","Sign Out","Delete Account"]
    
    var userId = String()
    var siren = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        siren = "\(UserDefaults.standard.value(forKey: "siren") ?? "")"
        
        userId = "\(UserDefaults.standard.value(forKey: "userid") ?? "")"
        
        settingTableview.dataSource = self
        self.settingTableview.delegate = self
        settingTableview.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingTableViewCell")
        settingTableview.reloadData()
        navigationController?.tabBarController?.tabBar.backgroundColor = .black
        // Do any additional setup after loading the view.
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
}

extension SettingsViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingTableview.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell
        
        cell.selectionStyle = .none
        cell.cell_view.layer.borderColor = UIColor.gray.cgColor
        cell.cell_view.layer.borderWidth = 1
        
        cell.lbl_categoryName.text = listNames[indexPath.row]
      //  cell.switch_category.tag = indexPath.row
     //   cell.switch_category.addTarget(self, action: #selector(switchTapped), for: .touchUpInside)
     //   cell.btn_arrow.tag = indexPath.row
      //  cell.btn_arrow.addTarget(self, action: #selector(selectedCategoryTapped), for: .touchUpInside)
        if listNames[indexPath.row] == "Siren" {
            cell.switch_category.isHidden = false
            cell.btn_arrow.isHidden = true
        } else {
            cell.btn_arrow.isHidden = false
            cell.switch_category.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectCat = indexPath.row
        print("button\(selectCat)")
        if indexPath.row == 0 {
            let nxtVC = self.storyboard?.instantiateViewController(identifier: "PersonalViewController") as? PersonalViewController
            self.navigationController?.pushViewController(nxtVC!, animated: true)
        } else if indexPath.row == 1 {
            let nxtVC = self.storyboard?.instantiateViewController(identifier: "CallViewController") as? CallViewController
            nxtVC?.isComingFrom = ""
            self.navigationController?.pushViewController(nxtVC!, animated: true)
        } else if indexPath.row == 2 {
            let emailVC = self.storyboard?.instantiateViewController(identifier: "CallViewController") as? CallViewController
            emailVC?.isComingFrom = "EMAIL"
            self.navigationController?.pushViewController(emailVC!, animated: true)
        } else if indexPath.row == 3 {
            let whatsappVC = self.storyboard?.instantiateViewController(identifier: "CallViewController") as? CallViewController
            whatsappVC?.isComingFrom = "WHATSAPP"
            self.navigationController?.pushViewController(whatsappVC!, animated: true)
        } else if indexPath.row == 4 {
            let smsVC = self.storyboard?.instantiateViewController(identifier: "CallViewController") as? CallViewController
            smsVC?.isComingFrom = "SMS"
            self.navigationController?.pushViewController(smsVC!, animated: true)
        } else if indexPath.row == 6 {
            let nxtVC = self.storyboard?.instantiateViewController(identifier: "HistoryViewController") as? HistoryViewController
            self.navigationController?.pushViewController(nxtVC!, animated: true)
        } else if indexPath.row == 7 {
            let nxtVC = self.storyboard?.instantiateViewController(identifier: "PrivacyViewController") as? PrivacyViewController
            nxtVC?.isSelect = "Privacy"
            self.navigationController?.pushViewController(nxtVC!, animated: true)
        } else if indexPath.row == 8 {
            let nxtVC = self.storyboard?.instantiateViewController(identifier: "ForgotDetailsViewController") as? ForgotDetailsViewController
            UserDefaults.standard.removeObject(forKey: "autoLogin")
            self.navigationController?.pushViewController(nxtVC!, animated: true)
        } else if indexPath.row == 9 {
            let loginVC = self.storyboard?.instantiateViewController(identifier: "ContactusVC") as? ContactusVC
            self.navigationController?.pushViewController(loginVC!, animated: true)
        } else if indexPath.row == 10 {
            let nxtVC = self.storyboard?.instantiateViewController(identifier: "SignInViewController") as? SignInViewController
            UserDefaults.standard.removeObject(forKey: "autoLogin")
            self.navigationController?.pushViewController(nxtVC!, animated: true)
        } else if indexPath.row == 11 {
            
            AlertHelper.shared.ShowAlertWithCompletion(title: "Delete Account", message: "Are you sure to Delete your account ? This action can't be reverserable", viewController: self) {
                LoadingUtils.shared.showActivityIndicator(uiView: self.view)
                deleteAPIClient.shared.deleteAccountApiIntegration(id: self.userId, funct: "deleteUser") { success, error in
                    if success {
                        LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                        let msg = deleteApiList.deleteApiResponse["msg"] as? String
                        let err = deleteApiList.deleteApiResponse["error"] as? String
                        let alert = deleteApiList.deleteApiResponse["alert"] as? String
                        
                        if msg == "success" {
                            
                            UserDefaults.standard.removeObject(forKey: "autoLogin")
                            UserDefaults.standard.removeObject(forKey: "userid")
                            
                            AlertHelper.shared.ShowAlertWithCompletionMethod(title: "Alert", message: alert, viewController: self) {
                                let nxtVC = self.storyboard?.instantiateViewController(identifier: "SignInViewController") as? SignInViewController
                                self.navigationController?.pushViewController(nxtVC!, animated: true)
                            }
                        } else {

                            AlertHelper.shared.toShowAlert(title: "Alert", message: msg ?? "", viewController: self)
                        }
                        
                      } else if let error = error {
                          LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                          print("error.localizedDescription\(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    
    func sirenApiCall() {
        SirenAPIClient.shared.SirenApiIntegration(userid: self.userId, funct: "user_settings_update", siren: siren, callPreferences: "") { success, error in
          if success {
              LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
              let msg = SirenList.SirenResponse["msg"] as? String
              let err = SirenList.SirenResponse["error"] as? String
              let alert = SirenList.SirenResponse["alert"] as? String
              if msg == "success" {
                  UserDefaults.standard.set(self.siren, forKey: "siren")
                  AlertHelper.shared.toShowAlert(title: "Alert", message: alert ?? "", viewController: self)
//                  DispatchQueue.main.async {
//                      self.settingTableview.reloadData()
//                  }
              } else {
                //  LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                  AlertHelper.shared.toShowAlert(title: "Alert", message: msg ?? "", viewController: self)
              }
              
            } else if let error = error {
                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                print("error.localizedDescription\(error.localizedDescription)")
            }
        }
    }
    
    @objc func switchTapped(sender:UISwitch) {
            if sender.isOn {
                self.siren = "1"
                sirenApiCall()
            } else {
                self.siren = "0"
                sirenApiCall()
            }
    }
    
}




