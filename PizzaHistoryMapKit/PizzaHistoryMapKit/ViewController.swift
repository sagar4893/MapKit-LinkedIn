//
//  ViewController.swift
//  PizzaHistoryMapKit
//
//  Created by Sagar Chauhan on 14/12/22.
//

import UIKit
import MapKit

// Lapinoz Pizza - 23.5882572,72.3748589

class ViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var changeMapType: UIButton!
    @IBOutlet weak var changePinch: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Variables
    var coordinate2D = CLLocationCoordinate2D(latitude: 23.5882572, longitude: 72.3748589)
    var camera = MKMapCamera()
    var pitch = 0
    var isOn = true
    var locationManager = CLLocationManager()
    var heading = 0.0
    let onRampCoordinate = CLLocationCoordinate2D(latitude: 37.3346, longitude: -122.0345)
    
    
    
    //MARK: - Actions
    @IBAction func changeMapType(_ sender: UIButton) {
        switch mapView.mapType {
            
        case .standard:
            mapView.mapType = .satellite
            sender.setTitle("Satellite", for: .normal)
        
        case .satellite:
            mapView.mapType = .hybrid
            sender.setTitle("Hybrid", for: .normal)
        
        case .hybrid:
            mapView.mapType = .satelliteFlyover
            sender.setTitle("Satellite\nFlyover", for: .normal)
        
        case .satelliteFlyover:
            mapView.mapType = .hybridFlyover
            sender.setTitle("Hybrid\nFlyover", for: .normal)
        
        case .hybridFlyover:
            mapView.mapType = .mutedStandard
            sender.setTitle("Muted\nStandard", for: .normal)
        
        case .mutedStandard:
            mapView.mapType = .standard
            sender.setTitle("Standard", for: .normal)
        
        @unknown default:
            mapView.mapType = .standard
            sender.setTitle("Standard", for: .normal)
        }
    }
    
    @IBAction func changePinch(_ sender: UIButton) {
        pitch = (pitch + 15) % 90
        sender.setTitle("\(pitch)", for: .normal)
        mapView.camera.pitch = CGFloat(pitch)
    }
    
    @IBAction func toggleMapFeature(_ sender: UIButton) {
        disableLocationServices()
        isOn = !mapView.showsPointsOfInterest
        mapView.showsPointsOfInterest = isOn
        mapView.showsScale = isOn
        mapView.showsCompass = isOn
        mapView.showsTraffic = isOn
    }
    
    @IBAction func findHere(_ sender: Any) {
        setupCoreLocation()
    }
    
    @IBAction func findPizza(_ sender: UIButton) {
        
        /*
        let address = "2121 N Clark St"
        getCoordinate(address: address) { [weak self] coordinate, location, error in
            guard let self = self else { return }
            
            if let coordinate = coordinate {
                self.mapView.camera.centerCoordinate = coordinate
                self.mapView.camera.altitude = 1000
                let pin = PizzaAnnotation(coordinate: coordinate, title: address, subtitle: location)
                self.mapView.addAnnotation(pin)
            }
        }
         */
        
        /*
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Pizza"
        updateMapRegion(rangeSpan: 500)
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            
            guard error == nil else {
                return
            }
            
            if let response = response {
                for mapItem in response.mapItems {
                    let placemark = mapItem.placemark
//                    self.mapView.addAnnotation(placemark)
                    let name = mapItem.name
                    let coordinate = placemark.coordinate
                    let streetAddress = placemark.thoroughfare
                    let annotation = PizzaAnnotation(coordinate: coordinate, title: name, subtitle: streetAddress)
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
         */
        
        let annotations = PizzaHistoryAnnotations().annotations
        let start = annotations[0].coordinate
        let destination = annotations[1].coordinate
        findDirection(start: start, destination: destination)
    }
    
    @IBAction func locationPicker(_ sender: UISegmentedControl) {
        disableLocationServices()
        let index = sender.selectedSegmentIndex
//        mapView.removeAnnotations(mapView.annotations)
        
        switch index {
        case 0: // Mehsana
            coordinate2D = CLLocationCoordinate2DMake(23.5880, 72.3693)
            updateMapCamera(heading: 0, altitude: 15000)
        
        case 1: // Ahmedabad
            coordinate2D = CLLocationCoordinate2DMake(23.0225, 72.5714)
            updateMapCamera(heading: 0, altitude: 15000)
//            let pizzaPin = PizzaAnnotation(coordinate: coordinate2D, title: "Ahmedabad Pizza", subtitle: "Pizza Comes to India")
//            mapView.addAnnotation(pizzaPin)
            
        case 2: // Baroda
            coordinate2D = CLLocationCoordinate2DMake(22.3072, 73.1812)
            updateMapCamera(heading: 0, altitude: 15000)
            return
        
        case 3: // Surat
            coordinate2D = CLLocationCoordinate2DMake(21.1702, 72.8311)
            updateMapCamera(heading: 0, altitude: 15000)
            return
        
        case 4: // Rajkot
            coordinate2D = CLLocationCoordinate2DMake(22.3039, 70.8022)
            updateMapCamera(heading: 0, altitude: 15000)
            return
       
        default:
            coordinate2D = CLLocationCoordinate2DMake(23.5880, 72.3693)
        }
        
        updateMapRegion(rangeSpan: 100)
    }
    
    
    // MARK: - Instance Methods
    func updateMapRegion(rangeSpan: CLLocationDistance) {
        let region = MKCoordinateRegion(center: coordinate2D, latitudinalMeters: rangeSpan, longitudinalMeters: rangeSpan)
        mapView.region = region
    }
    
    func updateMapCamera(heading: CLLocationDirection, altitude: CLLocationDistance) {
        camera.centerCoordinate = coordinate2D
        camera.heading = heading
        camera.altitude = altitude
        camera.pitch = 0
        changePinch.setTitle("0", for: .normal)
        mapView.camera = camera
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        mapView.addAnnotations(PizzaHistoryAnnotations().annotations)
        updateMapRegion(rangeSpan: 100)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addDeliveryOverlay()
        addPolylines()
    }
}


