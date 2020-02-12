import Foundation

protocol PropertiesListViewModel {
    func fetchPropertiesList(completion: @escaping (PropertiesList?, String?) -> ())
}

class PropertiesListViewModelImpl: PropertiesListViewModel {
    let service: PropertiesService

    init(service: PropertiesService = PropertiesServiceImpl()) {
        self.service = service
    }

    func fetchPropertiesList(completion: @escaping (PropertiesList?, String?) -> ()) {
        service.fetchPropertiesList(completion: { result in
            switch result {
            case .success(let list): completion(list, nil)
            case .failure(let error): completion(nil, error.localizedDescription)
            }
        })
    }
}
