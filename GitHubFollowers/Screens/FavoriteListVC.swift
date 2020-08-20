import UIKit

class FavoriteListVC: GFDataLoadingVC {

    private var favorites = [Follower]()
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
        tableView.rowHeight = 80.0
        tableView.removeExcessCells()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        configureViewController()
        configureTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }

    private func getFavorites() {
        PersistenceManager.retrieveFavorites
        { [weak self] (result: Result<[Follower], GFError>) in
            guard let self = self else { return }

            switch result {
            case .success(let favorites):
                self.favorites = favorites
                if favorites.isEmpty {
                    DispatchQueue.main.async {
                        self.showEmptyView()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.view.bringSubviewToFront(self.tableView)
                    }
                }

            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong!".l10n,
                                                message: error.rawValue.l10n,
                                                buttonTitle: "OK".l10n)
            }
        }
    }

    private func showEmptyView() {
        let emptyStateString = "No favorites?\n Try adding some!".l10n
        showEmptyStateView(with: emptyStateString, in: self.view)
    }

    private func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Favorites".l10n
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
    }
}

//
// MARK: - UITableViewDataSource
//
extension FavoriteListVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID,
                                                 for: indexPath) as! FavoriteCell
        let favorite = favorites[indexPath.row]
        cell.set(favorite: favorite)
        return cell
    }
}

//
// MARK: - UITableViewDelegate
//
extension FavoriteListVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let destinationVC = FollowerListVC(username: favorite.login)
        navigationController?.pushViewController(destinationVC, animated: true)
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }

        let favorite = favorites[indexPath.row]

        PersistenceManager.update(with: favorite, actionType: .remove) { [weak self] error in
            guard let self = self else { return }

            if let error = error {
                self.presentGFAlertOnMainThread(title: "Unable to remove".l10n,
                                                message: error.rawValue.l10n,
                                                buttonTitle: "OK".l10n)
                return
            }

            DispatchQueue.main.async {
                self.favorites.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .left)
                if self.favorites.isEmpty {
                    self.showEmptyView()
                }
            }
        }
    }
}
