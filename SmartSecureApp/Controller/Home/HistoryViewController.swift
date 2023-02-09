//
//  HistoryViewController.swift
//  SmartSecureApp
//
//  Created by Ranadheer on 23/12/2022.
//

import UIKit

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var historyTableview: UITableView!
    @IBOutlet weak var lblCountAlert: UILabel!
    
    var namesList = [[String:Any]]()
    
    var userId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userId = "\(UserDefaults.standard.value(forKey: "userid") ?? "")"
        
        historyTableview.dataSource = self
        historyTableview.register(UINib(nibName: "HistoryRecordTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryRecordTableViewCell")
        
        fetchHistoryApi()
        // Do any additional setup after loading the view.
    }
    
    func fetchHistoryApi() {
        LoadingUtils.shared.showActivityIndicator(uiView: self.view)
        HistoryApiClient.shared.fetchHistoryApiIntegration(funct: "fetchHistory", userId: self.userId) { success, error in
            if success {
                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                let msg = HistoryList.HistoryResponse["msg"] as? String
                let err = HistoryList.HistoryResponse["error"] as? String
                if msg == "success" {
                   
                    if let data = HistoryList.HistoryResponse["data"] as? [[String:Any]] {
                        self.namesList = data
                    }
                    
                    DispatchQueue.main.async {
                        self.historyTableview.reloadData()
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
    
    @objc func deleteAudioFile(sender: UIButton){
        let data = namesList[sender.tag]["id"]
        deleteHistoryApi(id: data as! String )
    }
    
    func deleteHistoryApi(id:String) {
        LoadingUtils.shared.showActivityIndicator(uiView: self.view)
        HistoryApiClient.shared.deleteHistoryApiIntegration(funct: "deleteHistory", id: id) { success, error in
            if success {
                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                let msg = HistoryList.HistoryResponse["msg"] as? String
                let err = HistoryList.HistoryResponse["error"] as? String
                if msg == "success" {
            
                    DispatchQueue.main.async {
                        self.fetchHistoryApi()
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
    
}

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if namesList.count == 0 {
            self.lblCountAlert.isHidden = false
        } else {
            self.lblCountAlert.isHidden = true
            return namesList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyTableview.dequeueReusableCell(withIdentifier: "HistoryRecordTableViewCell", for: indexPath) as! HistoryRecordTableViewCell
        
        cell.btnOption.isHidden = true
        cell.trailingConstraint.constant = -20
        cell.cell_view.backgroundColor = .clear
        cell.cell_view.layer.borderColor = UIColor.gray.cgColor
        cell.cell_view.layer.borderWidth = 1
        cell.btn_delete.tag = indexPath.row
        cell.btn_delete.addTarget(self, action: #selector(deleteAudioFile), for: .touchUpInside)
        
        let audioFullName: String = "\(namesList[indexPath.row]["audio"] ?? "")"
        let audioFirstArr = audioFullName.components(separatedBy: "uploads/")
        
        let audioLastArr = audioFirstArr[1].components(separatedBy: ".m4a")
        
        cell.lbl_audioFiles.text = "\(audioLastArr[0])"
        
        return cell
    }
}
