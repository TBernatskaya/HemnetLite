import UIKit

class PropertiesListViewController: UIViewController {

    var viewModel: PropertiesListViewModel

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PropertyCell.self, forCellWithReuseIdentifier: PropertyCell.reuseIdentifier)
        collectionView.register(AreaCell.self, forCellWithReuseIdentifier: AreaCell.reuseIdentifier)
        return collectionView
    }()


    init(viewModel: PropertiesListViewModel = PropertiesListViewModelImpl()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self

        updateConstraints()
        updateList()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        let flowLayout = collectionView.collectionViewLayout
        flowLayout.invalidateLayout()
    }

    private func updateConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60)
        ])
    }

    private func updateList() {
        // TODO: add loading indicator
        viewModel.fetchPropertiesList(completion: { list, errorMessage in
            if let _ = list {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } else {
                self.presentAlert(with: errorMessage)
            }
        })
    }

    private func presentAlert(with title: String?) {
        let title = title ?? "Unknown error"
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        alert.addAction(.init(title: "OK", style: .cancel, handler: nil))

        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }

    private func downloadImage(from url: URL, completion: @escaping (UIImage?) -> ()) {
        do {
            let data = try Data(contentsOf: url)
            completion(UIImage(data: data))
        }
        catch { completion(nil) }
    }
}

extension PropertiesListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard let list = viewModel.list else { return 0 }
        return list.items.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let list = viewModel.list else { return UICollectionViewCell() }

        let item = list.items[indexPath.row]
        switch item.type {
        case .area:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: AreaCell.reuseIdentifier,
                for: indexPath
            ) as! AreaCell
            downloadImage(from: item.image, completion: { cell.imageView.image = $0 })
            cell.title.text = "Område"
            cell.area.text = item.area
            return cell

        case .highlighted:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PropertyCell.reuseIdentifier,
                for: indexPath
            ) as! PropertyCell
            downloadImage(from: item.image, completion: { cell.imageView.image = $0 })
            cell.title.text = item.streetAddress
            cell.area.text = item.area
            cell.price.text = item.averagePrice
            cell.layer.borderWidth = 2
            cell.layer.borderColor = UIColor.yellow.cgColor
            return cell

        case .property:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PropertyCell.reuseIdentifier,
                for: indexPath
            ) as! PropertyCell
            downloadImage(from: item.image, completion: { cell.imageView.image = $0 })
            cell.title.text = item.streetAddress
            cell.area.text = item.area
            cell.price.text = item.averagePrice
            return cell
        }
    }
}

extension PropertiesListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 230)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
