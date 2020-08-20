import UIKit

class GFFollowerItemVC: GFItemInfoVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }

    private func configureItems() {
        itemInfoView1.set(itemInfoType: .followers, count: user.followers)
        itemInfoView2.set(itemInfoType: .following, count: user.following)
        let title = "Followers".l10n
        actionButton.setTitle(title, for: .normal)
        actionButton.backgroundColor = .systemGreen
    }
}
