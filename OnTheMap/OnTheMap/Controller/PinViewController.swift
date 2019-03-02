//
//  PinViewController.swift
//  OnTheMap
//
//  Created by Geek on 2/22/19.
//  Copyright © 2019 Geek. All rights reserved.
//

import UIKit
import MapKit

/**
 * This view controller demonstrates the objects involved in displaying pins on a map.
 *
 * The map is a MKMapView.
 * The pins are represented by MKPointAnnotation instances.
 *
 * The view controller conforms to the MKMapViewDelegate so that it can receive a method
 * invocation when a pin annotation is tapped. It accomplishes this using two delegate
 * methods: one to put a small "info" button on the right side of each pin, and one to
 * respond when the "info" button is tapped.
 */

class PinViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var parseStudent = ParseStudent()
    static let map: PinViewController = PinViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refresh()
    }
    func refresh(){
        mapView.removeAnnotations(mapView.annotations)
        parseStudent.getStudents { (students) -> Void in
            
            let locations = Singleton.sharedInstance.students
            var annotations = [MKPointAnnotation]()
            
            for dictionary in locations! {
                let lat = CLLocationDegrees(dictionary.latitude)
                let long = CLLocationDegrees(dictionary.longitude)
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let fullName = dictionary.fullName
                let mediaURL = dictionary.mediaURL
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(fullName)"
                annotation.subtitle = mediaURL
                annotations.append(annotation)
            }
            self.mapView.addAnnotations(annotations)
            PinViewController.map.mapView = self.mapView
        }
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle!{
                if(URL(string: toOpen) != nil){
                    app.open(URL(string: toOpen)!)
                }
            }
        }
    }
}
