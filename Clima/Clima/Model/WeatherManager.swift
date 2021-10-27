//
//  WeatherManager.swift
//  Clima
//
//  Created by Gilmar Junior on 19/10/21.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager,weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?"
    let yourKey = "{COLOCAR KEY DA API AQUI}}"
    let units = "metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)appid=\(yourKey)&units=\(units)&q=\(cityName)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func fetWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees ) {
        let urlString = "\(weatherURL)appid=\(yourKey)&units=\(units)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    
    func performRequest(with urlString: String) {
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather =  self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decoderData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decoderData.weather[0].id
            let temp = decoderData.main.temp
            let name = decoderData.name
            let weather = WeatherModel(conditionID: id, cityName: name, temperature: temp)
            
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
    
    
    
    
}

