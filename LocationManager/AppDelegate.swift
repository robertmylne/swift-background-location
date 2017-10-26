//
//  AppDelegate.swift
//  LocationManager
//
//  Created by Robert Mylne on 25/10/17.
//  Copyright © 2017 Robert Mylne. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    let locationManager = CLLocationManager()
    var locationAlwaysAuthorizedEnabled = true
    var count = 0

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        count = 1
        writeToFile(text: "\n\n")
        writeToFile(text: "didFinishLaunchingWithOptions\(launchOptions)\n")
        startSignificantLocationMonitoring()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        // When the app comes back into the foreground
        if(!locationAlwaysAuthorizedEnabled) {
            alertAlwaysAuthorizedNotEnabled()
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: Location
    func startSignificantLocationMonitoring() {
        writeToFile(text: "startSignificantLocationMonitoring\n")
        
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            print("authorisation not correct")
            locationManager.requestAlwaysAuthorization()
            locationAlwaysAuthorizedEnabled = false
            
            return
        }
        
        print("authorisation correct")
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationAlwaysAuthorizedEnabled = true
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            print("update authorisation correct")
        default:
            print("update authorisation not correct")
            alertAlwaysAuthorizedNotEnabled()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("locationManager: \(locations)")
        writeToFile(text: "\(count): Location: \(locations.last!.coordinate.latitude)\n")
        count += 1
    }
    
    func alertAlwaysAuthorizedNotEnabled() {
        let alert = UIAlertController(title: "Error", message: "You must always allow location access to use this app", preferredStyle: .alert)
        let alertOk = UIAlertAction(title: "OK", style: .default) { (alert) in
            let settingsURL = URL(string: "App-Prefs:root=Privacy&path=LOCATION")
            UIApplication.shared.open(settingsURL!, options: [:], completionHandler: nil)
        }
        alert.addAction(alertOk)
        self.window?.rootViewController?.present(alert, animated: false, completion: nil)
    }

    func writeToFile(text: String) {
        print("writeToFile(\(text))")
        do {
            let path = "/Users/rob/locations.txt"
            var contents = try String(contentsOfFile: path, encoding: .utf8)
            contents.append(text)
            try contents.write(toFile: path, atomically: true, encoding: .utf8)
        } catch let error as NSError {
            print("error")
        }
    }
}

