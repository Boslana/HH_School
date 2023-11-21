import UIKit

final class EmptyViewController: ParentViewController {
    enum State {
        case empty, error(Error)
    }
    
    enum Error {
        case noConnection, otherError
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
    @IBOutlet private var secondVC: UIStackView!
    @IBOutlet private var thirdSV: UIStackView!
    @IBOutlet private var lastSV: UIStackView!
    
    @IBOutlet private var emptyImageView: UIImageView!
    @IBOutlet private var emptyLabel: UILabel!
    @IBOutlet private var emptyButton: PrimaryButton!
    
    private lazy var emptyButtonTrailingAnchor = emptyButton.trailingAnchor.constraint(equalTo: firstSV.trailingAnchor, constant: -16)
    private lazy var emptyButtonLeadingAnchor = emptyButton.leadingAnchor.constraint(equalTo: firstSV.leadingAnchor, constant: 16)
    private lazy var emptyButtonTopAnchor = emptyButton.topAnchor.constraint(equalTo: thirdSV.bottomAnchor, constant: 16)
    
    private func updateState() {
        switch state {
        case .empty:
            emptyImageView.image = UIImage.Main.empty
            emptyLabel.text = L10n.Main.emptyLabel
            emptyLabel.font = .boldSystemFont(ofSize: 18)
            emptyButton.setTitle(L10n.Main.button, for: .normal)
            emptyButtonTrailingAnchor.isActive = true
            emptyButtonLeadingAnchor.isActive = true
            firstSV.alignment = .fill
            secondVC.alignment = .fill
            lastSV.alignment = .fill
            lastSV.spacing = 16
        case let .error(error):
            switch error {
            case .noConnection:
                emptyImageView.image = UIImage.Main.noConnection
                emptyLabel.text = L10n.Main.noConnectionLabel
                emptyButton.setTitle(L10n.Main.refreshButton, for: .normal)
            case .otherError:
                emptyImageView.image = UIImage.Main.defaultError
                emptyLabel.text = L10n.Main.defaultErrorLabel
                emptyButton.setTitle(L10n.Main.refreshButton, for: .normal)
            }
            
            emptyLabel.font = .boldSystemFont(ofSize: 18)
            emptyButton.setup(mode: .small)
            
            emptyButtonTopAnchor.isActive = true
            firstSV.alignment = .center
            secondVC.alignment = .center
            lastSV.alignment = .center
            lastSV.spacing = 16
            emptyButtonTrailingAnchor.isActive = false
            emptyButtonLeadingAnchor.isActive = false
            emptyButtonTopAnchor.isActive = true
        }
    }
    
    @IBAction private func didTapEmptyButton() {
        switch state {
        case .empty:
            action?()
        case .error(.noConnection), .error(.otherError):
            navigationController?.popToRootViewController(animated: true)
        }
    }
}
