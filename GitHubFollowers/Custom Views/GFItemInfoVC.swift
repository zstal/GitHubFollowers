import UIKit

protocol GFItemInfoVCDelegate: class {
    func didInitiateAction(itemInfoVC: GFItemInfoVC, for user: User)
}

class GFItemInfoVC: UIViewController {

    var user: User!
    weak var delegate: GFItemInfoVCDelegate?

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    let itemInfoView1 = GFItemInfoView()
    let itemInfoView2 = GFItemInfoView()
    let actionButton = GFButton()

    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setLayout()
    }

    private func configure() {
        view.layer.cornerRadius = 18.0
        view.backgroundColor = .secondarySystemBackground
        actionButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }

    private func setLayout() {
        [itemInfoView1, itemInfoView2].forEach(stackView.addArrangedSubview(_:))
        [stackView, actionButton].forEach(view.addSubview(_:))

        let padding: CGFloat = 20.0

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            stackView.heightAnchor.constraint(equalToConstant: 50.0),

            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44.0),
        ])
    }

    @objc private func didTapButton() {
        delegate?.didInitiateAction(itemInfoVC: self, for: user)
    }
}