// MARK: - Annotation Delegate
extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = MKAnnotationView()
        
        guard let annotation = annotation as? PizzaAnnotation else {
            return nil
        }
        
        if let dequedView = mapView.dequeueReusableAnnotationView(withIdentifier: annotation.identifier) {
            annotationView = dequedView
        } else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotation.identifier)
        }
        
        if annotation.title == "Destination" {
            annotationView.image = UIImage(named: "destination")
        } else {
            annotationView.image = UIImage(named: "pizza pin")
        }
        
        annotationView.canShowCallout = true
        
        // Create cutome view for pin
        let paragraph = UILabel()
        paragraph.numberOfLines = 1
        paragraph.font = UIFont.preferredFont(forTextStyle: .caption1)
        paragraph.text = annotation.subtitle
        paragraph.adjustsFontSizeToFitWidth = true
        annotationView.detailCalloutAccessoryView = paragraph
        annotationView.leftCalloutAccessoryView = UIImageView(image: annotation.pizzaPhoto)
        annotationView.rightCalloutAccessoryView = UIButton(type: .infoLight)
        
        return annotationView
    }
    
    
}

// MARK: - Callout Accessory Delegate
extension ViewController {
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let vc = AnnotationDetailViewController(nibName: "AnnotationDetailViewController", bundle: nil)
        vc.annotation = view.annotation as? PizzaAnnotation
        present(vc, animated: true)
    }
}


// MARK: - Overlays
extension ViewController {
    
    func addPolylines() {
        let annotations = PizzaHistoryAnnotations().annotations
        
        let beverlyHills1 = annotations[4].coordinate
        let beverlyHills2 = annotations[1].coordinate
        let bhPolyline = MKPolyline(coordinates: [beverlyHills1, beverlyHills2], count: 2)
        bhPolyline.title = "BeverlyHills_Line"
        
        // Challenge
        var coordinates = [CLLocationCoordinate2D]()
        for location in annotations {
            coordinates.append(location.coordinate)
        }
        
        let grandTour = MKPolyline(coordinates: coordinates, count: coordinates.count)
        grandTour.title = "GrandTouch_Line"
        mapView.addOverlays([grandTour, bhPolyline])
    }
    
    func addDeliveryOverlay() {
        let radius = 100.0 // meters
        
        for location in mapView.annotations {
            let circle = MKCircle(center: location.coordinate, radius: radius)
            mapView.addOverlay(circle)
        }
    }
}

// MARK: - Overlays Delegates
extension ViewController {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if let polyline = overlay as? MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: polyline)
            
            if polyline.title == "GrandTouch_Line" {
                polylineRenderer.strokeColor = .orange
                polylineRenderer.lineWidth = 5.0
                polylineRenderer.lineDashPattern = [4, 2]
                return polylineRenderer
            }
            
            if polyline.title == "Directions" {
                polylineRenderer.strokeColor = .blue
                polylineRenderer.lineWidth = 3.0
                return polylineRenderer
            }
            
            polylineRenderer.lineWidth = 1
            polylineRenderer.lineCap = .round
            polylineRenderer.strokeColor = .green
            polylineRenderer.lineDashPattern = [10, 5]
            return polylineRenderer
        }
        
        if let circle = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(circle: circle)
            circleRenderer.fillColor = .orange.withAlphaComponent(0.1)
            circleRenderer.strokeColor = .orange
            circleRenderer.lineWidth = 1.0
            return circleRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}


// MARK: - CLLocationManager
extension ViewController {
    
    func setupCoreLocation() {
        
        switch CLLocationManager.authorizationStatus() {
            
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
           
        case .authorizedAlways:
            enableLocationServices()
            
        default:
            break
        }
    }
    
