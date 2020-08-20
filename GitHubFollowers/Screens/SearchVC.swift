import UIKit

class SearchVC: UIViewController {

    let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: Images.ghLogo))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let usernameTextField = GFTextField()
    let callToActionButton = GFButton(backgroundColor: .systemGreen, title: "Get followers".l10n)

    override func viewDidLoad() {
        super.viewDidLoad()
        // White for light mode, black for dark mode
        view.backgroundColor = .systemBackground
        configureLogoImageView()
        configureTextField()
        configureCallToActionButton()
        createDismissKeyboardTapGesture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        usernameTextField.text = ""
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    func createDismissKeyboardTapGesture() {
        let tapRecognizer = UITapGestureRecognizer(target: view,
                                                   action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tapRecognizer)
    }

    @objc func pushFollowerListVC() {
        guard let username = usernameTextField.text, !username.isEmpty else {
            let message = "Please enter a username. We need to know who to look for. 😀"
            presentGFAlertOnMainThread(title: "Empty Username".l10n,
                                       message: message.l10n,
                                       buttonTitle: "OK".l10n)
            return
        }

        usernameTextField.resignFirstResponder()

        let followerListVC = FollowerListVC(username: username)
        navigationController?.pushViewController(followerListVC, animated: true)
    }

    func configureLogoImageView() {
        let topConstraintConstant: CGFloat
        if DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed {
            topConstraintConstant = 20.0
        } else {
            topConstraintConstant = 80.0
        }
        view.addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                               constant: topConstraintConstant),
            logoImageView.widthAnchor.constraint(equalToConstant: 200.0),
            logoImageView.heightAnchor.constraint(equalToConstant: 200.0),
        ])
    }

    func configureTextField() {
        usernameTextField.delegate = self
        view.addSubview(usernameTextField)

        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor,
                                                   constant: 48.0),
            usernameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                       constant: 50.0),
            usernameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                        constant: -50.0),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50.0),
        ])
    }

    func configureCallToActionButton() {
        callToActionButton.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside)
        view.addSubview(callToActionButton)
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor,
                                                       constant: -50.0),
            callToActionButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,
                                                        constant: 50.0),
            callToActionButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,
                                                         constant: -50.0),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50.0),
        ])
    }
}

extension SearchVC: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowerListVC()
        return true
    }
}
