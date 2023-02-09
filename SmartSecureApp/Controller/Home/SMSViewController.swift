//
//  SMSViewController.swift
//  SmartSecureApp
//
//  Created by Ranadheer on 23/12/2022.
//

import UIKit

class SMSViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tf_selectSMS: UITextField!
    @IBOutlet weak var switch_toggle: UISwitch!
    @IBOutlet weak var smsTableview: UITableView!
    
    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var manualView: UIView!
    @IBOutlet weak var notManualView: UIView!
    @IBOutlet weak var tf_contactNo: UITextField!
    @IBOutlet weak var tf_name: UITextField!
    
    var category = String()
    var smsArr = [String]()
    
    var smsList = [String]()
    var smsSms = [String]()
    var smsOrder = [String]()
    var pickerView : UIPickerView?
    var pickerCheckValue: Int!
    
    var sendingmSName = [String]()
    var sendingSmsNo = [String]()
    var sendingSmsOrder = [String]()
    
    var names = String()
    var sms = String()
    var order = String()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dropDownView.isHidden = true
        manualView.isHidden = true
        smsTableview.delegate = self
        smsTableview.dataSource = self
        smsTableview.register(UINib(nibName: "HistoryRecordTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryRecordTableViewCell")
        smsTableview.reloadData()
        
        tf_name.attributedPlaceholder = NSAttributedString(string: " Name",attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemRed])
        tf_contactNo.attributedPlaceholder = NSAttributedString(string: " Contact",attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemRed])
        
        tf_selectSMS.delegate = self
        tf_selectSMS.attributedPlaceholder = NSAttributedString(string: "Select SMS Number",attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        switch_toggle.addTarget(self, action: #selector(switchIsChanged), for: UIControl.Event.valueChanged)
        
        tf_selectSMS.layer.borderColor = UIColor.gray.cgColor
        tf_selectSMS.layer.borderWidth = 1
        
        tf_name.layer.borderColor = UIColor.gray.cgColor
        tf_name.layer.borderWidth = 1
        tf_contactNo.layer.borderColor = UIColor.gray.cgColor
        tf_contactNo.layer.borderWidth = 1
        
        dropDownView.layer.borderColor = UIColor.gray.cgColor
        dropDownView.layer.borderWidth = 1
        category = "saved list"
        getSMSApiCall()
        // Do any additional setup after loading the view.
    }
    
    @objc func switchIsChanged(mySwitch: UISwitch) {
        if switch_toggle.isOn {
            self.tf_selectSMS.isHidden = false
            smsTableview.isHidden = false
        } else {
            tf_selectSMS.isHidden = true
            smsTableview.isHidden = true
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func plusBtnTapped(_ sender: Any) {
        dropDownView.isHidden = false
    }
    
    @IBAction func pickingBtnTapped(_ sender: Any) {
        category = "saved list"
        manualView.isHidden = true
        notManualView.isHidden = false
        dropDownView.isHidden = true
    }
    
    @IBAction func manualPickingTapped(_ sender: Any) {
        category = "manual"
        manualView.isHidden = false
        notManualView.isHidden = true
        dropDownView.isHidden = true
    }
    
    
    @objc func deletingContact(sender: UIButton){
        let data = sender.tag
        if category == "saved list" {
            print("data removedid:\(data)")
            self.smsArr.remove(at: data)
        }else if category == "manual" {
//            print("data removedid:\(data)")
//            self.models.remove(at: data)
        }
        self.smsTableview.reloadData()
    }
    
    @IBAction func addingSmsTapped(_ sender: Any) {
        if tf_selectSMS.text != "Select SMS number" {
            sendSMSApiCall()
        } else {
            
            AlertHelper.shared.toShowAlert(title: "Alert", message: "Please select an item", viewController: self)
            
           // self.showToast(message: "Please select an item")
        }
    }
    
    @IBAction func phoneTapped(_ sender: Any) {
        if tf_contactNo.text!.count < 10 {
            
            AlertHelper.shared.toShowAlert(title: "Alert", message: "Phone number is less than 10 numbers", viewController: self)
            //showToast(message: "Phone number is less than 10 numbers")
        } else {
            self.isValidPhone(phone: tf_contactNo.text!)
        }
    }
    
    
    //MARK:- Save sms API Call
    func getSMSApiCall(){
        guard let id = UserDefaults.standard.value(forKey: "userid") as? String else { return }
        LoadingUtils.shared.showActivityIndicator(uiView: self.view)
        callContactAPIClient.shared.callContactApiIntegration(userid:id,funct: "get_sms_contacts") { success, error in
            if success {
                self.smsList.removeAll()
                self.smsSms.removeAll()
                self.smsOrder.removeAll()
                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                let msg = getCallContactsList.getCallContactResponse["msg"] as? String
                let err = getCallContactsList.getCallContactResponse["error"] as? String
                if msg == "success" {
                    let data = getCallContactsList.getCallContactResponse["contacts"] as? [[String:Any]]
                    for i in data! {
                        if let nme = i["name"] as? String {
                            self.smsList.append(nme)
                        }
                        
                        if let no = i["sms"] as? String {
                            self.smsSms.append(no)
                        }
                        
                        if let order = i["order"] as? String {
                            self.smsOrder.append(order)
                        }
                    }
                    self.smsTableview.reloadData()
                } else{
                    AlertHelper.shared.toShowAlert(title: "Alert", message: msg ?? "", viewController: self)
                }
            } else if let error = error {
                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                print("error.localizedDescription\(error.localizedDescription)")
            }
        }
    }
    
    func sendSMSApiCall(){
        guard let id = UserDefaults.standard.value(forKey: "userid") as? String else { return }
        let convert = Int(id) ?? 0
        if category == "saved list" {
            sms = sendingSmsNo.joined(separator: ",")
            names = smsArr.joined(separator: ",")
            order = sendingSmsOrder.joined(separator: ",")
        } else {
            sms = tf_contactNo.text ?? ""
            names = tf_name.text ?? ""
            let randomInt = Int.random(in: 0..<10)
            order = String(randomInt)
        }
         
        LoadingUtils.shared.showActivityIndicator(uiView: self.view)
        sendSMSAPIClient.shared.sendSMSAPIClientApiIntegration(funct: "sms_contacts", userId: convert, created: "", contactNames: names, contactSMS: sms, contactOrder: order) { success, error in
            if success {
                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                let msg = sendSMSList.sendSMSResponse["msg"] as? String
                let err = sendSMSList.sendSMSResponse["error"] as? String
                if msg == "success" {
                    let nVC = self.storyboard?.instantiateViewController(identifier: "SettingsViewController") as? SettingsViewController
                    self.navigationController?.pushViewController(nVC!, animated: true)
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

extension SMSViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if category == "saved list" {
            return smsArr.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = smsTableview.dequeueReusableCell(withIdentifier: "HistoryRecordTableViewCell", for: indexPath) as! HistoryRecordTableViewCell
        
        
        cell.cell_view.layer.borderColor = UIColor.gray.cgColor
        cell.cell_view.layer.borderWidth = 1
        
        if category == "saved list" {
            cell.lbl_audioFiles.text = smsArr[indexPath.row]
            cell.btn_delete.tag = indexPath.row
            cell.btn_delete.addTarget(self, action: #selector(deletingContact), for: .touchUpInside)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}

extension SMSViewController: UIPickerViewDelegate,UIPickerViewDataSource {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

        if textField == tf_selectSMS {
            pickerCheckValue = 1
            pickUp(tf_selectSMS)
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
        tf_selectSMS.resignFirstResponder()
    }
    
    @objc func cancelPickerView(){
        tf_selectSMS.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,numberOfRowsInComponent component: Int) -> Int {
        
        if pickerCheckValue == 1 {
            return smsList.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerCheckValue == 1 {
            return smsList[row]
        } else {
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerCheckValue == 1 {
            self.smsArr.append(smsList[row])
            self.sendingSmsNo.append(smsSms[row])
            self.sendingSmsOrder.append(smsOrder[row])
            smsTableview.reloadData()
        } else {
           print("item couldnt pick")
        }
    }
    
    
}