    func enableLocationServices() {
        DispatchQueue.global().async { [weak self] in
            
            guard let self = self else { return }
            
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                self.locationManager.startUpdatingLocation()
                DispatchQueue.main.async {
                    self.mapView.setUserTrackingMode(.follow, animated: true)
                }
            }
            
            // Add to check weather magentometer available or not.
            if CLLocationManager.headingAvailable() {
                self.locationManager.startUpdatingLocation()
            } else {
                print("heading not available")
            }
            self.monitorRegion(center: self.onRampCoordinate, radius: 100, id: "On ramp")
        }
    }
    
    func disableLocationServices() {
        locationManager.stopUpdatingLocation()
//        mapView.setUserTrackingMode(.none, animated: true)
    }
    
    
}

// MARK: - CLLocationManager Delegate
extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedAlways:
            print("Authorised")
            
        case .denied, .restricted:
            print("not authorised")
            
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.last!
        coordinate2D = currentLocation.coordinate
        
        // Get Speed
        let mphSpeedString = "\(currentLocation.speed * 2.23694) mph"
        let kphSpeedString = "\(currentLocation.speed * 3.6) kph"
        let headingString = " Heading: \(heading)"
        let courseString = "1. \(headingString)" + " at " + mphSpeedString + ".\n" + "2. \(headingString)" + " at " + kphSpeedString
        print(courseString)
        
        let displayString = "\(currentLocation.timestamp) Coord: \(coordinate2D) Alt: \(currentLocation.altitude)"
        print(displayString)
        updateMapRegion(rangeSpan: 200)
        
        let pizzaPin = PizzaAnnotation(coordinate: coordinate2D, title: displayString, subtitle: "")
        mapView.addAnnotation(pizzaPin)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        heading = newHeading.magneticHeading
    }
}


// MARK: - GeoFencing
extension ViewController {
    
    func monitorRegion(center: CLLocationCoordinate2D, radius: CLLocationDistance, id: String) {
        
        DispatchQueue.global().async {
            if CLLocationManager.authorizationStatus() == .authorizedAlways {
                if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
                    let region = CLCircularRegion(center: center, radius: radius, identifier: id)
                    region.notifyOnExit = true
                    region.notifyOnEntry = true
                    self.locationManager.startMonitoring(for: region)
                }
            }
        }
    }
}

// MARK: - GeoFencing Delegate
extension ViewController {
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        guard let circularRegion = region as? CLCircularRegion else {
            return
        }
        
        if circularRegion.identifier == "On ramp" {
            let alert = UIAlertController(title: "Pizza History", message: "You are on the ramp", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Dismiss", style: .default)
            alert.addAction(okayAction)
            present(alert, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
        guard let circularRegion = region as? CLCircularRegion else {
            return
        }
        
        if circularRegion.identifier == "On ramp" {
            let alert = UIAlertController(title: "Pizza History", message: "You are on the freeway", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Dismiss", style: .default)
            alert.addAction(okayAction)
            present(alert, animated: true)
        }
    }
}


// MARK: - GeoCoding
extension ViewController {
    
    func getCoordinate(address: String, _ completion: @escaping (CLLocationCoordinate2D?, String, Error?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            
            guard error == nil else {
                completion(nil, "", error)
                return
            }
            
            guard let placemark = placemarks?.first,
                  let coordiate = placemark.location?.coordinate else {
                completion(nil, "", error)
                return
            }
            
            let location = (placemark.locality ?? "empty locality") + " " + (placemark.isoCountryCode ?? "empty iso code")
            completion(coordiate, location, nil)
        }
    }
}


// MARK: - Direction
extension ViewController {
    
    func findDirection(start: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        
        let startMapItem = MKMapItem(placemark: MKPlacemark(coordinate: start))
        let destinationMapItem = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        
        let request = MKDirections.Request()
        request.source = startMapItem
        request.destination = destinationMapItem
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            
            if let error = error as? MKError {
                print("Error in find route: \(error.errorCode) -> \(error.localizedDescription)")
                return
            }
            
            if let response = response {
                let routes = response.routes
                print("\(routes.count) routes")
                for route in routes {
                    let polyline = route.polyline
                    polyline.title = "Directions"
                    self.mapView.addOverlay(polyline)
                }
                
                let destination = response.destination.placemark.coordinate
                let route = routes.first!
                var routeDestination = route.name + "\(route.expectedTravelTime/60.0) min \(route.distance / 1609.344) miles\n"
                let annotation = PizzaAnnotation(coordinate: destination, title: "Destination", subtitle: routeDestination)
                
                for routeSteps in route.steps {
                    routeDestination += routeSteps.instructions + ". Go \(routeSteps.distance / 1609.344) miles\n\n"
                }
                annotation.historyText = routeDestination
                self.mapView.addAnnotation(annotation)
            }
        }
    }
}
