//
//  ViewController.swift
//  CoreLocationDemo
//
//  Created by Joshua Mengel on 25/7/17.
//  Copyright © 2017 Joshua Mengel. All rights reserved.
//

import UIKit
import MapKit
import MessageUI
import CoreLocation

class ViewController: UIViewController, MFMailComposeViewControllerDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var theMap: MKMapView!
    
    var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self

        let status = CLLocationManager.authorizationStatus()

        if status == .notDetermined || status == .denied || status == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
        theMap.delegate = self
        theMap.showsUserLocation = true
        theMap.mapType = MKMapType(rawValue: 0)!
        theMap.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
    }

    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        print("present location : \(newLocation.coordinate.latitude), \(newLocation.coordinate.longitude)")
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendEmail(_ sender: Any) {
        
        let mailComposeViewController = configureMailController()
        
        if MFMailComposeViewController.canSendMail() {
            
            self.present(mailComposeViewController, animated: true, completion: nil)
            
        } else {
            
            showReportError()
            
        }
        
    }
    
    func configureMailController() -> MFMailComposeViewController {
        
        let reportEmailVC = MFMailComposeViewController()
        reportEmailVC.mailComposeDelegate = self
        reportEmailVC.setToRecipients(["edanreynolds@gmail.com"])
        reportEmailVC.setSubject("Report Email")
        reportEmailVC.setMessageBody("Test", isHTML: false)
        
        return reportEmailVC
        
    }
    
    func showReportError() {
        
        let sendMailErrorAlert = UIAlertController(title: "Could not send mail", message: "Your device could not send email", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true, completion: nil)
        
    }
    
}
