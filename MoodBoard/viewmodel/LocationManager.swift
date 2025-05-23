import CoreLocation
import Combine

/// Gestionnaire de localisation qui récupère la position actuelle de l’utilisateur.
/// Implémente `CLLocationManagerDelegate` et publie les mises à jour via Combine.
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    /// La localisation actuelle de l’utilisateur (nil si non disponible).
    @Published var location: CLLocation?
    
    /// Indique si l’autorisation d’accès à la localisation a été refusée par l’utilisateur.
    @Published var permissionDenied = false

    /// Initialisation : configure le gestionnaire de localisation,
    /// demande l’autorisation d’accès "lors de l’utilisation" et commence à suivre la localisation.
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters // précision ~100m
        manager.requestWhenInUseAuthorization()                   // demande l’autorisation
        manager.startUpdatingLocation()                           // démarre la mise à jour de la localisation
    }

    /// Délégué appelé lorsque de nouvelles localisations sont disponibles.
    /// Met à jour la propriété `location` avec la première localisation reçue.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first
    }

    /// Délégué appelé quand l’autorisation d’accès à la localisation change.
    /// Met à jour `permissionDenied` si l’utilisateur a refusé l’accès.
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .denied {
            permissionDenied = true
        }
    }
}
