import UIKit

protocol PropertiesListViewModel {
    var list: PropertiesList? { get }
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> ())
    func fetchPropertiesList(completion: @escaping (PropertiesList?, String?) -> ())
}

class PropertiesListViewModelImpl: PropertiesListViewModel {
    let service: PropertiesService
    var list: PropertiesList?

    init(service: PropertiesService = PropertiesServiceImpl()) {
        self.service = service
    }

    func fetchPropertiesList(completion: @escaping (PropertiesList?, String?) -> ()) {
        service.fetchPropertiesList(completion: { result in
            switch result {
            case .success(let list):
                self.list = list
                completion(self.list, nil)
            case .failure(let error): completion(nil, error.localizedDescription)
            }
        })
    }

    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> ()) {
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                completion(UIImage(data: data))
            }
            catch { completion(nil) }
        }
    }
}
