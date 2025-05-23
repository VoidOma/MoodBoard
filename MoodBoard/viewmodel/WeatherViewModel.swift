import Foundation

/// ViewModel responsable de la récupération et gestion des données météo.
/// Utilise l’API WeatherAPI pour obtenir la météo actuelle selon des coordonnées GPS.
class WeatherViewModel: ObservableObject {
    /// Données météo reçues de l’API, mises à jour pour la vue.
    @Published var weather: WeatherResponse?
    
    /// Message d’erreur en cas de problème lors de la récupération ou du décodage.
    @Published var errorMessage: String?

    /// Récupère la météo actuelle pour une latitude et longitude données.
    /// - Parameters:
    ///   - lat: Latitude
    ///   - lon: Longitude
    func fetchWeather(lat: Double, lon: Double) {
        // Construction de l’URL avec la clé API et la position
        guard let url = URL(string:
            "https://api.weatherapi.com/v1/current.json?key=99ddf71d9cf44a07a1d101233252305&q=\(lat),\(lon)&lang=fr")
        else {
            self.errorMessage = "URL invalide"
            return
        }

        // Lancement de la requête réseau
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Tout ce qui touche à l’interface doit être mis sur le thread principal
            DispatchQueue.main.async {
                if let error = error {
                    // Erreur réseau détectée
                    self.errorMessage = "Erreur réseau : \(error.localizedDescription)"
                    return
                }

                guard let data = data else {
                    // Pas de données reçues
                    self.errorMessage = "Aucune donnée reçue"
                    return
                }

                do {
                    // Décodage JSON en modèle WeatherResponse
                    let decoded = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    self.weather = decoded
                    self.errorMessage = nil
                } catch {
                    // Problème lors du décodage des données JSON
                    self.errorMessage = "Erreur de décodage : \(error.localizedDescription)"
                }
            }
        }.resume() // Démarre la tâche réseau
    }
}
