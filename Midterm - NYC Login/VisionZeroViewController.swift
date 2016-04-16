//
//  VisionZeroViewController.swift
//  Midterm - NYC Login
//
//  Created by Sophia Richter on 4/16/16.
//  Copyright © 2016 Sophia Richter. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON
import MapKit

class VisionZeroViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let zip = ZipcodeInfo.getZipCode() {
            getLatLngForZip(zip)
            print(zip)
            
            loadVisionZeroData(zip)
            
            
        }
        
        mapView.delegate = self
        
        let mapCenter = coordinate
        let camera = MKMapCamera(lookingAtCenterCoordinate: mapCenter!, fromDistance: 5000, pitch: 0, heading: 0)
        mapView.setCamera(camera, animated: false)
        
        
    }
    
    var coordinate: CLLocationCoordinate2D?
    var zipString = "\(ZipcodeInfo.getZipCode())"
    
    
    func getLatLngForZip(zip: String) -> CLLocationCoordinate2D {
        let url = NSURL(string: "http://maps.google.com/maps/api/geocode/json?sensor=false&address=\(zip)")
        let data = NSData(contentsOfURL: url!)
        let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
        if let result = json["results"] as? NSArray {
            if let geometry = result[0]["geometry"] as? NSDictionary {
                if let location = geometry["location"] as? NSDictionary {
                    let latitude = location["lat"] as! Double
                    let longitude = location["lng"] as! Double
                    print("\n\(latitude), \(longitude)")
                    let test = CLLocationCoordinate2DMake(latitude, longitude)
                    coordinate = test
                }
            }
        }
        return coordinate!
    }
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let annotation = annotation as? collisionLocation {
            if annotation.owner != "" {
                var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier("used") as? MKPinAnnotationView
                
                if let pinView = pinView {
                    pinView.annotation = annotation
                } else {
                    pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "used")
                    pinView?.pinTintColor = UIColor.yellowColor()
                    pinView?.canShowCallout = true
                }
                return pinView
            } else {
                var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier("unused") as? MKPinAnnotationView
                
                if let pinView = pinView {
                    pinView.annotation = annotation
                } else {
                    pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "unused")
                    pinView?.pinTintColor = UIColor.grayColor()
                    pinView?.animatesDrop = true
                    pinView?.canShowCallout = true
                }
                return pinView
            }
        }
        
        return nil
    }
    
    func loadVisionZeroData(zip: String) {
    mapView.removeAnnotations(mapView.annotations)
        let dataURL = "https://data.cityofnewyork.us/resource/qiz3-axqb.json?zip_code=\(zip)"
        
        Alamofire.request(.GET, dataURL).responseData { response in
            if let data = response.data {
                let json = JSON(data: data)
                let locations = json[].arrayValue
                for location in locations {
                    
                    let coordinate = CLLocationCoordinate2DMake(location["location"]["coordinates"][1].doubleValue, location["location"]["coordinates"][0].doubleValue)
                    
                    let locationAnnotation = collisionLocation(coordinate: coordinate, title: location["contributing_factor_vehicle_1"].stringValue, owner: location["vehicle_type_code1"].stringValue)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.mapView.addAnnotation(locationAnnotation)
                    })
                }
            }
        }
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
             if let zip = ZipcodeInfo.getZipCode() {
            loadVisionZeroData(zip)
            }}
    }
}

class collisionLocation:NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var owner: String?
    
    var subtitle: String? {
        if let owner = owner {
            return "\(owner)"}
        return "\(owner)"
    }
    init(coordinate: CLLocationCoordinate2D,title: String?,owner: String?) {
        self.coordinate = coordinate
        self.title = title
        self.owner = owner
    }
}