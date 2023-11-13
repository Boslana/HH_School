//
//  TextViewInput.swift
//  ToDo
//
//  Created by Светлана Полоротова on 13.11.2023.
//

import UIKit

class TextViewInput: UIView, UITextViewDelegate {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .Color.black
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        return titleLabel
        }()
    
    var text: String? {
        return titleLabel.text
    }

    func setup(titleText: String?) {
        titleLabel.text = titleText
    }
    
    private let insets = UIEdgeInsets(top: 18, left: 16, bottom: 16, right: 16)
    private let paragraphStyle = NSMutableParagraphStyle()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor.Color.BackgraungAndSurfaces.surfaceSecondary
        textView.textColor = UIColor.Color.black
        textView.font = UIFont.systemFont(ofSize: 16)
        paragraphStyle.lineHeightMultiple = 1.15
        textView.layer.cornerRadius = 8
        textView.tintColor = UIColor.Color.black
        textView.textContainerInset = insets
        textView.isScrollEnabled = false
        return textView
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.textColor = UIColor.Color.error
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 2
        return label
    }()
    
    func show(error: String) {
        errorLabel.text = error
        bottomConstraint.isActive = false
        errorLabel.isHidden = false
        invalidateIntrinsicContentSize()
    }

    func hideError() {
        errorLabel.isHidden = true
        bottomConstraint.isActive = true
        invalidateIntrinsicContentSize()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
            didBeginEditing()
        }
    
    override var intrinsicContentSize: CGSize {
        var totalHeight = titleLabel.intrinsicContentSize.height + textView.frame.size.height + 8
        
        if errorLabel.isHidden {
            return CGSize(width: UIView.noIntrinsicMetric, height: totalHeight)
        }
        let rect = errorLabel.textRect(forBounds: bounds, limitedToNumberOfLines: errorLabel.numberOfLines)
        return CGSize(width: UIView.noIntrinsicMetric, height: totalHeight + rect.height + 4)
    }
    
    private lazy var bottomConstraint = textView.bottomAnchor.constraint(equalTo: bottomAnchor)
    
    private func setup() {
        addSubview(titleLabel)
        addSubview(textView)
        addSubview(errorLabel)

        textView.delegate = self
        
        titleLabel.frame = CGRect(x: 0, y: 0, width: frame.width, height: 22)
        
        NSLayoutConstraint.activate([
        titleLabel.topAnchor.constraint(equalTo: topAnchor),
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        
        textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
        textView.leadingAnchor.constraint(equalTo: leadingAnchor),
        textView.trailingAnchor.constraint(equalTo: trailingAnchor),
        textView.heightAnchor.constraint(equalToConstant: 56),
        bottomConstraint,
        
        errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
        errorLabel.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 4),
        trailingAnchor.constraint(equalTo:errorLabel.trailingAnchor, constant: 8),
        errorLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)

        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                let newHeight = min(max(estimatedSize.height, 56), 200)
                constraint.constant = newHeight
                textView.isScrollEnabled = (newHeight == 200)
            }
        }
    }
    
    @objc
    private func didBeginEditing() {
        hideError()
    }
}
