//
//  TabsVC.swift
//  SmartSecureApp
//
//  Created by Ranadheer on 22/12/2022.
//

import UIKit
import NotificationCenter

class TabsVC: UITabBarController {
    
    var fromNotification = false
    override func viewDidLoad() {
        super.viewDidLoad()
//        let layer = CAShapeLayer()
//        layer.path = UIBezierPath(roundedRect: CGRect(x: 15, y: tabBar.bounds.minY + -4, width: tabBar.bounds.width - 30, height: tabBar.bounds.height + 10), cornerRadius: 10).cgPath
//        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
//        layer.shadowRadius = 15.0
//        layer.shadowOpacity = 20.0
//        layer.borderWidth = 1.0
//        layer.opacity = 20.0
//        layer.isHidden = false
//        layer.masksToBounds = false
//        layer.fillColor = UIColor.white.cgColor
//        layer.backgroundColor = UIColor(red: 144.0/255.0, green: 144.0/255.0, blue: 144.0/255.0, alpha: 0.5).cgColor
//        tabBar.layer.insertSublayer(layer, at: 0)
//        if let items = tabBar.items {
//            items.forEach { item in
//                item.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//            }
//        }
//        tabBar.isTranslucent = true
//        tabBar.backgroundColor = .clear
//        tabBar.itemWidth = 40.0
//        tabBar.itemPositioning = .centered
//        tabBar.tintColor = UIColor.black
        navigationController?.tabBarController?.tabBar.backgroundColor = .clear
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        tabBar.isTranslucent = true
        tabBar.backgroundColor = .black
        tabBar.tintColor = .red
        
        switch item.tag {
        case 1:
            print("Emergency")
            NotificationCenter.default.post(name: NSNotification.Name("Emergency"), object: nil)
            break
        case 2:
            print("Locations")
            NotificationCenter.default.post(name: NSNotification.Name("Locations"), object: nil)
            
            break
        case 3:
            print("Timer")
            NotificationCenter.default.post(name: NSNotification.Name("Timer"), object: nil)
            
            break
        case 4:
            print("Settings")
            NotificationCenter.default.post(name: NSNotification.Name("Settings"), object: nil)
            navigationController?.tabBarController?.tabBar.backgroundColor = .black
            break
        default:
            break
        }
    }
}
