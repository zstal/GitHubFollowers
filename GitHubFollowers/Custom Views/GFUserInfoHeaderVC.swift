import UIKit

class GFUserInfoHeaderVC: UIViewController {

    let avatarImageView = GFAvatarImageView(frame: .zero)
    let usernameLabel = GFTitleLabel(textAlignment: .left, fontSize: 34.0)
    let nameLabel = GFSecondaryTitleLabel(fontSize: 18.0)
    let locationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: SFSymbols.location)
        imageView.tintColor = .secondaryLabel
        return imageView
    }()
    let locationLabel = GFSecondaryTitleLabel(fontSize: 18.0)
    let bioLabel: GFBodyLabel = {
        let label = GFBodyLabel(textAlignment: .left)
        label.numberOfLines = 3
        return label
    }()

    var user: User

    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        [avatarImageView, usernameLabel, nameLabel, locationImageView, locationLabel, bioLabel]
            .forEach(view.addSubview(_:))
        setLayout()
        configureUI()
    }

    private func configureUI() {
        avatarImageView.download(fromURL: user.avatarUrl)
        usernameLabel.text = user.login
        nameLabel.text = user.name ?? ""
        locationLabel.text = user.location ?? "N/A".l10n
        bioLabel.text = user.bio ?? ""
    }

    private func setLayout() {
        let textImagePadding: CGFloat = 12.0

        // TODO: use stack view to simplify things
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20.0),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 90.0),
            avatarImageView.heightAnchor.constraint(equalToConstant: 90.0),

            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor,
                                                   constant: textImagePadding),
            usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            usernameLabel.heightAnchor.constraint(equalToConstant: 38.0),

            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor,
                                               constant: 8.0),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor,
                                               constant: textImagePadding),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 20.0),

            locationImageView.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            locationImageView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor,
                                                       constant: textImagePadding),
            locationImageView.widthAnchor.constraint(equalToConstant: 20.0),
            locationImageView.heightAnchor.constraint(equalToConstant: 20.0),

            locationLabel.centerYAnchor.constraint(equalTo: locationImageView.centerYAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: locationImageView.trailingAnchor,
                                                   constant: 5.0),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            locationLabel.heightAnchor.constraint(equalToConstant: 20.0),

            bioLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor,
                                          constant: textImagePadding),
            bioLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            bioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bioLabel.heightAnchor.constraint(equalToConstant: 90.0),
        ])
    }
}
