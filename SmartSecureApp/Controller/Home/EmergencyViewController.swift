//
//  EmergencyViewController.swift
//  SmartSecureApp
//
//  Created by Ranadheer on 22/12/2022.
//

import UIKit
import Alamofire
import CallKit
import AVFoundation

class EmergencyViewController: UIViewController {

    @IBOutlet weak var btnPrivacyPolicy: UIButton!
    @IBOutlet weak var btnTermsCondition: UIButton!
    var userId = String()
    var location = String()
    var userName = String()
    var phoneNumber = String()
    
    var audioRecorder: AVAudioRecorder!
    var audioFilename: URL!
    var meterTimer:Timer!
    var isAudioRecordingGranted: Bool!
    var tabBar = TabsVC()
    
    let yourAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
        NSAttributedString.Key.foregroundColor: UIColor.systemRed,
        NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
      ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUiDesign()
        callGetApi()
    }
            
   func setUpUiDesign() {
        let attributePrivacyString = NSMutableAttributedString(
             string: "Privacy Policy",
             attributes: yourAttributes
           )
        self.btnPrivacyPolicy.setAttributedTitle(attributePrivacyString, for: .normal)
        
        let attributeTermsString = NSMutableAttributedString(
             string: "Terms and Conditions",
             attributes: yourAttributes
           )
        self.btnTermsCondition.setAttributedTitle(attributeTermsString, for: .normal)
    }
    
    func callGetApi() {
        check_record_permission()
        
        userId = "\(UserDefaults.standard.value(forKey: "userid") ?? "")"
        location = "\(UserDefaults.standard.value(forKey: "from_address") ?? "")"
        userName = "\(UserDefaults.standard.value(forKey: "userName") ?? "")"
        UserDefaults.standard.value(forKey: "userPassword")
    }
    
    func check_record_permission()
    {
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            isAudioRecordingGranted = true
            break
        case AVAudioSession.RecordPermission.denied:
            isAudioRecordingGranted = false
            break
        case AVAudioSession.RecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (allowed) in
                if allowed {
                    self.isAudioRecordingGranted = true
                } else {
                    self.isAudioRecordingGranted = false
                }
            })
            break
        default:
            break
        }
    }
    
    func setup_recorder()
    {
        if isAudioRecordingGranted
        {
            let session = AVAudioSession.sharedInstance()
            do
            {
                try session.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
                try session.setActive(true)
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 2,
                    AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
                ]
                audioFilename = getDocumentsDirectory().appendingPathComponent("audio.m4a")
                
                audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.isMeteringEnabled = true
                audioRecorder.prepareToRecord()
            }
            catch let error {
                print("error.localizedDescription\(error.localizedDescription)")
            }
        }
        else
        {
            LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
            AlertHelper.shared.toShowAlert(title: "Alert", message: "Don't have access to use your microphone.", viewController: self)
           //showToast(message: "Don't have access to use your microphone.")
        }
    }
    
    @objc func updateAudioTimer(timer: Timer) {
 
        if audioRecorder != nil {
            if audioRecorder.isRecording  {
                let min = Int(audioRecorder.currentTime / 60)
                let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
                let totalTimeString = String(format: "%02d:%02d", min, sec)
                audioRecorder.updateMeters()

                if (sec == 10) {

                    finishAudioRecording(success: true)
                }
            }
        }
    }

    
    func finishAudioRecording(success: Bool) {

        if success {
            audioRecorder.stop()
            audioRecorder = nil
            meterTimer.invalidate()
        } else {
            print("Failed :(")
        }
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    @IBAction func emergencyCallTapped(_ sender: UIButton) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        self.emergencyTapped()
    }
    
    @objc func emergencyTapped() {
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
                        UIApplication.shared.endIgnoringInteractionEvents()
                        AlertHelper.shared.toShowAlert(title: "Alert", message: "Please add a contact", viewController: self)
                        return
                    }
                    let name = "\(data?[0]["name"] ?? "")"
                    
                    EmergencyCallApiClient.shared.makeCallAPI(funct: "make_call", phoneNumber: phoneNumber, message: name) { success, error in
                        if success {
                            
                         //   LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                            let msg = EmergenyCallList.MakeCallResponse["msg"] as? String
                            let err = EmergenyCallList.MakeCallResponse["error"] as? String
                            if msg == "success" {
                                self.setup_recorder()
                                self.audioRecorder.record()
                                self.meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioTimer(timer:)), userInfo:nil, repeats:true)
                                
                                EmergencyCallApiClient.shared.sendEmailContactsAPI(funct: "send_email_contacts", userId: self.userId, userName: self.userName, location: self.location) { success, error in
                                    if success {
                                        
                                        EmergencyCallApiClient.shared.getSMSContactAPI(funct: "get_sms_contacts", userId: self.userId) { success, error in
                                            if success {
                                                
                                                EmergencyCallApiClient.shared.sendSMSAPI(funct: "send_sms", phoneNumber: phoneNumber, message: name) { success, error in
                                                    if success {
                                                        LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                                                        UIApplication.shared.endIgnoringInteractionEvents()
                                                    } else if let error = error {
                                                        LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                                                        UIApplication.shared.endIgnoringInteractionEvents()
                                                        AlertHelper.shared.toShowAlert(title: "Error", message: "\(error.localizedDescription)", viewController: self)
                                                    }
                                                }
                                            } else if let error = error {
                                                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                                                UIApplication.shared.endIgnoringInteractionEvents()
                                                AlertHelper.shared.toShowAlert(title: "Error", message: "\(error.localizedDescription)", viewController: self)
                                            }
                                        }
                                    } else if let error = error {
                                        LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                                        UIApplication.shared.endIgnoringInteractionEvents()
                                        AlertHelper.shared.toShowAlert(title: "Error", message: "\(error.localizedDescription)", viewController: self)
                                    }
                                }
                                
                            } else {
                                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                                UIApplication.shared.endIgnoringInteractionEvents()
                                AlertHelper.shared.toShowAlert(title: "Alert", message: msg ?? "", viewController: self)
                            }
                        } else if let error = error {
                            LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                            UIApplication.shared.endIgnoringInteractionEvents()
                            AlertHelper.shared.toShowAlert(title: "Error", message: "\(error.localizedDescription)", viewController: self)
                        }
                    }
                    
                } else{
                    LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                    UIApplication.shared.endIgnoringInteractionEvents()
                    AlertHelper.shared.toShowAlert(title: "Alert", message: msg ?? "", viewController: self)
                }
            } else if let error = error {
                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                UIApplication.shared.endIgnoringInteractionEvents()
                AlertHelper.shared.toShowAlert(title: "Error", message: "\(error.localizedDescription)", viewController: self)
            }
            
        }
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
    
}
extension EmergencyViewController: AVAudioRecorderDelegate,AVAudioPlayerDelegate {
func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
           if !flag {
               finishAudioRecording(success: false)
           } else {
               EmergencyCallApiClient.shared.request(funct: "insert_update_history", userId: self.userId, location: self.location ,audioFilePath: audioFilename, completion: { (response,error) -> Void in
               if response {
                   print("success")
               }   else {

                   print("error")
               }
           })

           }
}
}
