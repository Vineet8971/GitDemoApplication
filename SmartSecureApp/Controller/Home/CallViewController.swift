//
//  CallViewController.swift
//  SmartSecureApp
//
//  Created by Ranadheer on 23/12/2022.
//

import UIKit
import Contacts
import ContactsUI

struct Person {
    var name: String
    var phone: String
}

class CallViewController: UIViewController,UITextFieldDelegate, CNContactPickerDelegate {
    
    @IBOutlet weak var lblCountAlert: UILabel!
    @IBOutlet weak var controllerTitleName: UILabel!
    @IBOutlet weak var contactTableview: UITableView!
    @IBOutlet weak var tf_selectCall: UITextField!
    
    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var manualView: UIView!
    @IBOutlet weak var notManualView: UIView!
    @IBOutlet weak var btnAddPhoneOutlet: UIButton!
    
    // @IBOutlet weak var tf_userid: UITextField!
    @IBOutlet weak var tf_contactNo: UITextField!
    @IBOutlet weak var tf_name: UITextField!
    @IBOutlet weak var btnAddContact: UIButton!
    @IBOutlet weak var optionView: UIView!
    @IBOutlet weak var btnPrimary: UIButton!
    @IBOutlet weak var btnSecondary: UIButton!
    
    var models = [Person]()
    var contactPhone = [String]()
    
    var selectedArr = [String]()
    var selectedPhoneArr = [String]()
    var selectedOrdeArr = [String]()

    var contactList = [String]()
    
    var pickerView : UIPickerView?
    var pickerCheckValue: Int!
    var getUserId = Int()
    var getOrder = [String]()
    var orderCreatedAt = String()
    var category = String()
    
    var phones = String()
    var name = String()
    var list = String()
    var order = String()
    var primary = String()
    var secondary = String()
    var index = Int()
    var isComingFrom = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isComingFrom == "SMS" {
            self.getSMSApiCall()
            self.controllerTitleName.text = "SMS"
            self.btnAddContact.setTitle("Add Contacts", for: .normal)
        } else if isComingFrom == "EMAIL" {
            self.getEmailApiCall()
            self.controllerTitleName.text = "EMAIL"
            self.btnAddContact.setTitle("Add Email", for: .normal)
        } else if isComingFrom == "WHATSAPP" {
            self.getWhatsappApiCall()
            self.controllerTitleName.text = "WHATSAPP"
            self.btnAddContact.setTitle("Add Contacts", for: .normal)
        } else {
            self.controllerTitleName.text = "CALL"
            self.btnAddContact.setTitle("Add Contacts", for: .normal)
            getCallContactApiCall()
        }
        
