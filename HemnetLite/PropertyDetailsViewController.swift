import UIKit

class PropertyDetailsViewController: UIViewController {
    var property: Property

    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.streetAddress,
                                                       self.area,
                                                       self.municipality,
                                                       self.rating,
                                                       self.askingPrice,
                                                       self.averagePrice,
                                                       self.monthlyFee,
                                                       self.daysOnHemnet,
                                                       self.livingArea,
                                                       self.numberOfRooms
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.contentMode = .topLeft
        stackView.spacing = 4
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return stackView
    }()

    lazy var streetAddress: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .semibold)
        label.textColor = .black
        return label
    }()

    lazy var area: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        return label
    }()

    lazy var municipality: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        return label
    }()

    lazy var rating: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        return label
    }()

    lazy var askingPrice: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()

    lazy var averagePrice: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()

    lazy var monthlyFee: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()

    lazy var daysOnHemnet: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()

    lazy var livingArea: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        return label
    }()

    lazy var numberOfRooms: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        return label
    }()

    init(property: Property) {
        self.property = property
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = property.streetAddress
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        updateView()
        setupConstraints()
    }

    private func setupConstraints() {
        let topPadding: CGFloat = 60

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: topPadding),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -topPadding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stackView.heightAnchor.constraint(equalToConstant: view.frame.height - topPadding),
            stackView.widthAnchor.constraint(equalToConstant: view.frame.width)
        ])
    }

    private func updateView() {
        streetAddress.text = property.streetAddress
        area.text = property.area
        municipality.text = property.municipality
        property.rating.map { rating.text = "Betyg: " + $0 }
        property.askingPrice.map { askingPrice.text = "Pris: " + $0 }
        property.averagePrice.map { averagePrice.text = "Snittpris: " + $0 }
        property.monthlyFee.map { monthlyFee.text = "Avgift: " + $0 }
        property.daysOnHemnet.map { daysOnHemnet.text = "Objektet publicerades för " + String(describing: $0) + " dagar sedan" }
        property.livingArea.map { livingArea.text = "Boarea: " + String(describing: $0) }
        property.numberOfRooms.map { numberOfRooms.text = "Antal rum: " + String(describing: $0) }
    }
}
