//
//  LaunchVC.swift
//  SmartSecureApp
//
//  Created by Vineet Sharma on 08/02/23.
//

import UIKit

class LaunchVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if (UserDefaults.standard.value(forKey: "autoLogin") != nil) == true {
            let loginVC = self.storyboard?.instantiateViewController(identifier: "TabsVC") as? TabsVC
            self.navigationController?.pushViewController(loginVC!, animated: true)
        } else {
            let loginVC = self.storyboard?.instantiateViewController(identifier: "SignInViewController") as? SignInViewController
            self.navigationController?.pushViewController(loginVC!, animated: true)
        }
        self.navigationController?.navigationBar.isHidden = true
    }
}
