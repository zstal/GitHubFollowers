import UIKit

class GFEmptyStateView: UIView {

    let messageLabel: GFTitleLabel = {
        let label = GFTitleLabel(textAlignment: .center, fontSize: 28.0)
        label.numberOfLines = 3
        label.textColor = .secondaryLabel
        return label
    }()

    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: Images.emptyStateLogo)
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(message: String) {
        self.init(frame: .zero)
        messageLabel.text = message
    }

    private func configure() {
        [messageLabel, logoImageView].forEach(addSubview(_:))

        let messageLabelConstant: CGFloat
        if DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed {
            messageLabelConstant = -95.0
        } else {
            messageLabelConstant = -150.0
        }

        let logoImageViewConstant: CGFloat
        if DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed {
            logoImageViewConstant = 80.0
        } else {
            logoImageViewConstant = 40.0
        }

        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor,
                                                  constant: messageLabelConstant),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40.0),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40.0),
            messageLabel.heightAnchor.constraint(equalToConstant: 200.0),

            logoImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            logoImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            logoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 170.0),
            logoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                  constant: logoImageViewConstant),
        ])
    }
}
