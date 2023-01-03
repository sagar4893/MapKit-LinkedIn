import UIKit
import MapKit

class AnnotationDetailViewController: UIViewController {
    
    var annotation:PizzaAnnotation!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pizzaPhoto: UIImageView!
    @IBOutlet weak var historyText: UITextView!
    
    @IBAction func done(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = annotation.title ?? annotation.subtitle
        pizzaPhoto.image = annotation.pizzaPhoto
        historyText.text = annotation.historyText
        
        // Call method to get location placemark
        getAddressByGeocode()
    }
}


// MARK: - Geocoder (Reverse Engineering to Get address from the location coordinate)
extension AnnotationDetailViewController {
    
    func getAddressByGeocode() {
        
        placemark(annotation: annotation) { placemark in
            
            if let placemark = placemark {
                var location = ""
                
                if let city = placemark.locality {
                    location += city + " "
                }
                
                if let state = placemark.administrativeArea {
                    location += state + " "
                }
                
                if let country = placemark.country {
                    location += country
                }
                self.historyText.text = location + "\n\n" + (self.annotation.historyText ?? "Empty Value")
            }
        }
    }
    
    func placemark(annotation: PizzaAnnotation, completion: @escaping (CLPlacemark?) -> Void) {
        let coordinate = annotation.coordinate
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { placemarks, error in
            
            guard error == nil, placemarks != nil, placemarks!.count > 0 else {
                completion(nil)
                return
            }
            
            if let placemark = placemarks?.first {
                completion(placemark)
            }
        }
    }
}