        self.optionView.layer.cornerRadius = 10
        self.optionView.clipsToBounds = true
        self.btnPrimary.layer.cornerRadius = 15
        self.btnSecondary.layer.cornerRadius = 15
        dropDownView.isHidden = true
        manualView.isHidden = true
        contactTableview.delegate = self
        contactTableview.dataSource = self
        contactTableview.register(UINib(nibName: "HistoryRecordTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryRecordTableViewCell")
        contactTableview.reloadData()
        
        tf_name.attributedPlaceholder = NSAttributedString(string: " Name",attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemRed])
        tf_contactNo.attributedPlaceholder = NSAttributedString(string: " Contact",attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemRed])
        
        tf_selectCall.delegate = self
        tf_selectCall.layer.borderColor = UIColor.white.cgColor
        tf_selectCall.layer.borderWidth = 1
        
        dropDownView.layer.borderColor = UIColor.white.cgColor
        dropDownView.layer.borderWidth = 1
        
        tf_name.layer.borderColor = UIColor.white.cgColor
        tf_name.layer.borderWidth = 1
        tf_contactNo.layer.borderColor = UIColor.white.cgColor
        tf_contactNo.layer.borderWidth = 1
        
        tf_selectCall.attributedPlaceholder = NSAttributedString(string: "Select Contact",attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        tf_name.addPadding(.left(10))
        tf_contactNo.addPadding(.left(10))
        
        // guard let id = UserDefaults.standard.value(forKey: "userID") as? String else {return }
        //tf_userid.text = id
        // Do any additional setup after loading the view.
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapBlurButton(sender:)))
        self.view.addGestureRecognizer(tapGesture)
        
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
    
    
    
    @objc func tapBlurButton(sender: UITapGestureRecognizer) {
        self.optionView.isHidden = true
       }
    
    
    //MARK:- Save Contact API Call
    func getCallContactApiCall(){
        guard let id = UserDefaults.standard.value(forKey: "userid") as? String else { return }
        
        LoadingUtils.shared.showActivityIndicator(uiView: self.view)
        callContactAPIClient.shared.callContactApiIntegration(userid:id,funct: "get_call_contacts") { success, error in
            if success {
                self.primary.removeAll()
                self.secondary.removeAll()
                self.models.removeAll()
                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                let msg = getCallContactsList.getCallContactResponse["msg"] as? String
                let err = getCallContactsList.getCallContactResponse["error"] as? String
                if msg == "success" {
                    let data = getCallContactsList.getCallContactResponse["contacts"] as? [[String:Any]]
                    for i in data! {
                        if let contList = i["name"] as? String {
                            if let phones = i["phone"] as? String {
                                if !contList.isEmpty && !phones.isEmpty{
                            let newPerson = Person.init(name: contList, phone: phones)
                                self.models.append(newPerson)
                            }
                            }
                        }
                        if let primaryNumber = i["primary"] {
                            if primaryNumber as? String ?? "" == "1" {
                                self.primary = i["phone"] as? String ?? ""
                            }
                        }
                        if let secondaryNumber = i["secondary"] {
                            if secondaryNumber as? String ?? "" == "1" {
                                self.secondary = i["phone"] as? String ?? ""
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.contactTableview.reloadData()
                    }
                } else{
                    
                  //  AlertHelper.shared.toShowAlert(title: "Alert", message: msg ?? "", viewController: self)
                  //  self.showToast(message: err ?? "")
                }
            } else if let error = error {
                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                print("error.localizedDescription\(error.localizedDescription)")
            }
        }
    }

    
    //MARK:- Send Contacts APICAll
    
    func sendCallContactApiCall(){
        
        guard let id = UserDefaults.standard.value(forKey: "userid") as? String else { return }
        
        let model = models
        
        for i in (0 ..< model.count){
            if !model[i].name.isEmpty{
            self.name.append(model[i].name)
            if i < model.count{
            self.name.append(",")
            }
            }
        }
        for i in (0 ..< model.count){
            if !model[i].phone.isEmpty{
            self.phones.append(model[i].phone)
            if i < model.count{
            self.phones.append(",")
            }
            }
        }
        
        for i in (0 ..< model.count){
            if !model[i].name.isEmpty{
            order.append(String(i))
            if i < model.count{
            order.append(",")
            }
            }
        }
        
        let convert = Int(id) ?? 0

        LoadingUtils.shared.showActivityIndicator(uiView: self.view)
        sendCallContactAPIClient.shared.sendCallContactApiIntegration(funct: "call_contacts", userId: convert, created: "", contactNames: self.name, contactPhones: self.phones, contactOrder: order,primary: primary,secondary: secondary) { success, error in
            if success {
                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                let msg = sentCallContactsList.sendCallContactResponse["msg"] as? String
                let err = sentCallContactsList.sendCallContactResponse["error"] as? String
                if msg == "success" {
                    self.navigationController?.popViewController(animated: true)
//                    let nVC = self.storyboard?.instantiateViewController(identifier: "SettingsViewController") as? SettingsViewController
//                    self.navigationController?.pushViewController(nVC!, animated: true)
                    
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
    
    //MARK:- Save sms API Call
    func getSMSApiCall(){
        guard let id = UserDefaults.standard.value(forKey: "userid") as? String else { return }
        LoadingUtils.shared.showActivityIndicator(uiView: self.view)
        getSMSAPIClient.shared.getSMSApiIntegration(userid:id,funct: "get_sms_contacts") { success, error in
            if success {
                self.models.removeAll()
                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                let msg = getSMSList.getSMSResponse["msg"] as? String
                let err = getSMSList.getSMSResponse["error"] as? String
                if msg == "success" {
                    let data = getSMSList.getSMSResponse["contacts"] as? [[String:Any]]
                    for i in data! {
                        if let contList = i["name"] as? String {
                            if let phones = i["phone"] as? String {
                                if !contList.isEmpty && !phones.isEmpty{
                            let newPerson = Person.init(name: contList, phone: phones)
                                self.models.append(newPerson)
                            }
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.contactTableview.reloadData()
                    }
                } else{
                  //  AlertHelper.shared.toShowAlert(title: "", message: msg ?? "", viewController: self)
                  //  self.showToast(message: err ?? "")
                }
            } else if let error = error {
                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                print("error.localizedDescription\(error.localizedDescription)")
            }
        }
    }
    
    func sendSMSApiCall(){
        guard let id = UserDefaults.standard.value(forKey: "userid") as? String else { return }
        
        let model = models
        
        for i in (0 ..< model.count){
            if !model[i].name.isEmpty{
            self.name.append(model[i].name)
            if i < model.count{
            self.name.append(",")
            }
            }
        }
        for i in (0 ..< model.count){
            if !model[i].phone.isEmpty{
            self.phones.append(model[i].phone)
            if i < model.count{
            self.phones.append(",")
            }
            }
        }
        
        for i in (0 ..< model.count){
            if !model[i].name.isEmpty{
            order.append(String(i))
            if i < model.count{
            order.append(",")
            }
            }
        }
        
        let convert = Int(id) ?? 0
         
        LoadingUtils.shared.showActivityIndicator(uiView: self.view)
        sendSMSAPIClient.shared.sendSMSAPIClientApiIntegration(funct: "sms_contacts", userId: convert, created: "", contactNames: self.name, contactSMS: self.phones, contactOrder: order) { success, error in
            if success {
                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                let msg = sendSMSList.sendSMSResponse["msg"] as? String
                let err = sendSMSList.sendSMSResponse["error"] as? String
                if msg == "success" {
                    self.isComingFrom = ""
                    self.navigationController?.popViewController(animated: true)
//                    let nVC = self.storyboard?.instantiateViewController(identifier: "SettingsViewController") as? SettingsViewController
//                    self.navigationController?.pushViewController(nVC!, animated: true)
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

    //MARK:- Save Email API Call
    func getEmailApiCall(){
        guard let id = UserDefaults.standard.value(forKey: "userid") as? String else { return }
        LoadingUtils.shared.showActivityIndicator(uiView: self.view)
        getEmailAPIClient.shared.getEmailApiIntegration(userid: id, funct: "get_email_contacts") { success, error in
            if success {
                self.models.removeAll()
                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                let msg = getEmailList.getEmailResponse["msg"] as? String
                let err = getEmailList.getEmailResponse["error"] as? String
                if msg == "success" {
                    let data = getEmailList.getEmailResponse["contacts"] as? [[String:Any]]
                    for i in data! {
                        if let contList = i["name"] as? String {
                            if let phones = i["email"] as? String {
                                if !contList.isEmpty && !phones.isEmpty{
                            let newPerson = Person.init(name: contList, phone: phones)
                                self.models.append(newPerson)
                            }
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.contactTableview.reloadData()
                    }
                } else{
                    
                  //  AlertHelper.shared.toShowAlert(title: "", message: msg ?? "", viewController: self)
                    
                //    self.showToast(message: err ?? "")
                }
            } else if let error = error {
                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                print("error.localizedDescription\(error.localizedDescription)")
            }
        }
    }
    
    func sendEmailApiCall(){
        guard let id = UserDefaults.standard.value(forKey: "userid") as? String else { return }
        
        let model = models
        
        for i in (0 ..< model.count){
            if !model[i].name.isEmpty{
            self.name.append(model[i].name)
            if i < model.count{
            self.name.append(",")
            }
            }
        }
        for i in (0 ..< model.count){
            if !model[i].phone.isEmpty{
            self.phones.append(model[i].phone)
            if i < model.count{
            self.phones.append(",")
            }
            }
        }
        
        for i in (0 ..< model.count){
            if !model[i].name.isEmpty{
            order.append(String(i))
            if i < model.count{
            order.append(",")
            }
            }
        }
        
        let convert = Int(id) ?? 0
         
        LoadingUtils.shared.showActivityIndicator(uiView: self.view)
        sendEmailAPIClient.shared.sendEmailAPIClientApiIntegration(funct: "email_contacts", userId: convert, created: "", contactNames: self.name, contactEmail: self.phones, contactOrder: order) { success, error in
            if success {
                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                let msg = sendEmailList.sendEmailResponse["msg"] as? String
                let err = sendEmailList.sendEmailResponse["error"] as? String
                if msg == "success" {
                    self.isComingFrom = ""
                    self.navigationController?.popViewController(animated: true)
//                    let nVC = self.storyboard?.instantiateViewController(identifier: "SettingsViewController") as? SettingsViewController
//                    self.navigationController?.pushViewController(nVC!, animated: true)
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
    
    //MARK:- Save Whatsapp API Call
    func getWhatsappApiCall() {
        guard let id = UserDefaults.standard.value(forKey: "userid") as? String else { return }
        LoadingUtils.shared.showActivityIndicator(uiView: self.view)
        WhatsappApiClient.shared.getWhatsappApiIntegration(userid:id,funct: "get_whatsapp_contacts") { success, error in
            if success {
                self.models.removeAll()
                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                let msg = getWhatsappList.getWhatsappResponse["msg"] as? String
                let err = getWhatsappList.getWhatsappResponse["error"] as? String
                if msg == "success" {
                    let data = getWhatsappList.getWhatsappResponse["contacts"] as? [[String:Any]]
                    for i in data! {
                        if let contList = i["name"] as? String {
                            if let phones = i["phone"] as? String {
                                if !contList.isEmpty && !phones.isEmpty{
                            let newPerson = Person.init(name: contList, phone: phones)
                                self.models.append(newPerson)
                            }
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.contactTableview.reloadData()
                    }
                } else{
                    
                   // AlertHelper.shared.toShowAlert(title: "", message: msg ?? "", viewController: self)
                    
                   // self.showToast(message: err ?? "")
                }
            } else if let error = error {
                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                print("error.localizedDescription\(error.localizedDescription)")
            }
        }
    }
    
    func sendWhatsappApiCall() {
        guard let id = UserDefaults.standard.value(forKey: "userid") as? String else { return }
        
        let model = models
        
        for i in (0 ..< model.count){
            if !model[i].name.isEmpty{
            self.name.append(model[i].name)
            if i < model.count{
            self.name.append(",")
            }
            }
        }
        for i in (0 ..< model.count){
            if !model[i].phone.isEmpty{
            self.phones.append(model[i].phone)
            if i < model.count{
            self.phones.append(",")
            }
            }
        }
        
        for i in (0 ..< model.count){
            if !model[i].name.isEmpty{
            order.append(String(i))
            if i < model.count{
            order.append(",")
            }
            }
        }
        
        let convert = Int(id) ?? 0
         
        LoadingUtils.shared.showActivityIndicator(uiView: self.view)
        SendWhatsappApiClient.shared.sendWhatsappAPIClientApiIntegration(funct: "whatsapp_contacts", userId: convert, created: "", contactNames: self.name, contactSMS: self.phones, contactOrder: order) { success, error in
            if success {
                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                let msg = sendWhatsappList.sendWhatsappResponse["msg"] as? String
                let err = sendWhatsappList.sendWhatsappResponse["error"] as? String
                if msg == "success" {
                    self.isComingFrom = ""
                    self.navigationController?.popViewController(animated: true)
//                    let nVC = self.storyboard?.instantiateViewController(identifier: "SettingsViewController") as? SettingsViewController
//                    self.navigationController?.pushViewController(nVC!, animated: true)
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
    
    
    func fetchSpecificContacts() async {
        let store = CNContactStore()
        let keys = [CNContactGivenNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
        let predicate = CNContact.predicateForContacts(matchingName: "Kate")
        
        do {
           let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keys)
        }
        catch {
            
        }
    }
    
//    func fetchData() async {
//        let store = CNContactStore()
//        let keys = [CNContactGivenNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
//        let fetchRequest = CNContactFetchRequest(keysToFetch: keys)
//        do {
//            try store.enumerateContacts(with: fetchRequest , usingBlock: { contact, result in
//                print(contact.givenName)
//                for number in contact.phoneNumbers {
//
//                    switch number.label {
//                    case CNLabelPhoneNumberMobile:
//                        print("_mobile:\(number.value.stringValue)")
//                       // self.phones = number.value.stringValue
//                    default :
//                        print("_main:\(number.value.stringValue)")
//                    }
//                }
//            })
//        }catch {
//
//        }
//    }
    
    func didTapAdd(){
        let vc = CNContactPickerViewController()
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        Task.init {
        //  await fetchData()
        }
        let name = contact.givenName + " " + contact.familyName
        let userPhoneNumbers:[CNLabeledValue<CNPhoneNumber>] = contact.phoneNumbers
        if userPhoneNumbers.isEmpty{
            dismiss(animated: true)
            AlertHelper.shared.toShowAlert(title: "Alert", message: "No number associated. Cannot add this contact.", viewController: self)
            return
        } else {
        let firstPhoneNumber:CNPhoneNumber = userPhoneNumbers[0].value
        // user phone number string
        let primaryPhoneNumberStr:String = firstPhoneNumber.stringValue
        var model = Person(name: name, phone: primaryPhoneNumberStr)
        models.append(model)
        contactTableview.reloadData()
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        if self.btnAddContact.title(for: .normal) == "Done" {
            
            if isComingFrom == "EMAIL" {
                self.btnAddContact.setTitle("Add Email", for: .normal)
            } else {
                self.btnAddContact.setTitle("Add Contacts", for: .normal)
            }
            dropDownView.isHidden = true
            manualView.isHidden = true
            notManualView.isHidden = false
            self.tf_name.text = ""
            self.tf_contactNo.text = ""
            self.contactTableview.reloadData()
        } else {
        self.isComingFrom = ""
        self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func addContactTapped(_ sender: Any) {
        
        if self.btnAddContact.title(for: .normal) == "Done" {
            
            if isComingFrom == "EMAIL" {
                if tf_name.text != "" && tf_contactNo.text != "" {
                
                    if tf_name.text != "" {
                        if isValidEmail(email: tf_contactNo.text!) && tf_contactNo.text != "" {
                            
                            self.btnAddContact.setTitle("Add Email", for: .normal)
                            dropDownView.isHidden = true
                            manualView.isHidden = true
                            notManualView.isHidden = false
                            let model = Person(name: self.tf_name.text ?? "", phone: self.tf_contactNo.text ?? "")
                            models.append(model)
                            self.tf_name.text = ""
                            self.tf_contactNo.text = ""
                            self.contactTableview.reloadData()
                        } else {
                            
                            AlertHelper.shared.toShowAlert(title: "Alert", message: "Please Enter valid Email", viewController: self)
                            
                           // showToast(message: "Please Enter valid Email")
                       }
                    }else {
                        
                        AlertHelper.shared.toShowAlert(title: "Alert", message: "Please Enter Name", viewController: self)
                      //  showToast(message: "Please Enter Name")
                    }
                } else {
                    
                    AlertHelper.shared.toShowAlert(title: "Alert", message: "All fields are required", viewController: self)
                  //  showToast(message: "All fields are required")
                }
            } else {
                
                if tf_name.text != "" && tf_contactNo.text != "" {
                    if tf_contactNo.text!.count < 10 {
                        AlertHelper.shared.toShowAlert(title: "Alert", message: "Phone number is less than 10 numbers", viewController: self)
                        // showToast(message: "Phone number is less than 10 numbers")
                    } else {
                        self.isValidPhone(phone: tf_contactNo.text!)
                        self.btnAddContact.setTitle("Add Contacts", for: .normal)
                        dropDownView.isHidden = true
                        manualView.isHidden = true
                        notManualView.isHidden = false
                        let model = Person(name: self.tf_name.text ?? "", phone: self.tf_contactNo.text ?? "")
                        models.append(model)
                        self.tf_name.text = ""
                        self.tf_contactNo.text = ""
                        self.contactTableview.reloadData()
                    }
                }else {
                    
                    AlertHelper.shared.toShowAlert(title: "Alert", message: "All fields are required", viewController: self)
                 //   showToast(message: "All fields are required")
                }
            }
        } else {
            if isComingFrom == "SMS" {
                self.sendSMSApiCall()
            } else if isComingFrom == "EMAIL" {
                self.sendEmailApiCall()
            } else {
                sendCallContactApiCall()
            }
        }
    }
    
    @objc func deletingContact(sender: UIButton){
        let data = sender.tag
        self.models.remove(at: data)
        self.contactTableview.reloadData()
    }
    
    @objc func optionSelect(sender: UIButton) {
        index = sender.tag
        self.optionView.isHidden = false
        if models.count == 1{
            self.btnPrimary.isHidden = true
        }else{
        if primary == models[index].phone{
            self.btnPrimary.isHidden = true
            self.btnSecondary.isHidden = false
        }else if secondary == models[index].phone{
            self.btnSecondary.isHidden = true
            self.btnPrimary.isHidden = false
        }else{
            self.btnPrimary.isHidden = false
            self.btnSecondary.isHidden = false
        }
        }
    }
    
    @IBAction func plusBtnTapped(_ sender: Any) {
        
        dropDownView.isHidden = !dropDownView.isHidden
        
        if isComingFrom == "EMAIL" {
            self.btnAddPhoneOutlet.isHidden = true
        } else {
            self.btnAddPhoneOutlet.isHidden = false
        }
    }
    
    @IBAction func pickingBtnTapped(_ sender: Any) {
        category = "saved list"
        manualView.isHidden = true
        notManualView.isHidden = false
        dropDownView.isHidden = true
    }
    
    @IBAction func manualPickingTapped(_ sender: Any) {
        
        if isComingFrom == "EMAIL" {
            btnAddPhoneOutlet.isHidden = true
            tf_contactNo.attributedPlaceholder = NSAttributedString(string: " Email",attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemRed])
        } else {
            btnAddPhoneOutlet.isHidden = false
            tf_contactNo.attributedPlaceholder = NSAttributedString(string: " Contact",attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemRed])
        }
        
        manualView.isHidden = false
        notManualView.isHidden = true
        dropDownView.isHidden = true
        self.btnAddContact.setTitle("Done", for: .normal)
    
    }
    
    
    @IBAction func addPhoneTapped(_ sender: Any) {
        didTapAdd()
        dropDownView.isHidden = true
    }
    
    
    @IBAction func phoneTapped(_ sender: Any) {
        
    }
    
    @IBAction func btnPrimaryAction(_ sender: UIButton) {
        self.optionView.isHidden = true
        primary = models[index].phone
        
        if primary == secondary {
            secondary = ""
        }
        
        self.contactTableview.reloadData()
    }
    @IBAction func btnSecondaryAction(_ sender: UIButton) {
        self.optionView.isHidden = true
        secondary = models[index].phone
        if primary == secondary {
            primary = ""
        }
        self.contactTableview.reloadData()
    }
    
}

extension CallViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if models.count == 0 {
            self.lblCountAlert.isHidden = false
            if isComingFrom == "EMAIL" {
                self.lblCountAlert.text = "No Email Found"
            } else {
                self.lblCountAlert.text = "No Contacts Found"
            }
        } else {
            self.lblCountAlert.isHidden = true
            return models.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = contactTableview.dequeueReusableCell(withIdentifier: "HistoryRecordTableViewCell", for: indexPath) as! HistoryRecordTableViewCell
        cell.cell_view.layer.borderColor = UIColor.white.cgColor
        cell.cell_view.layer.borderWidth = 1
            let data = models[indexPath.row]
        
        cell.btnOption.tag = indexPath.row
        cell.btnOption.addTarget(self, action: #selector(optionSelect), for: .touchUpInside)
        cell.btn_delete.tag = indexPath.row
        cell.btn_delete.addTarget(self, action: #selector(deletingContact), for: .touchUpInside)
        
        cell.lbl_audioFiles.text = data.name
        
        if isComingFrom == "SMS" || isComingFrom == "EMAIL" || isComingFrom == "WHATSAPP" {
            cell.btnOption.isHidden = true
            cell.trailingConstraint.constant = -20
        } else {
        
            cell.btnOption.isHidden = false
            cell.trailingConstraint.constant = 10
            if models.count == 1{
                primary = data.phone
            }
            if  data.phone == primary {
            cell.lbl_audioFiles.text = "\(data.name + "-" + "Primary")"
        }
        if data.phone == secondary {
            cell.lbl_audioFiles.text = "\(data.name + "-" + "Secondary")"
        }
           // self.list = data.name
//            if let phone = data.phone as? CNPhoneNumber {
//                print(phone.stringValue)
//            } else {
//               print("number.value not of type CNPhoneNumber")
//            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

