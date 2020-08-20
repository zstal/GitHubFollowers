import UIKit

class GFDataLoadingVC: UIViewController {

    private var containerView: UIView!
    private var emptyStateView: GFEmptyStateView!

    func showLoadingView() {
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)

        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0.0

        UIView.animate(withDuration: 0.25) {
            self.containerView.alpha = 0.8
        }

        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        ])

        activityIndicator.startAnimating()
    }

    func dismissLoadingView() {
        containerView.removeFromSuperview()
        containerView = nil
    }

    func showEmptyStateView(with message: String, in view: UIView) {
        if emptyStateView == nil {
            emptyStateView = GFEmptyStateView(message: message)
            emptyStateView.frame = view.bounds
            view.addSubview(emptyStateView)
        }
        view.bringSubviewToFront(emptyStateView)
    }
}
