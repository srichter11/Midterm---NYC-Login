//
//  TrendingPlacesViewController.swift
//  Midterm - NYC Login
//
//  Created by Sophia Richter on 4/15/16.
//  Copyright © 2016 Sophia Richter. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON
import MapKit


class TrendingPlacesViewController: UIViewController, MKMapViewDelegate {


    @IBOutlet weak var mapView: MKMapView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let zip = ZipcodeInfo.getZipCode() {
          getLatLngForZip(zip)
            print(zip)
            
        loadFourSquareData(zip)

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
        
        if let annotation = annotation as? swarmLocation {
            if annotation.hereNow > 0 {
                var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier("openStation") as? MKPinAnnotationView
                
                if let pinView = pinView {
                    pinView.annotation = annotation
                } else {
                    pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "openStation")
                    pinView?.pinTintColor = UIColor.greenColor()
                    pinView?.canShowCallout = true
                }
                return pinView
            } else {
                var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier("closedStation") as? MKPinAnnotationView
                
                if let pinView = pinView {
                    pinView.annotation = annotation
                } else {
                    pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "closedStation")
                    pinView?.pinTintColor = UIColor.magentaColor()
                    pinView?.animatesDrop = true
                    pinView?.canShowCallout = true
                }
                return pinView
            }
        }
        
        return nil
    }
    
    func loadFourSquareData(zip: String) {
        mapView.removeAnnotations(mapView.annotations)
        let dataURL = "https://api.foursquare.com/v2/venues/search?near=\(zip)&client_id=GVWBY0VRTSM03H1R2GGALDOBDZPEMYOGRJC2P4U0YJNNZDMS&client_secret=WKIWO1R4X0LJ5B2UU5V1EASZKPOCUDOOMPKXFGWUZEOTVRUH&v=20160415182098"
        
        Alamofire.request(.GET, dataURL).responseData { response in
            if let data = response.data {
                let json = JSON(data: data)
                let locations = json["response"]["venues"].arrayValue
                for location in locations {
                    
                    let coordinate = CLLocationCoordinate2DMake(location["location"]["lat"].doubleValue, location["location"]["lng"].doubleValue)
                    
                    let locationAnnotation = swarmLocation(coordinate: coordinate, title: location["name"].stringValue, hereNow: location["hereNow"]["count"].intValue)
                    
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
            loadFourSquareData(zip)
            }
        }
    }
}

class swarmLocation:NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var hereNow = 0
    
    var subtitle: String? {
        return "\(hereNow) people here now"
    }
    
    init(coordinate: CLLocationCoordinate2D,title: String?,hereNow: Int) {
        self.coordinate = coordinate
        self.title = title
        self.hereNow = hereNow
    }
}


