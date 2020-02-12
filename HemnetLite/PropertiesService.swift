import Foundation

protocol PropertiesService {
    func fetchPropertiesList(completion: @escaping (Result<PropertiesList, Error>) -> ())
}

class PropertiesServiceImpl: PropertiesService {
    func fetchPropertiesList(completion: @escaping (Result<PropertiesList, Error>) -> ()) {
        let url = URL(string: Route.propertiesList.rawValue)!
        fetchAndDecode(url: url, completion: completion)
    }

    private enum Route: String {
        case propertiesList = "https://pastebin.com/raw/eXqnGgCY"
    }

    private func fetchAndDecode<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> ()) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                error == nil,
                let response = response as? HTTPURLResponse, response.statusCode == 200,
                let data = data
            else {
                return completion(.failure(error!))
            }
            do {
                let decoder = JSONDecoder()
                let model = try decoder.decode(T.self, from: data)
                completion(.success(model))
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
