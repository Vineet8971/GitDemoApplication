//
//  UiViewController.swift
//  SmartSecureApp
//
//  Created by Ranadheer on 21/12/2022.
//

import UIKit

extension UIViewController {
    
    class LoadingUtils {
        
        var container: UIView = UIView()
        var loadingView: UIView = UIView()
        //    var imageView: UIImageView = UIImageView()
        var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        
        static let shared = LoadingUtils()
        
        func showActivityIndicator(uiView: UIView) {
            container.frame = uiView.frame
            container.center = uiView.center
            container.backgroundColor = UIColorFromHex(rgbValue: 0xffffff, alpha: 0.3)
            //        container.backgroundColor = UIColor(hexaRGB: "#000000")?.withAlphaComponent(0.5)
            
            
            
            loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
            loadingView.center = uiView.center
            loadingView.backgroundColor = UIColorFromHex(rgbValue: 0x444444, alpha: 0.7)
            loadingView.clipsToBounds = true
            loadingView.layer.cornerRadius = 10
            
            activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
            activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
            activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2);
            
            loadingView.addSubview(activityIndicator)
            container.addSubview(loadingView)
            uiView.addSubview(container)
            activityIndicator.startAnimating()
        }
            
            func hideActivityIndicator(uiView: UIView) {
                activityIndicator.stopAnimating()
                container.removeFromSuperview()
            }
            
            func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
                let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
                let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
                let blue = CGFloat(rgbValue & 0xFF)/256.0
                return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
            }
            
    }
    
    // MARK: - TOAST
    func showToast(message : String) {
        //        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 180, y: self.view.frame.size.height-100, width: 380, height: 35))
        //        toastLabel.backgroundColor = UIColor.black
        //        toastLabel.textColor = UIColor.white
        //        toastLabel.font = .systemFont(ofSize: 12.0)
        //        toastLabel.textAlignment = .center;
        //        toastLabel.text = message
        //        toastLabel.alpha = 1.0
        //        toastLabel.layer.cornerRadius = 10;
        //        toastLabel.clipsToBounds  =  true
        //        self.view.addSubview(toastLabel)
        //        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
        //             toastLabel.alpha = 0.0
        //        }, completion: {(isCompleted) in
        //            toastLabel.removeFromSuperview()
        //        })
        
        let message = message
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        self.present(alert, animated: true)
        let duration: Double = 2
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            alert.dismiss(animated: true)
        }
    }
    
    func isValidPhone(phone: String) -> Bool {
        let phoneRegex = "^[0-9]{10}$|^[0-9]{12}$" //"^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
    }

    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    
}
        
