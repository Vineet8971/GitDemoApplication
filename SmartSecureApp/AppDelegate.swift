//
//  AppDelegate.swift
//  SmartSecureApp
//
//  Created by Ranadheer on 20/12/2022.
//

import UIKit
import CoreData
import CoreLocation
import IQKeyboardManagerSwift
import Alamofire
import GoogleMaps
import GooglePlaces

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var locationManager: CLLocationManager = {
        
        var _locationManager = CLLocationManager()
        //_locationManager.delegate = self as! CLLocationManagerDelegate
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.activityType = .automotiveNavigation
        _locationManager.distanceFilter = 10.0
        return _locationManager
    }()
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        print("Document Directory:",FileManager.default.urls(for: .documentationDirectory, in: .userDomainMask).last ?? "Not Found!")
        GMSServices.provideAPIKey("AIzaSyAX4Gq_3GkLUCRz7wlrHaUakugCRJEppjQ")
        GMSPlacesClient.provideAPIKey("AIzaSyCziqe1Q-d4HMC3D9ZyYDFkBtx8ZHrzGzM")
        
        isAuthorizedtoGetUserLocation()
        // Override point for customization after application launch.
        return true
    }
    
    func isAuthorizedtoGetUserLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse  {
            locationManager.requestWhenInUseAuthorization()
        }
        else {
            locationManager.startUpdatingLocation()
        }
//        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse  {
//            locationManager.requestWhenInUseAuthorization()
//        }
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "SmartSecureApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("APNs device token: \(token)")
        UserDefaults.standard.set(token, forKey: "devicetoken")

    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("i am not available in simulator :( \(error)")
    }
}

//MARK:-   GMSMAPVIEW DELEGATE METHODS
extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let location = locations.last
        self.locationManager.stopUpdatingLocation()


        //MARK:- VINEET CODE

        let curLat : CGFloat = CGFloat(location!.coordinate.latitude)
        let curLong : CGFloat = CGFloat(location!.coordinate.longitude)

        print("did update core location is lat and long \(curLat)\(curLong)")
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
                let string = pm?.lines?.joined(separator: ",")
                print(string ?? "")

                if(pm?.lines != nil)
                {
                   print("lat:\(lat)")
                    print("long:\(lon)")
                    if defaults.value(forKey: "lat") as! CGFloat != curLat && defaults.value(forKey: "lng") as! CGFloat != curLong {

                    }
                    let defaults = UserDefaults.standard
                    defaults.set(string, forKey: "from_address")
                }
            }
        }
    }
}
