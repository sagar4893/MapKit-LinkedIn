//
//  PizzaAnnotation.swift
//  PizzaHistoryMapKit
//
//  Created by Sagar Chauhan on 14/12/22.
//

import Foundation
import MapKit

class PizzaAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var identifier = "Pin"
    var historyText: String? = ""
    var pizzaPhoto: UIImage?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}
