import Foundation

/// Modèle représentant la réponse de l’API météo.
/// Structure principale qui contient les informations de localisation et les données météo actuelles.
struct WeatherResponse: Codable {
    let location: Location   // Informations sur la localisation
    let current: Current     // Données météo actuelles
}

/// Informations sur la localisation géographique.
struct Location: Codable {
    let name: String       // Nom de la ville ou du lieu
    let country: String    // Pays associé à la localisation
}

/// Données météo actuelles.
struct Current: Codable {
    let temp_c: Double       // Température en degrés Celsius
    let condition: Condition // Condition météo détaillée (texte + icône)
}

/// Description de la condition météo.
struct Condition: Codable {
    let text: String    // Description textuelle de la météo (ex : "Ensoleillé", "Nuageux")
    let icon: String    // URL partielle de l’icône météo (ex : "//cdn.weatherapi.com/...")
}
