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
        static let errorEmptyTextField = NSLocalizedString("sign-up.error-empty-text-field", comment: "")
    }
    
    enum Main {
        static let title = NSLocalizedString("main.title", comment: "")
        static let profileButton = NSLocalizedString("main.profile-button", comment: "")
        static let emptyLable = NSLocalizedString("main.empty-lable", comment: "")
        static let emptyButton = NSLocalizedString("main.empty-button", comment: "")
    }
}
