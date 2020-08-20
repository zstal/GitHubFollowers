import UIKit

protocol UserInfoVCDelegate: class {
    func didRequestFollowers(for username: String)
}

class UserInfoVC: GFDataLoadingVC {

    weak var delegate: UserInfoVCDelegate?

    var username: String!
    let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let itemView1: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let itemView2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let dateLabel = GFBodyLabel(textAlignment: .center)

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    lazy var itemViews = [headerView, itemView1, itemView2, dateLabel]

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureScrollView()
        setLayout()
        getUserInfo()
    }

    private func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }

    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 600.0),
        ])
    }

    private func setLayout() {
        let padding: CGFloat = 20.0

        for itemView in itemViews {
            contentView.addSubview(itemView)
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                  constant: padding),
                itemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                   constant: -padding),
            ])
        }

        // TODO: use stack view to simplify things
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 210.0),

            itemView1.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemView1.heightAnchor.constraint(equalToConstant: 140.0),

            itemView2.topAnchor.constraint(equalTo: itemView1.bottomAnchor, constant: padding),
            itemView2.heightAnchor.constraint(equalToConstant: 140.0),

            dateLabel.topAnchor.constraint(equalTo: itemView2.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 50.0),
        ])
    }

    private func getUserInfo() {
        showLoadingView()
        NetworkManager.shared.getUserInfo(for: username)
        { [weak self] (result: Result<User, GFError>) in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.dismissLoadingView()
            }

            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.configureUI(with: user)
                }

            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Error".l10n,
                                                message: error.rawValue.l10n,
                                                buttonTitle: "OK".l10n)
            }

        }
    }

    private func configureUI(with user: User) {
        let userInfoHeaderVC = GFUserInfoHeaderVC(user: user)
        self.add(childVC: userInfoHeaderVC, to: self.headerView)

        let repoItemVC = GFRepoItemVC(user: user)
        repoItemVC.delegate = self
        self.add(childVC: repoItemVC, to: self.itemView1)

        let followerItemVC = GFFollowerItemVC(user: user)
        followerItemVC.delegate = self
        self.add(childVC: followerItemVC, to: self.itemView2)

        let labelStart = "Member since".l10n
        self.dateLabel.text = "\(labelStart) \(user.createdAt.convertToMonthYearFormat())"
    }

    private func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        childVC.view.frame = containerView.bounds
        containerView.addSubview(childVC.view)
        childVC.didMove(toParent: self)
    }

    @objc private func dismissVC() {
        dismiss(animated: true)
    }

    private func showProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            presentGFAlertOnMainThread(title: "Invalid URL attached to user.".l10n,
                                       message: "Unable to show profile.".l10n,
                                       buttonTitle: "OK".l10n)
            return
        }
        presentSafariVC(with: url)
    }

    private func showFollowers(for user: User) {
        guard user.followers > 0 else {
            presentGFAlertOnMainThread(title: "No followers.".l10n,
                                       message: "This user has no followers. 😕".l10n,
                                       buttonTitle: "OK".l10n)
            return
        }
        delegate?.didRequestFollowers(for: user.login)
        dismissVC()
    }
}

//
// MARK: - GFItemInfoVCDelegate
//
extension UserInfoVC: GFItemInfoVCDelegate {

    func didInitiateAction(itemInfoVC: GFItemInfoVC, for user: User) {
        if itemInfoVC.isKind(of: GFRepoItemVC.self) {
            showProfile(for: user)
        } else if itemInfoVC.isKind(of: GFFollowerItemVC.self) {
            showFollowers(for: user)
        }
    }
}
