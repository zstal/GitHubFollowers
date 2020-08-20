import UIKit

class GFRepoItemVC: GFItemInfoVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }

    private func configureItems() {
        itemInfoView1.set(itemInfoType: .repos, count: user.publicRepos)
        itemInfoView2.set(itemInfoType: .gists, count: user.publicGists)
        let title = "GitHub profile".l10n
        actionButton.setTitle(title, for: .normal)
        actionButton.backgroundColor = .systemPurple
    }
}
