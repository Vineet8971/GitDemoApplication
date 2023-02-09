//
//  LocationViewController.swift
//  SmartSecureApp
//
//  Created by Ranadheer on 22/12/2022.
//

import UIKit
import GoogleMaps
import GooglePlaces


class LocationViewController: UIViewController,GMSAutocompleteViewControllerDelegate {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var switch_toggle: UISwitch!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var markerImageView: UIImageView!
    var getName = String()
    
    let locationManager = CLLocationManager()
    var strComingFrom: String!
    var userlat:String!
    var userlong:String!
    var getLocation = String()
    var strGetFromMapAddress: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if getName == "Setting" {
            backBtn.isHidden = false
        } else {
            backBtn.isHidden = true
        }
        
        self.mapView.bringSubviewToFront(markerImageView)
        self.mapView.isMyLocationEnabled = true
        mapView.delegate = self
        
        switch_toggle.addTarget(self, action: #selector(switchIsChanged), for: UIControl.Event.valueChanged)
        Task.init {
            await registerForLocationUpdates()
        }
        // Do any additional setup after loading the view.
    }
    
    func storeLocation(){
        let dict = ["lat":userlat,"long":userlong,"address":strGetFromMapAddress]
        CoreDataManager.shared.save(object: dict as? [String:String] ?? ["":""])
    }
    
    @objc func switchIsChanged(mySwitch: UISwitch) {
        if switch_toggle.isOn {
            self.mapView.isHidden = false
            self.markerImageView.isHidden = false
        } else {
            self.mapView.isHidden = true
            self.markerImageView.isHidden = true
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func registerForLocationUpdates() async {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .restricted,.denied:
                print("No access")
                // let alertController = UIAlertController(title: languageChangeString(a_str: #"Allow "توكه" to access your location?"#) , message: languageChangeString(a_str:"Please enable Location based services.This App needs permission to access your location to show near by products in the map.To enable permissions please go to Settings and turn on the permissions"), preferredStyle: .alert)
                
                let alertController = UIAlertController(title: "Allow Location Access" , message: "This App needs permission to access your location to show near by products in the map.Press settings to update or cancel to deny access", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let settingsAction = UIAlertAction(title:  "Settings", style: .default) { (UIAlertAction) in
                    
                    
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)! as URL, options: [:], completionHandler: nil)
                    } else {
                        // Fallback on earlier versions
                    }
                }
                
                alertController.addAction(cancelAction)
                alertController.addAction(settingsAction)
                self.present(alertController, animated: true, completion: nil)
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.startUpdatingLocation()
                
                
            case .notDetermined:
                print("")
            }
        } else {
            isAuthorizedtoGetUserLocation()
            print("Location services are not enabled")
        }
    }
    
    func isAuthorizedtoGetUserLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse  {
            locationManager.requestWhenInUseAuthorization()
        }
        else {
            locationManager.startUpdatingLocation()
        }
    }
    
    // MARK: GOOGLE AUTO COMPLETE DELEGATE
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 15.0)
        self.mapView.camera = camera
        var curLat : CGFloat = CGFloat(place.coordinate.latitude)
        let curLong : CGFloat = CGFloat(place.coordinate.longitude)
        
        userlat = String(format: "%.8f", curLat)
        userlong = String(format: "%.8f", curLong)
        
        
        let defaults = UserDefaults.standard
        defaults.set(curLat, forKey: "lat")
        defaults.set(curLong, forKey: "lng")
        
        /* reverse Geo COding */
        
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        
        let lat: Double = Double("\(place.coordinate.latitude)")!
        let lon: Double = Double("\(place.coordinate.longitude)")!
        
        
        let ceo = GMSGeocoder()
        
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        
        ceo.reverseGeocodeCoordinate(center) { response , error in
            
            if error != nil {
                print("GMSReverseGeocode Error: \(String(describing: error?.localizedDescription))")
            }
            else
            {
                let pm =  response?.results()?.first
                self.getLocation = "\(pm?.locality ?? "")"
                let string = pm?.lines?.joined(separator: ",")
                print(string ?? "")
                
                if(pm?.lines != nil)
                {
                    //self.tf_place.text = string
                    print("lat:\(lat)")
                     print("long:\(lon)")
                     self.storeLocation()
                    self.strGetFromMapAddress  = string
                    print("self.strGetFromMapAddress-->GmmsAuto: \(self.strGetFromMapAddress)")
                    let defaults = UserDefaults.standard
                    defaults.set(string, forKey: "from_address")
                }
            }
        }
        
        self.dismiss(animated: true, completion: nil) // dismiss after select place
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        
        print("ERROR AUTO COMPLETE \(error)")
        
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil) // when cancel search
    }
    
    
}

