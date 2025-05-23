//import SwiftUI
//import CoreLocation
//
//struct ContentView: View {
//    @StateObject private var viewModel = WeatherViewModel()
//    @StateObject private var locationManager = LocationManager()
//
//    var body: some View {
//        VStack(spacing: 16) {
//            Text("☀️ Météo actuelle")
//                .font(.title)
//                .padding(.top)
//
//            if let weather = viewModel.weather {
//                VStack(spacing: 8) {
//                    Text("\(weather.location.name), \(weather.location.country)")
//                        .font(.headline)
//
//                    Text("\(weather.current.temp_c, specifier: "%.1f")°C")
//                        .font(.largeTitle)
//
//                    Text(weather.current.condition.text)
//                        .italic()
//
//                    AsyncImage(url: URL(string: "https:\(weather.current.condition.icon)")) { image in
//                        image.resizable()
//                            .frame(width: 80, height: 80)
//                    } placeholder: {
//                        ProgressView()
//                    }
//                }
//                .padding()
//            } else if let error = viewModel.errorMessage {
//                Text("❌ \(error)")
//                    .foregroundColor(.red)
//                    .padding()
//            } else {
//                Text("📍 En attente de la position GPS...")
//                    .foregroundColor(.gray)
//                    .padding()
//            }
//
//            Button(action: {
//                if let loc = locationManager.location {
//                    viewModel.fetchWeather(lat: loc.coordinate.latitude,
//                                           lon: loc.coordinate.longitude)
//                } else {
//                    viewModel.errorMessage = "Position non disponible"
//                }
//            }) {
//                Label("Recharger météo actuelle", systemImage: "location.circle")
//            }
//            .padding()
//        }
//        .onChange(of: locationManager.location) { newLocation in
//            if let loc = newLocation {
//                viewModel.fetchWeather(lat: loc.coordinate.latitude,
//                                       lon: loc.coordinate.longitude)
//            }
//        }
//    }
//}
