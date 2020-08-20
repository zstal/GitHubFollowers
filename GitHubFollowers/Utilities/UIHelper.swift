import UIKit

enum UIHelper {

    static func createThreeColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width // total width of the screen
        let padding: CGFloat = 12.0
        let minimumItemSpacing: CGFloat = 10.0
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth / 3

        let flowLayout = UICollectionViewFlowLayout()
        let inset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.sectionInset = inset
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40.0)

        return flowLayout
    }
}
