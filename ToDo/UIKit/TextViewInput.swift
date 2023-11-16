//
//  TextViewInput.swift
//  ToDo
//
//  Created by Светлана Полоротова on 13.11.2023.
//

import UIKit

final class TextViewInput: UIView, UITextViewDelegate {
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
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
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
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor.Color.BackgraungAndSurfaces.surfaceSecondary
        textView.textColor = UIColor.Color.black
        textView.font = UIFont.systemFont(ofSize: 16)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        textView.typingAttributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        
        textView.layer.cornerRadius = 8
        textView.tintColor = UIColor.Color.black
        textView.textContainerInset = UIEdgeInsets(top: 18, left: 16, bottom: 16, right: 16)
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
        textViewHeightConstraint?.isActive = true
        errorLabelTopConstraint.isActive = true
        errorLabel.isHidden = false
        invalidateIntrinsicContentSize()
    }
    
    func hideError() {
        errorLabel.isHidden = true
        textViewHeightConstraint?.isActive = true
        errorLabelTopConstraint.isActive = false
        invalidateIntrinsicContentSize()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        didBeginEditing()
    }
    
    override var intrinsicContentSize: CGSize {
        let totalHeight = titleLabel.intrinsicContentSize.height + (textViewHeightConstraint?.constant ?? 0) + 8
        
        if errorLabel.isHidden {
            return CGSize(width: UIView.noIntrinsicMetric, height: totalHeight)
        }
        
        let rect = errorLabel.textRect(forBounds: bounds, limitedToNumberOfLines: errorLabel.numberOfLines)
        return CGSize(width: UIView.noIntrinsicMetric, height: totalHeight + rect.height + 4)
    }
    
    private lazy var errorLabelTopConstraint = errorLabel.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 4)
    
    private var textViewHeightConstraint: NSLayoutConstraint?
    
    private func setup() {
        addSubview(titleLabel)
        addSubview(textView)
        addSubview(errorLabel)
        
        textView.delegate = self
        
        textViewHeightConstraint = textView.heightAnchor.constraint(equalToConstant: 56)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textViewHeightConstraint!,
            
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            trailingAnchor.constraint(equalTo:errorLabel.trailingAnchor, constant: 8),
        ])
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textView.isScrollEnabled = false
        
        let newSize = textView.sizeThatFits(CGSize(width: frame.width, height: .infinity))
        let newHeight = min(max(newSize.height, 56), 200)
        
        if textViewHeightConstraint?.constant != newHeight {
            textViewHeightConstraint?.constant = newHeight
            self.layoutIfNeeded()
        }
        
        textView.isScrollEnabled = newHeight == 200
        
        invalidateIntrinsicContentSize()
    }
    
    @objc
    private func didBeginEditing() {
        hideError()
    }
}
