import Foundation

enum L10n {
    enum Auth {
        static let title = NSLocalizedString("auth.title", comment: "")
        static let signInButton = NSLocalizedString("auth.sign-in-button", comment: "")
        static let signUpButton = NSLocalizedString("auth.sign-up-button", comment: "")
        static let emailTextFieldPlaceholder = NSLocalizedString("auth.email-text-field-placeholder", comment: "")
        static let passwordTextFieldPlaceholder = NSLocalizedString("auth.password-text-field-placeholder", comment: "")
    }
    
    enum SignUp {
        static let title = NSLocalizedString("sign-up.title", comment: "")
        static let userNameTextFieldPlaceholder = NSLocalizedString("sign-up.user-name-text-field-placeholder", comment: "")
        static let emailTextFieldPlaceholder = NSLocalizedString("sign-up.email-text-field-placeholder", comment: "")
        static let passwordTextFieldPlaceholder = NSLocalizedString("sign-up.password-text-field-placeholder", comment: "")
        static let signUpButton = NSLocalizedString("sign-up.sign-up-button", comment: "")
    }
    
    enum Main {
        static let title = NSLocalizedString("main.title", comment: "")
        static let profileButton = NSLocalizedString("main.profile-button", comment: "")
        static let emptyLabel = NSLocalizedString("main.empty-label", comment: "")
        static let button = NSLocalizedString("main.button", comment: "")
        static let noConnectionLabel = NSLocalizedString("main.no-connection-label", comment: "")
        static let defaultErrorLabel = NSLocalizedString("main.default-error-label", comment: "")
        static let refreshButton = NSLocalizedString("main.refresh-button", comment: "")
        static let dateFormat = NSLocalizedString("main.item-cell-date-format", comment: "")
        static let deadlineDescription = NSLocalizedString("main.deadline", comment: "")
    }
    
    enum NewItem {
        static let title = NSLocalizedString("new-item.title", comment: "")
        static let whatToDoViewTitle = NSLocalizedString("new-item.what-to-do-view-title", comment: "")
        static let descriptionViewTitle = NSLocalizedString("new-item.description-view-title", comment: "")
        static let deadlineTitle = NSLocalizedString("new-item.deadline-title", comment: "")
        static let createButton = NSLocalizedString("new-item.create-button", comment: "")
    }
    
    enum EditItem {
        static let title = NSLocalizedString("edit-item.title", comment: "")
        static let deleteButton = NSLocalizedString("edit-item.delete-button", comment: "")
    }
    
    enum Validation {
        static let emptyTextField = NSLocalizedString("validation.empty-text-field", comment: "")
        static let emailTextField = NSLocalizedString("validation.email-text-field", comment: "")
        static let symbolCountUserNameTextField = NSLocalizedString("validation.symbols-count-user-name-text-field", comment: "")
        static let symbolCountPasswordTextField = NSLocalizedString("validation.symbols-count-password-text-field", comment: "")
    }
    
    enum NetworkErrorDescription {
        static let wrongStatusCodeDescription = NSLocalizedString("network-error.wrong-status-code", comment: "")
        static let wrongResponseDescription = NSLocalizedString("network-error.wrong-response", comment: "")
        static let wrongURLDescription = NSLocalizedString("network-error.wrong-url", comment: "")
        static let alertTitle = NSLocalizedString("network-error.alert-title", comment: "")
        static let alertButton = NSLocalizedString("network-error.alert-button", comment: "")
        
    }
}