//MARK:-   GMSMAPVIEW DELEGATE METHODS
extension LocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
       // self.locationManager.stopUpdatingLocation()
        
        
        //MARK:- VINEET CODE
        
        var curLat : CGFloat = CGFloat(location!.coordinate.latitude)
        let curLong : CGFloat = CGFloat(location!.coordinate.longitude)
        
        print("did update core location is lat and long \(curLat)\(curLong)")
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude:(location?.coordinate.longitude)!, zoom:13)
        
        mapView.animate(to: camera)
        
        self.mapView.delegate = self
        userlat = String(format: "%.8f", curLat)
        userlong = String(format: "%.8f", curLong)
        
        
        let defaults = UserDefaults.standard
        defaults.set(curLat, forKey: "lat")
        defaults.set(curLong, forKey: "lng")
        
        /* reverse Geo COding */
        
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        
        let lat: Double = Double("\(location!.coordinate.latitude)")!
        let lon: Double = Double("\(location!.coordinate.longitude)")!
    
        let ceo = GMSGeocoder()
        center.latitude = lat
        center.longitude = lon
        //let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeCoordinate(center) { response , error in
            
            if error != nil {
                print("GMSReverseGeocode Error: \(String(describing: error?.localizedDescription))")
            }
            else
            {
                let pm =  response?.results()?.first
                self.getLocation = "\(pm?.locality ?? "")"
                //getLocation = "\(self.pm?.administrativeArea),\(self.pm?.country),\(self.pm?.postalCode)"
                //print(self.getLocation)
                let string = pm?.lines?.joined(separator: ",")
                print(string ?? "")
                
                if(pm?.lines != nil)
                {
                   print("lat:\(lat)")
                    print("long:\(lon)")
                    
                    //MARK:- VINEET CODE
                    
                    if defaults.value(forKey: "lat") as! CGFloat != curLat && defaults.value(forKey: "lng") as! CGFloat != curLong {
                        LocationApiClient.shared.insertLoctionApiIntegration(funct: "insert_locations", userId: UserDefaults.standard.value(forKey: "userid") as? String ?? "", lat: self.userlat, lng: self.userlong, location: self.getLocation) { success, error in
                            if success {
                                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                                let msg = LocationList.LocationResponse["msg"] as? String
                                let err = LocationList.LocationResponse["error"] as? String
                                if msg == "success" {
                            
                                } else{
                                    AlertHelper.shared.toShowAlert(title: "Alert", message: msg ?? "", viewController: self)
                                }
                            }  else if let error = error {
                                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
                                print("error.localizedDescription\(error.localizedDescription)")
                            }
                        }
                    }
                    self.storeLocation()
                    let defaults = UserDefaults.standard
                    self.strGetFromMapAddress  = string
                    print("self.strGetFromMapAddress-->didUpdate: \(self.strGetFromMapAddress)")
                    defaults.set(string, forKey: "from_address")
                }
            }
        }
        
        let location1 = locationManager.location?.coordinate
        cameraMoveToLocation(toLocation: location1)
    }
    
    func cameraMoveToLocation(toLocation: CLLocationCoordinate2D?) {
        if toLocation != nil {
            mapView.camera = GMSCameraPosition.camera(withTarget: toLocation!, zoom: 15)
        }
    }
}

//MARK:-   GMSMAPVIEW DELEGATE METHODS
extension LocationViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        print("idle point lat  and long \(mapView.camera.target.latitude),\(mapView.camera.target.longitude)")
        let curLat: CGFloat = CGFloat(mapView.camera.target.latitude)
        let curLong: CGFloat = CGFloat(mapView.camera.target.longitude)
        
        let defaults = UserDefaults.standard
        defaults.set(curLat, forKey: "lat")
        defaults.set(curLong, forKey: "lng")
        
        userlat = String(format: "%.8f", curLat)
        userlong = String(format: "%.8f", curLong)
        
        
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = mapView.camera.target.latitude
        //21.228124
        let lon: Double = mapView.camera.target.longitude
        //72.833770
        
        
        //print("map did change lat and long : \(lat) \(lon)")
        center.latitude = CLLocationDegrees(lat)
        center.longitude = CLLocationDegrees(lon)
        
      
        center.latitude = CLLocationDegrees(lat)
        center.longitude = CLLocationDegrees(lon)
        let ceo = GMSGeocoder()
        
        ceo.reverseGeocodeCoordinate(center) { response , error in
            
            if error != nil {
                print("GMSReverseGeocode Error: \(String(describing: error?.localizedDescription))")
            }
            else
            {
                let pm =  response?.results()?.first
                print("adress of that location is \(pm)")
                // let myAddress = response?.results()?.first as? Dictionary<String,Any>
                
                self.getLocation = "\(pm?.locality ?? "")"
                let string = pm?.lines?.joined(separator: ",")
                print(string ?? "")
                
                if(pm?.lines != nil)
                {
                    //self.tf_place.text = string
                    let defaults = UserDefaults.standard
                    self.strGetFromMapAddress  = string
                    print("self.strGetFromMapAddress--->idle: \(self.strGetFromMapAddress)")
                    defaults.set(string, forKey: "from_address")
                }
            }
        }
    }
}
