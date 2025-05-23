import Foundation

class WeatherViewModel: ObservableObject {
    @Published var weather: WeatherResponse?
    @Published var errorMessage: String?

    func fetchWeather(lat: Double, lon: Double) {
        guard let url = URL(string:
            "https://api.weatherapi.com/v1/current.json?key=99ddf71d9cf44a07a1d101233252305&q=\(lat),\(lon)&lang=fr")
        else {
            self.errorMessage = "URL invalide"
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Erreur réseau : \(error.localizedDescription)"
                    return
                }

                guard let data = data else {
                    self.errorMessage = "Aucune donnée reçue"
                    return
                }

                do {
                    let decoded = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    self.weather = decoded
                    self.errorMessage = nil
                } catch {
                    self.errorMessage = "Erreur de décodage : \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}
