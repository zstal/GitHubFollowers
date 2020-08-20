import UIKit

class GFAlertVC: UIViewController {

    let containerView = GFAlertContainerView()
    let titleLabel = GFTitleLabel(textAlignment: .center, fontSize: 20.0)
    let messageLabel = GFBodyLabel(textAlignment: .center)
    let actionButton = GFButton(backgroundColor: .systemPink,
                                title: "OK".l10n)

    var alertTitle: String?
    var message: String?
    var buttonTitle: String?

    let padding: CGFloat = 20.0

    init(title: String, message: String, buttonTitle: String) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = title
        self.message = message
        self.buttonTitle = buttonTitle
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        configureContainerView()
        configureTitleLabel()
        configureActionButton()
        configureBodyLabel()
    }

    private func configureContainerView() {
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280.0),
            containerView.heightAnchor.constraint(equalToConstant: 220.0),
        ])
    }

    private func configureTitleLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.text = alertTitle ?? "Something went wrong".l10n

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,
                                                constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                                 constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28.0),
        ])
    }

    private func configureActionButton() {
        containerView.addSubview(actionButton)
        actionButton.setTitle(buttonTitle ?? "OK".l10n, for: .normal)
        actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)

        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,
                                                 constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,
                                                  constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                                   constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44.0),
        ])
    }

    private func configureBodyLabel() {
        containerView.addSubview(messageLabel)
        messageLabel.text = message ?? "Unable to complete request".l10n
        messageLabel.numberOfLines = 4

        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,
                                                  constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                                  constant: -padding),
            messageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -8.0),
        ])
    }

    @objc private func dismissVC() {
        dismiss(animated: true)
    }
}
