//
//  LocationUpdateVC.swift
//  SmartSecureApp
//
//  Created by Ranadheer on 02/01/2023.
//

import UIKit

class LocationUpdateVC: UIViewController {

    @IBOutlet weak var locationUpdateTable: UITableView!
    
    var nameArr = [String]()
    var emailArr = [String]()
    var phoneArr = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        locationUpdateTable.dataSource = self
        locationUpdateTable.register(UINib(nibName: "locationUpdateTVCell", bundle: nil), forCellReuseIdentifier: "locationUpdateTVCell")
        locationUpdateTable.reloadData()
        getSMSApiCall()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Save sms API Call
    func getSMSApiCall(){
        guard let id = UserDefaults.standard.value(forKey: "userid") as? String else { return }
        LoadingUtils.shared.showActivityIndicator(uiView: self.view)
        callContactAPIClient.shared.callContactApiIntegration(userid:id,funct: "get_sms_contacts") { success, error in
            if success {
                self.nameArr.removeAll()
                self.emailArr.removeAll()
                self.phoneArr.removeAll()
                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                let msg = getCallContactsList.getCallContactResponse["msg"] as? String
                let err = getCallContactsList.getCallContactResponse["error"] as? String
                if msg == "success" {
                    let data = getCallContactsList.getCallContactResponse["contacts"] as? [[String:Any]]
                    for i in data! {
                        if let nme = i["name"] as? String {
                            self.nameArr.append(nme)
                        }
                        
                        if let email = i["emails"] as? String {
                            self.emailArr.append(email)
                        }
                        
                        if let phone = i["phone"] as? String {
                            self.phoneArr.append(phone)
                        }
                        
                        if let order = i["order"] as? String {
                            self.phoneArr.append(order)
                        }
                    }
                    self.locationUpdateTable.reloadData()
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

extension LocationUpdateVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = locationUpdateTable.dequeueReusableCell(withIdentifier: "locationUpdateTVCell", for: indexPath) as! locationUpdateTVCell
        
        cell.lbl_lat.text = nameArr[indexPath.row]
        cell.lbl_long.text = emailArr[indexPath.row]
        cell.lbl_address.text = phoneArr[indexPath.row]
        return cell
    }
}
