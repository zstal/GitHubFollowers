import UIKit

class FollowerListVC: GFDataLoadingVC {

    enum Section {
        case main
    }

    var username: String!

    private var followers = [Follower]()
    private var filteredFollowers = [Follower]()
    private var isViewingFiltered = false

    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!

    private var currentPage = 1
    private var hasMoreFollowers = true
    private var isLoadingMoreFollowers = false

    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
        title = username
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
        configureCollectionView()
        getFollowers(page: currentPage)
        configureDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(addToFavorites))
        navigationItem.rightBarButtonItem = addButton
    }

    private func configureCollectionView() {
        let layout = UIHelper.createThreeColumnFlowLayout(in: view)
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
        collectionView.delegate = self
    }

    private func getFollowers(page: Int) {
        isLoadingMoreFollowers = true
        showLoadingView()
        NetworkManager.shared.getFollowers(for: username, page: page)
        { [weak self] (result: Result<[Follower], GFError>) in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.dismissLoadingView()
            }

            switch result {
            case .success(let newFollowers):
                self.updateUI(with: newFollowers)

            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Error".l10n,
                                                message: error.rawValue.l10n,
                                                buttonTitle: "OK".l10n)
            }

            DispatchQueue.main.async {
                self.isLoadingMoreFollowers = false
            }
        }
    }

    private func updateUI(with newFollowers: [Follower]) {
        hasMoreFollowers = (newFollowers.count == 100)
        followers.append(contentsOf: newFollowers)

        if followers.isEmpty {
            DispatchQueue.main.async {
                let message = "This user doesn't have any followers.\nGo follow them. 💫"
                self.showEmptyStateView(with: message.l10n, in: self.view)
            }
        }
        updateCollectionDataSource(with: self.followers)
    }

    private func configureDataSource() {
        let provider: (UICollectionView, IndexPath, Follower) -> UICollectionViewCell? =
        { collectionView, indexPath, follower in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID,
                                                          for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        }
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView,
                                                                           cellProvider: provider)
    }

    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Filter user list".l10n
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }

    private func updateCollectionDataSource(with updatedFollowers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(updatedFollowers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }

    @objc private func addToFavorites() {
        showLoadingView()

        NetworkManager.shared.getUserInfo(for: username)
        { [weak self] (result: Result<User, GFError>) in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.dismissLoadingView()
            }

            switch result {
            case .success(let user):
                self.addUserToFavorites(user)

            case .failure:
                let message = "An error occurred during the network request."
                self.presentGFAlertOnMainThread(title: "Something went wrong.".l10n,
                                                message: message.l10n,
                                                buttonTitle: "OK".l10n)
            }
        }
    }

    private func addUserToFavorites(_ user: User) {
        let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
        PersistenceManager.update(with: favorite, actionType: .add) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.presentGFAlertOnMainThread(title: "Error".l10n,
                                                message: error.rawValue.l10n,
                                                buttonTitle: "OK".l10n)
                return
            }
            let message = "✅ Successfully added the user to favorites."
            self.presentGFAlertOnMainThread(title: "Success!".l10n,
                                            message: message.l10n,
                                            buttonTitle: "Hooray 🎉".l10n)
        }
    }
}

//
// MARK: - UICollectionViewDelegate
//
extension FollowerListVC: UICollectionViewDelegate {

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        // we've scrolled to the last page
        if offsetY > (contentHeight - height) {
            guard hasMoreFollowers, !isLoadingMoreFollowers else { return }
            // fetch next page of followers
            currentPage += 1
            getFollowers(page: currentPage)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeCollection = isViewingFiltered ? filteredFollowers : followers
        let selectedFollower = activeCollection[indexPath.item]
        let destinationVC = UserInfoVC()
        destinationVC.delegate = self
        destinationVC.username = selectedFollower.login
        let navigationController = UINavigationController(rootViewController: destinationVC)
        present(navigationController, animated: true)
    }
}

//
// MARK: - UISearchResultsUpdating
//
extension FollowerListVC: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            updateCollectionDataSource(with: self.followers)
            isViewingFiltered = false
            return
        }
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateCollectionDataSource(with: filteredFollowers)
        isViewingFiltered = true
    }
}

//
// MARK: - UserInfoVCDelegate
//
extension FollowerListVC: UserInfoVCDelegate {

    func didRequestFollowers(for username: String) {
        navigationItem.searchController?.isActive = false
        self.username = username
        title = username
        currentPage = 1
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        getFollowers(page: currentPage)
    }
}
