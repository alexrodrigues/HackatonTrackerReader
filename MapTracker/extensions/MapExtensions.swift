//
//  MapExtensions.swift
//  MapTracker
//
//  Created by Alex Rodrigues on 1/19/20.
//  Copyright © 2020 Alex Rodrigues. All rights reserved.
//

import UIKit
import MapKit

extension MKMapView {
    func drawRoute(_ routes : [TrackLocation]) {
        let numberOfSteps = routes.count
        var arrayOfCoordinates = [CLLocationCoordinate2D]()
        for  route in routes {
            guard let latitude = route.latitude else {
                return
            }
            guard let longitude = route.longitude else {
                return
            }
            
            let coordinate2d = CLLocationCoordinate2DMake(Double(latitude), Double(longitude))
            arrayOfCoordinates.append(coordinate2d)
        }
        let polyline = MKPolyline(coordinates: &arrayOfCoordinates, count: numberOfSteps)
        addOverlay(polyline)
    }
    
    func setMapCameraPosition(_ coordinate : CLLocationCoordinate2D, cameraDistance : Double) {
        let span = MKCoordinateSpan(latitudeDelta: cameraDistance, longitudeDelta: cameraDistance)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        self.setRegion(region, animated: true)
    }
}
