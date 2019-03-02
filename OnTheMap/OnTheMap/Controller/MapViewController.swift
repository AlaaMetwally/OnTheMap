//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Geek on 2/27/19.
//  Copyright © 2019 Geek. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate{
 
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var mapHeight: NSLayoutConstraint!
    @IBOutlet weak var findButton: UIButton!
    
    var onTheMapConvenience = OnTheMapConvenience()
    var parseStudents = ParseStudent()
    var lat: Double?
    var long: Double?
    var mediaString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.location.placeholder = "Enter Your Location Here"
        self.mapHeight.constant = 0
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        location.resignFirstResponder()
        return true
    }
    @IBAction func cancel(_ sender: UIButton){
        dismiss(animated: true, completion: nil)
    }
    @IBAction func submit(_ sender: UIButton){

        guard let mediaURL =  self.location!.text  else {
            print("mediaURL isn\'t available")
            return
        }
        if(Singleton.sharedInstance.student == nil){
            onTheMapConvenience.getUserData{(student) in
                var dictionary = self.getDictionaryOfStudent(student: student, mediaURL: mediaURL)
                var students = Students(dictionary: dictionary as [String : AnyObject])
                self.parseStudents.postStudent(student: students) { (objectId) in
                    students.objectId = objectId
                    Singleton.sharedInstance.objectId = objectId
                    self.getMap(students: students)
                }
            }
        }else{
            var student = Singleton.sharedInstance.student!
            var dictionary = self.getDictionaryOfStudent(student: student, mediaURL: mediaURL)
            dictionary["objectId"] = Singleton.sharedInstance.objectId
            var students = Students(dictionary: dictionary as [String : AnyObject])
                self.parseStudents.putStudent(student: students) { (studentData) in
                    self.getMap(students: students)
            }
        }
    }
    func getDictionaryOfStudent(student: Student,mediaURL: String) -> [String:Any]{
        let dictionary = ["firstName" : student.firstName,
                          "lastName" : student.lastName,
                          "mapString" : self.mediaString,
                          "mediaURL" : mediaURL,
                          "latitude" : self.lat,
                          "longitude" : self.long,
                          "uniqueKey" : student.uniqueKey,
                          ] as [String : Any]
        return dictionary
    }
    func getMap(students: Students){
        performUIUpdatesOnMain {
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "MapNavigationController") as! UINavigationController
            self.present(controller, animated: true, completion: nil)
            let locations = Singleton.sharedInstance.students
            var annotations = [MKPointAnnotation]()
            
            let lat = CLLocationDegrees(students.latitude)
            let long = CLLocationDegrees(students.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let fullName = students.fullName
            let mediaURL = students.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(fullName)"
            annotation.subtitle = mediaURL
            annotations.append(annotation)
            
            self.mapView.addAnnotations(annotations)
            let latitude = CLLocationDegrees(students.latitude)
            let longitude = CLLocationDegrees(students.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.075, longitudeDelta: 0.075)
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:latitude, longitude: longitude), span: span)
            PinViewController.map.mapView.setRegion(region, animated: true)
        }
    }
    @IBAction func findLocation(_ sender: Any) {
        let geoCoder = CLGeocoder()
        guard let address = self.location.text else{
            print("location is empty")
            return
        }
        mediaString = address
        geoCoder.geocodeAddressString(mediaString!) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let locationAddress = placemarks.first?.location?.coordinate
                else {
                    // handle no location found
                    print(error ?? "there is such an error")
                    return
            }
            // Use your location
            var annotations = [MKPointAnnotation]()
            self.lat = CLLocationDegrees(locationAddress.latitude)
            self.long = CLLocationDegrees(locationAddress.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: self.lat!, longitude: self.long!)

            UIView.animate(withDuration: 0.5, animations: {
                self.mapHeight.constant = self.location.frame.size.height / 2
                self.view.layoutIfNeeded()
            })
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate

            annotations.append(annotation)
            self.mapView.addAnnotations(annotations)
            self.location.text = ""
            self.location.placeholder = "Enter A Link To Share Here"
            self.findButton.isHidden = true
        }
    }
}
