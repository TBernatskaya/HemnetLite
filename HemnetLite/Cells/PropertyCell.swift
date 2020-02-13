import UIKit

class PropertyCell: UICollectionViewCell {

    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.imageView,
                                                       self.streetAddress,
                                                       self.area,
                                                       self.price
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 4
        return stackView
    }()

    lazy var imageView: UIImageView = {
        let image = UIImage(named: "default-placeholder")
        let imageView = UIImageView(image: image, highlightedImage: nil)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    lazy var streetAddress: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()

    lazy var area: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .black
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()

    lazy var price: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .black
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()

    static var reuseIdentifier: String {
        return String(describing: self)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(stackView)
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setImageBorder() {
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.yellow.cgColor
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        streetAddress.text = nil
        area.text = nil
        price.text = nil
        imageView.image = UIImage(named: "default-placeholder")
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5)
        ])
    }
}
