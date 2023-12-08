// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
enum L10n {
    enum Auth {
        /// E-mail
        static let emailTextFieldPlaceholder = L10n.tr("Localizable", "auth.email-text-field-placeholder", fallback: "E-mail")
        /// Пароль
        static let passwordTextFieldPlaceholder = L10n.tr("Localizable", "auth.password-text-field-placeholder", fallback: "Пароль")
        /// Войти
        static let signInButton = L10n.tr("Localizable", "auth.sign-in-button", fallback: "Войти")
        /// Еще нет аккаунта?
        static let signUpButton = L10n.tr("Localizable", "auth.sign-up-button", fallback: "Еще нет аккаунта?")
        /// Авторизация
        static let title = L10n.tr("Localizable", "auth.title", fallback: "Авторизация")
    }

    enum EditItem {
        /// Удалить
        static let deleteButton = L10n.tr("Localizable", "edit-item.delete-button", fallback: "Удалить")
        /// Запись
        static let title = L10n.tr("Localizable", "edit-item.title", fallback: "Запись")
    }

    enum Main {
        /// Новая запись
        static let button = L10n.tr("Localizable", "main.button", fallback: "Новая запись")
        /// Дедлайн:
        static let deadline = L10n.tr("Localizable", "main.deadline", fallback: "Дедлайн:")
        /// Что-то пошло не так
        static let defaultErrorLabel = L10n.tr("Localizable", "main.default-error-label", fallback: "Что-то пошло не так")
        /// Пока здесь нет ни одной записи.
        /// Создайте новую!
        static let emptyLabel = L10n.tr("Localizable", "main.empty-label", fallback: "Пока здесь нет ни одной записи.\nСоздайте новую!")
        /// dd MMMM yyyy 'в' HH:mm
        static let itemCellDateFormat = L10n.tr("Localizable", "main.item-cell-date-format", fallback: "dd MMMM yyyy 'в' HH:mm")
        /// Нет соединения
        static let noConnectionLabel = L10n.tr("Localizable", "main.no-connection-label", fallback: "Нет соединения")
        /// Профиль
        static let profileButton = L10n.tr("Localizable", "main.profile-button", fallback: "Профиль")
        /// Обновить
        static let refreshButton = L10n.tr("Localizable", "main.refresh-button", fallback: "Обновить")
        /// Cписок дел
        static let title = L10n.tr("Localizable", "main.title", fallback: "Cписок дел")
    }

    enum NetworkError {
        /// Закрыть
        static let alertButton = L10n.tr("Localizable", "network-error.alert-button", fallback: "Закрыть")
        /// Ошибка!
        static let alertTitle = L10n.tr("Localizable", "network-error.alert-title", fallback: "Ошибка!")
        /// Ой! Мы не смогли обработать полученные данные. Попробуйте перезапустить приложение.
        static let wrongResponse = L10n.tr("Localizable", "network-error.wrong-response", fallback: "Ой! Мы не смогли обработать полученные данные. Попробуйте перезапустить приложение.")
        /// Упс! Что-то пошло не так. Попробуйте обновить страницу или зайдите позже.
        static let wrongStatusCode = L10n.tr("Localizable", "network-error.wrong-status-code", fallback: "Упс! Что-то пошло не так. Попробуйте обновить страницу или зайдите позже.")
        /// Невозможно установить соединение. Проверьте ваш запрос и повторите попытку.
        static let wrongUrl = L10n.tr("Localizable", "network-error.wrong-url", fallback: "Невозможно установить соединение. Проверьте ваш запрос и повторите попытку.")
    }

    enum NewItem {
        /// Cоздать
        static let createButton = L10n.tr("Localizable", "new-item.create-button", fallback: "Cоздать")
        /// Дедлайн
        static let deadlineTitle = L10n.tr("Localizable", "new-item.deadline-title", fallback: "Дедлайн")
        /// Описание
        static let descriptionViewTitle = L10n.tr("Localizable", "new-item.description-view-title", fallback: "Описание")
        /// Новая запись
        static let title = L10n.tr("Localizable", "new-item.title", fallback: "Новая запись")
        /// Что нужно сделать
        static let whatToDoViewTitle = L10n.tr("Localizable", "new-item.what-to-do-view-title", fallback: "Что нужно сделать")
    }

    enum SignUp {
        /// E-mail
        static let emailTextFieldPlaceholder = L10n.tr("Localizable", "sign-up.email-text-field-placeholder", fallback: "E-mail")
        /// Пароль
        static let passwordTextFieldPlaceholder = L10n.tr("Localizable", "sign-up.password-text-field-placeholder", fallback: "Пароль")
        /// Зарегистрироваться
        static let signUpButton = L10n.tr("Localizable", "sign-up.sign-up-button", fallback: "Зарегистрироваться")
        /// Регистрация
        static let title = L10n.tr("Localizable", "sign-up.title", fallback: "Регистрация")
        /// Имя пользователя
        static let userNameTextFieldPlaceholder = L10n.tr("Localizable", "sign-up.user-name-text-field-placeholder", fallback: "Имя пользователя")
    }

    enum Validation {
        /// Введите корректный email
        static let emailTextField = L10n.tr("Localizable", "validation.email-text-field", fallback: "Введите корректный email")
        /// Поле должно быть заполнено
        static let emptyTextField = L10n.tr("Localizable", "validation.empty-text-field", fallback: "Поле должно быть заполнено")
        /// Пароль должен быть до 256 символов
        static let symbolsCountPasswordTextField = L10n.tr("Localizable", "validation.symbols-count-password-text-field", fallback: "Пароль должен быть до 256 символов")
        /// Имя должно быть до 70 символов длиной
        static let symbolsCountUserNameTextField = L10n.tr("Localizable", "validation.symbols-count-user-name-text-field", fallback: "Имя должно быть до 70 символов длиной")
    }
}

// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
    private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
        let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
        return String(format: format, locale: Locale.current, arguments: args)
    }
}

// swiftlint:disable convenience_type
private final class BundleToken {
    static let bundle: Bundle = {
        #if SWIFT_PACKAGE
            return Bundle.module
        #else
            return Bundle(for: BundleToken.self)
        #endif
    }()
}

// swiftlint:enable convenience_type
