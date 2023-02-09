//
//  PopUpViewController.swift
//  SmartSecureApp
//
//  Created by Ranadheer on 26/12/2022.
//

import UIKit
protocol dataPass {
    func timerRequirement(timerStop:String)
}

class PopUpViewController: UIViewController {

    @IBOutlet weak var view_content: UIView!
    @IBOutlet weak var tf_password: UITextField!
    var delegate: dataPass!
    var endTimer = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnConfirmTapped(_ sender: Any) {
        if tf_password.text != "" {
            
            if tf_password.text == "\(UserDefaults.standard.value(forKey: "userPassword") ?? "")" {
                delegate.timerRequirement(timerStop: "00:00")
                self.dismiss(animated: true)
            } else {
                
                AlertHelper.shared.toShowAlert(title: "Alert", message: "password did not match", viewController: self)
              //  self.showToast(message: "password did not match")
            }
        } else {
            
            AlertHelper.shared.toShowAlert(title: "Alert", message: "password cant be empty", viewController: self)
          //  self.showToast(message: "password cant be empty")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
