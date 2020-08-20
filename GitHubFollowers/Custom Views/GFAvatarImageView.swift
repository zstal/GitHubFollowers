import UIKit

class GFAvatarImageView: UIImageView {

    static let placeholderImage = UIImage(named: Images.avatarPlaceholder)
    let cache = NetworkManager.shared.cache

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 10.0
        clipsToBounds = true
        resetImage()
    }

    func resetImage() {
        image = Self.placeholderImage
    }

    func download(fromURL url: String) {
        NetworkManager.shared.downloadImage(from: url) { [weak self] image in
            guard let self = self, let image = image else { return }
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}
