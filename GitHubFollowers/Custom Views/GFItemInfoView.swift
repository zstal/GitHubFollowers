import UIKit

enum ItemInfoType {
    case followers
    case following
    case gists
    case repos
}

class GFItemInfoView: UIView {

    let symbolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .label
        return imageView
    }()
    let titleLabel = GFTitleLabel(textAlignment: .left, fontSize: 14.0)
    let countLabel = GFTitleLabel(textAlignment: .center, fontSize: 14.0)

    convenience init(itemInfoType: ItemInfoType, count: Int) {
        self.init(frame: .zero)
        set(itemInfoType: itemInfoType, count: count)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        [symbolImageView, titleLabel, countLabel].forEach(addSubview(_:))

        NSLayoutConstraint.activate([
            symbolImageView.topAnchor.constraint(equalTo: self.topAnchor),
            symbolImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            symbolImageView.widthAnchor.constraint(equalToConstant: 20.0),
            symbolImageView.heightAnchor.constraint(equalToConstant: 20.0),

            titleLabel.centerYAnchor.constraint(equalTo: symbolImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor,
                                                constant: 12.0),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 18.0),

            countLabel.topAnchor.constraint(equalTo: symbolImageView.bottomAnchor, constant: 4.0),
            countLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            countLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            countLabel.heightAnchor.constraint(equalToConstant: 18.0),
        ])
    }

    func set(itemInfoType: ItemInfoType, count: Int) {
        switch itemInfoType {
        case .repos:
            symbolImageView.image = UIImage(systemName: SFSymbols.repos)
            titleLabel.text = "Public Repos".l10n
        case .gists:
            symbolImageView.image = UIImage(systemName: SFSymbols.gists)
            titleLabel.text = "Public Gists".l10n
        case .followers:
            symbolImageView.image = UIImage(systemName: SFSymbols.followers)
            titleLabel.text = "Followers".l10n
        case .following:
            symbolImageView.image = UIImage(systemName: SFSymbols.following)
            titleLabel.text = "Following".l10n
        }
        countLabel.text = String(count)
    }
}
