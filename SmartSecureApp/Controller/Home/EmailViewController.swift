//
//  EmailViewController.swift
//  SmartSecureApp
//
//  Created by Ranadheer on 23/12/2022.
//

import UIKit

class EmailViewController: UIViewController,UITextFieldDelegate {

    
    @IBOutlet weak var pickingView: UIView!
    @IBOutlet weak var manualView: UIView!
    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var tf_name: UITextField!
    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var switch_toggle: UISwitch!
    @IBOutlet weak var emailTableview: UITableView!
    
    var isSelected = Bool()
    
    var emptyEmails = [String]()
    var emailList = [String]()
    
    var pickerView : UIPickerView?
    var pickerCheckValue: Int!
    var category = String()
    
    var sendingEmailEm = [String]()
    var sendingEmailOrder = [String]()
 
    var emailEmArr = [String]()
    var emailOrderArr = [String]()
    
    var names = String()
    var email = String()
    var order = String()
    
    
    //var selectedData = [Int]()
    @IBOutlet weak var tf_selectEmail: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dropDownView.isHidden = true
        manualView.isHidden = true
        
        emailTableview.dataSource = self
        emailTableview.delegate = self
        emailTableview.register(UINib(nibName: "HistoryRecordTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryRecordTableViewCell")
        emailTableview.reloadData()
        
        tf_selectEmail.delegate = self
        tf_selectEmail.attributedPlaceholder = NSAttributedString(string: "Select Email",attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        switch_toggle.addTarget(self, action: #selector(switchIsChanged), for: UIControl.Event.valueChanged)
        
        tf_selectEmail.layer.borderColor = UIColor.gray.cgColor
        tf_selectEmail.layer.borderWidth = 1
        
        tf_name.layer.borderColor = UIColor.gray.cgColor
        tf_name.layer.borderWidth = 1
        tf_email.layer.borderColor = UIColor.gray.cgColor
        tf_email.layer.borderWidth = 1
        
        tf_name.attributedPlaceholder = NSAttributedString(string: " Name",attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemRed])
        tf_email.attributedPlaceholder = NSAttributedString(string: "Email",attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemRed])
        
        dropDownView.layer.borderColor = UIColor.gray.cgColor
        dropDownView.layer.borderWidth = 1
        category = "saved list"
        getEmailApiCall()
        // Do any additional setup after loading the view.
    }
    
