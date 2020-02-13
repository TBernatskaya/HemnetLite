import UIKit

class AreaCell: UICollectionViewCell {

    lazy var imageView: UIImageView = {
        let image = UIImage(named: "default-placeholder")
        let imageView = UIImageView(image: image, highlightedImage: nil)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.title, self.imageView, self.area, self.rating, self.price])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 4
        return stackView
    }()

    lazy var title: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()

    lazy var area: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()

    lazy var rating: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()

    lazy var price: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
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

    override func prepareForReuse() {
        super.prepareForReuse()
        title.text = nil
        area.text = nil
        price.text = nil
        rating.text = nil
        imageView.image = nil
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
