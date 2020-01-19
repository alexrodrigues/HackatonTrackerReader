//
//  ViewController.swift
//  MapTracker
//
//  Created by Alex Rodrigues on 1/19/20.
//  Copyright © 2020 Alex Rodrigues. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController {

    private var timer : Timer?
    private var locationManager = CLLocationManager()
    private let pinMapIdentifier = "MapPin"
    
    @IBOutlet var map: MKMapView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializingMap()
        
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(ViewController.fetchData), userInfo: nil, repeats: true)
    
    }

    @objc func fetchData() {
        map.setMapCameraPosition(map.userLocation.coordinate, cameraDistance:  0.005)
        SimpleApi().fetchData(delegate: self)
    }
    
    func initializingMap() {
        map.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
    }
}

extension ViewController: SimpleApiDelegate {
    func didFinishParse(list: [TrackLocation]) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.map.drawRoute(list)
        }
    }
}

extension ViewController : MKMapViewDelegate, CLLocationManagerDelegate {
    //MARK: - MAPKIT && CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedAlways || status == CLAuthorizationStatus.authorizedWhenInUse {
            if let coordinate = locationManager.location?.coordinate {
                map.setMapCameraPosition(coordinate, cameraDistance: 0.005)
            }
        }
    }

    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polyLine = overlay
        let polyLineRenderer = MKPolylineRenderer(overlay: polyLine)
        polyLineRenderer.strokeColor = UIColor.blue
        polyLineRenderer.lineWidth = 2.0
        return polyLineRenderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: pinMapIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: pinMapIdentifier)
        }
        else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
}