    @objc func switchIsChanged(mySwitch: UISwitch) {
        if switch_toggle.isOn {
            self.tf_selectEmail.isHidden = false
            emailTableview.isHidden = false
        } else {
            tf_selectEmail.isHidden = true
            emailTableview.isHidden = true
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func deletingContact(sender: UIButton){
        let data = sender.tag
        if category == "saved list" {
            print("data removedid:\(data)")
            self.emptyEmails.remove(at: data)
        }
        self.emailTableview.reloadData()
    }
    
    @IBAction func addEmailTapped(_ sender: Any) {
        if tf_selectEmail.text != "Select Email" {
            sendEmailApiCall()
        } else {
            
          //  LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
            AlertHelper.shared.toShowAlert(title: "Alert", message: "Please select an item", viewController: self)
            
           // self.showToast(message: "Please select an item")
        }
    }
    
    @IBAction func emailTapped(_ sender: Any) {
        
    }
    
    
    @IBAction func addBtnTapped(_ sender: Any) {
        dropDownView.isHidden = false
    }
    
    
    @IBAction func pickingTapped(_ sender: Any) {
        category = "saved list"
        manualView.isHidden = true
        pickingView.isHidden = false
        dropDownView.isHidden = true
    }
    
    @IBAction func manualTapped(_ sender: Any) {
        category = "manual"
        manualView.isHidden = false
        pickingView.isHidden = true
        dropDownView.isHidden = true
    }
    
    
    
    //MARK:- Save sms API Call
    func getEmailApiCall(){
        guard let id = UserDefaults.standard.value(forKey: "userid") as? String else { return }
        LoadingUtils.shared.showActivityIndicator(uiView: self.view)
        getEmailAPIClient.shared.getEmailApiIntegration(userid: id, funct: "get_email_contacts") { success, error in
            if success {
                self.emailList.removeAll()
                self.emailEmArr.removeAll()
                self.emailOrderArr.removeAll()
                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                let msg = getEmailList.getEmailResponse["msg"] as? String
                let err = getEmailList.getEmailResponse["error"] as? String
                if msg == "success" {
                    let data = getEmailList.getEmailResponse["contacts"] as? [[String:Any]]
                    for i in data! {
                        if let nme = i["name"] as? String {
                            self.emailList.append(nme)
                        }
                        
                        if let no = i["email"] as? String {
                            self.emailEmArr.append(no)
                        }
                        
                        if let order = i["order"] as? String {
                            self.emailOrderArr.append(order)
                        }
                    }
                    self.emailTableview.reloadData()
                } else{
                    
                  //  LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                    AlertHelper.shared.toShowAlert(title: "Alert", message: msg ?? "", viewController: self)
                    
                   // self.showToast(message: err ?? "")
                }
            } else if let error = error {
                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                print("error.localizedDescription\(error.localizedDescription)")
            }
        }
    }
    
    func sendEmailApiCall(){
        guard let id = UserDefaults.standard.value(forKey: "userid") as? String else { return }
        let convert = Int(id) ?? 0
        if category == "saved list" {
            email = sendingEmailEm.joined(separator: ",")
            names = emptyEmails.joined(separator: ",")
            order = sendingEmailOrder.joined(separator: ",")
        } else {
            email = tf_email.text ?? ""
            names = tf_name.text ?? ""
            let randomInt = Int.random(in: 1..<10)
            order = String(randomInt)
        }
         
        LoadingUtils.shared.showActivityIndicator(uiView: self.view)
        sendEmailAPIClient.shared.sendEmailAPIClientApiIntegration(funct: "email_contacts", userId: convert, created: "", contactNames: names, contactEmail: email, contactOrder: order) { success, error in
            if success {
                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                let msg = sendEmailList.sendEmailResponse["msg"] as? String
                let err = sendEmailList.sendEmailResponse["error"] as? String
                if msg == "success" {
                    let nVC = self.storyboard?.instantiateViewController(identifier: "SettingsViewController") as? SettingsViewController
                    self.navigationController?.pushViewController(nVC!, animated: true)
                } else{
                    
                //    LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
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

extension EmailViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emptyEmails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = emailTableview.dequeueReusableCell(withIdentifier: "HistoryRecordTableViewCell", for: indexPath) as! HistoryRecordTableViewCell
        
        cell.cell_view.layer.borderColor = UIColor.gray.cgColor
        cell.cell_view.layer.borderWidth = 1
        cell.lbl_audioFiles.text = emptyEmails[indexPath.row]
        cell.btn_delete.tag = indexPath.row
        cell.btn_delete.addTarget(self, action: #selector(deletingContact), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}

extension EmailViewController: UIPickerViewDelegate,UIPickerViewDataSource {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

        if textField == tf_selectEmail {
            pickerCheckValue = 1
            pickUp(tf_selectEmail)
        }
    }

    func pickUp(_ textField : UITextField){
        self.pickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.pickerView?.delegate = self
        self.pickerView?.dataSource = self
        self.pickerView?.backgroundColor = UIColor(red: 247.0 / 255.0, green: 248.0 / 255.0, blue: 247.0 / 255.0, alpha: 1)
        textField.inputView = self.pickerView

        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.white
        toolBar.barTintColor = UIColor.darkGray
        //  toolBar.backgroundColor = UIColor.blue

        toolBar.sizeToFit()

        let doneButton1 = UIBarButtonItem(title:"Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePickerView))
        doneButton1.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
        let cancelButton1 = UIBarButtonItem(title:"Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelPickerView))
        cancelButton1.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)

        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.items = [cancelButton1, spaceButton, doneButton1]
        //pickerToolBar?.items = [cancelButton1, spaceButton, doneButton1]
        textField.inputAccessoryView = toolBar
    }

    
    @objc func donePickerView(){
        tf_selectEmail.resignFirstResponder()
    }
    
    @objc func cancelPickerView(){
        tf_selectEmail.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,numberOfRowsInComponent component: Int) -> Int {
        
        if pickerCheckValue == 1 {
            return emailList.count
        } else {
            return 0
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerCheckValue == 1 {
            return emailList[row]
        } else {
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerCheckValue == 1 {
            self.emptyEmails.append(emailList[row])
            self.sendingEmailEm.append(emailEmArr[row])
            self.sendingEmailOrder.append(emailOrderArr[row])
            emailTableview.reloadData()
        } else {
           print("item couldnt pick")
        }
    }
    
    
}
