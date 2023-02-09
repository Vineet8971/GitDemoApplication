//
//  TimerViewController.swift
//  SmartSecureApp
//
//  Created by Ranadheer on 22/12/2022.
//

import UIKit



class TimerViewController: UIViewController {
    
    @IBOutlet weak var btnStopTimerOutlet: UIButton!
    @IBOutlet weak var tf_password: UITextField!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var viewTimePicker: UIView!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var percentageLabel: UILabel!
    
    var timeLeft: TimeInterval = 0
    var lastTime: TimeInterval = 0
    var endTime: Date?
    var timer = Timer()
    var userId = String()
    var location = String()
    var userName = String()
    var phoneNumber = String()
    var progressValue : Float = 0
   
    override func viewDidLoad() {
        super.viewDidLoad()
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineAttributedString = NSAttributedString(string: "StringWithUnderLine", attributes: underlineAttribute)
        timeLabel.attributedText = underlineAttributedString
        
        progressView.layer.cornerRadius = 5
        progressView.clipsToBounds = true
        
        userId = "\(UserDefaults.standard.value(forKey: "userid") ?? "")"
        location = "\(UserDefaults.standard.value(forKey: "from_address") ?? "")"
        userName = "\(UserDefaults.standard.value(forKey: "userName") ?? "")"
        
        timeLabel.text = timeLeft.time
        self.viewTimePicker.clipsToBounds = true
        self.viewTimePicker.layer.cornerRadius = 30
        self.viewTimePicker.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        self.timePicker.minimumDate = Date()
        self.timePicker.datePickerMode = .time
        if timeLabel.text == "00:00" {
            self.btnStopTimerOutlet.isHidden = true
        } else {
            self.btnStopTimerOutlet.isHidden = false
        }
    }
    @IBAction func stopTimerBtnTapped(_ sender: Any) {
        let nextVC = self.storyboard?.instantiateViewController(identifier: "PopUpViewController") as? PopUpViewController
        nextVC?.delegate = self
        self.navigationController?.present(nextVC!, animated: true)
    }
    @objc func updateTime() {
        if timeLeft > 0 {
            self.btnStopTimerOutlet.isHidden = false
            timeLeft = endTime?.timeIntervalSinceNow ?? 0
            timeLabel.text = timeLeft.time
            print(timeLeft)
            progressValue+=1
            print(progressValue)
            print(progressValue/Float(timeLeft))
            progressView.progress = progressValue/Float(lastTime)
            if(Int(100 * (progressValue/Float(lastTime)))<=100){
                percentageLabel.text = "\(String(Int(100 * (progressValue/Float(lastTime)))))%"
            }
            } else {
            timeLabel.text = "00:00"
            self.btnStopTimerOutlet.isHidden = true
            timer.invalidate()
            self.emergencyTapped()
            progressValue = 0.0
            progressView.progress = progressValue
            percentageLabel.text = "0%"
        }
//        if (progressValue < 1)
//            {
//                progressValue += 0.1
//                progressView.progress = progressValue
//            }
//            else
//            {
//                timer.invalidate()
//            }
    }
    
    func emergencyTapped() {
        
        LoadingUtils.shared.showActivityIndicator(uiView: self.view)
        EmergencyCallApiClient.shared.getCallContactsAPI(userId: self.userId, funct: "get_call_contacts") { success, error in
            if success {
              //  LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                let msg = EmergenyCallList.GetCallContactResponse["msg"] as? String
                let err = EmergenyCallList.GetCallContactResponse["error"] as? String
                if msg == "success" {
                    let data = EmergenyCallList.GetCallContactResponse["contacts"] as? [Dictionary<String, Any>]
                
                    let phoneNumber = "\(data?[0]["phone"] ?? "")"
                    
                    if phoneNumber.isEmpty {
                        LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                        AlertHelper.shared.toShowAlert(title: "Alert", message: "Please add a contact", viewController: self)
                        return
                    }
                    
                    let name = "\(data?[0]["name"] ?? "")"
                    
                    EmergencyCallApiClient.shared.makeCallAPI(funct: "make_call", phoneNumber: phoneNumber, message: name) { success, error in
                        if success {
                            
                          //  LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                            let msg = EmergenyCallList.MakeCallResponse["msg"] as? String
                            let err = EmergenyCallList.MakeCallResponse["error"] as? String
                            if msg == "success" {
                        
                                EmergencyCallApiClient.shared.sendEmailContactsAPI(funct: "send_email_contacts", userId: self.userId, userName: self.userName, location: self.location) { success, error in
                                    if success {
                                        
                                        EmergencyCallApiClient.shared.getSMSContactAPI(funct: "get_sms_contacts", userId: self.userId) { success, error in
                                            if success {
                                                
                                                EmergencyCallApiClient.shared.sendSMSAPI(funct: "send_sms", phoneNumber: phoneNumber, message: name) { success, error in
                                                    if success {
                                                        LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                                                    } else if let error = error {
                                                        LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                                                        print("error.localizedDescription\(error.localizedDescription)")
                                                    }
                                                }
                                            } else if let error = error {
                                                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                                                print("error.localizedDescription\(error.localizedDescription)")
                                            }
                                        }
                                    } else if let error = error {
                                        LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                                        print("error.localizedDescription\(error.localizedDescription)")
                                    }
                                }
                                
                            } else {
                                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                                AlertHelper.shared.toShowAlert(title: "Alert", message: msg ?? "", viewController: self)
                            }
                        } else if let error = error {
                            LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                            print("error.localizedDescription\(error.localizedDescription)")
                        }
                    }
                    
                } else  {
                   
                }
            } else if let error = error {
                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                print("error.localizedDescription\(error.localizedDescription)")
            }

        }
    }
    
    func timeString(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }

    @IBAction func btnSetTimerAction(_ sender: UIButton) {
        self.viewTimePicker.isHidden = false
    }
    
    @IBAction func btnDoneAction(_ sender: UIButton) {
        self.viewTimePicker.isHidden = true
        timeLeft = timePicker.date.timeIntervalSinceNow
        lastTime = timePicker.date.timeIntervalSinceNow
        endTime = Date().addingTimeInterval(timeLeft)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }
}
extension TimerViewController: dataPass {
    func timerRequirement(timerStop: String) {
        self.btnStopTimerOutlet.isHidden = true
        timeLabel.text = timerStop
        progressValue = 0.0
        progressView.progress = progressValue
        percentageLabel.text = "0%"
        timer.invalidate()
    }
}

extension TimeInterval {
    var time: String {
        return String(format:"%02d:%02d", Int(self/60),  Int(ceil(truncatingRemainder(dividingBy: 60))))
    }
}
extension Int {
    var degreesToRadians : CGFloat {
        return CGFloat(self) * .pi / 180
    }
}
