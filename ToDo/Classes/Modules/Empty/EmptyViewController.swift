import UIKit

final class EmptyViewController: ParentViewController {
    enum State {
        case empty, error(Error)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateState()
    }
    
    var action: (() -> Void)?
    
    var state: State = .empty {
        didSet {
            guard view.window != nil else {
                return
            }
            updateState()
        }
    }
    
    @IBOutlet private var firstSV: UIStackView!
    @IBOutlet private var secondSV: UIStackView!
    @IBOutlet private var thirdSV: UIStackView!
    @IBOutlet private var lastSV: UIStackView!
    
    @IBOutlet private var emptyImageView: UIImageView!
    @IBOutlet private var emptyLabel: UILabel!
    @IBOutlet private var emptyButton: PrimaryButton!
    
    private func updateState() {
        switch state {
        case .empty:
            firstSV.alignment = .fill
            secondSV.alignment = .fill
            lastSV.alignment = .center
            lastSV.spacing = 16
            
            emptyImageView.image = UIImage.Main.empty
            emptyLabel.text = L10n.Main.emptyLabel
            emptyLabel.font = .systemFont(ofSize: 18, weight: .semibold)
            emptyButton.setTitle(L10n.Main.button, for: .normal)
            emptyButton.setup(mode: .large)
            
        case let .error(error):
            emptyLabel.font = .systemFont(ofSize: 18, weight: .semibold)
            emptyButton.setup(mode: .small)
            emptyButton.setTitle(L10n.Main.refreshButton, for: .normal)
            
            firstSV.alignment = .center
            secondSV.alignment = .center
            lastSV.alignment = .center
            lastSV.spacing = 16
            
            if (error as NSError).code == NSURLErrorNotConnectedToInternet {
                emptyImageView.image = UIImage.Main.noConnection
                emptyLabel.text = L10n.Main.noConnectionLabel
            } else {
                emptyImageView.image = UIImage.Main.defaultError
                emptyLabel.text = L10n.Main.defaultErrorLabel
            }
        }
        view.layoutIfNeeded()
    }
    
    @IBAction private func didTapEmptyButton() {
        action?()
    }
}
