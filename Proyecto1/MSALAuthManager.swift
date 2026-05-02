import Foundation

#if canImport(MSAL)
import MSAL
import UIKit

@MainActor
final class MSALAuthManager: ObservableObject {
    static let shared = MSALAuthManager()

    @Published private(set) var accountUsername: String?

    private var application: MSALPublicClientApplication?
    private var account: MSALAccount?

    private init() {
        do {
            let authority = try MSALAADAuthority(url: URL(string: "https://login.microsoftonline.com/common")!)
            let config = MSALPublicClientApplicationConfig(
                clientId: "YOUR-CLIENT-ID-HERE",
                redirectUri: nil,
                authority: authority
            )
            application = try MSALPublicClientApplication(configuration: config)
            refreshCurrentAccount()
        } catch {
            application = nil
        }
    }

    func signIn() {
        guard let application else { return }
        guard let controller = topViewController() else { return }

        let webParameters = MSALWebviewParameters(authPresentationViewController: controller)
        let parameters = MSALInteractiveTokenParameters(scopes: ["User.Read"], webviewParameters: webParameters)

        application.acquireToken(with: parameters) { [weak self] result, _ in
            Task { @MainActor in
                self?.account = result?.account
                self?.accountUsername = result?.account.username
            }
        }
    }

    func signOut() {
        guard let application, let account, let controller = topViewController() else { return }

        let webParameters = MSALWebviewParameters(authPresentationViewController: controller)
        let signoutParameters = MSALSignoutParameters(webviewParameters: webParameters)

        application.signout(with: account, signoutParameters: signoutParameters) { [weak self] _, _ in
            Task { @MainActor in
                self?.account = nil
                self?.accountUsername = nil
            }
        }
    }

    private func refreshCurrentAccount() {
        guard let application else { return }

        application.getCurrentAccount(with: nil) { [weak self] currentAccount, _, _ in
            Task { @MainActor in
                self?.account = currentAccount
                self?.accountUsername = currentAccount?.username
            }
        }
    }

    private func topViewController() -> UIViewController? {
        let controller = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .rootViewController
        return topViewController(from: controller)
    }

    private func topViewController(from controller: UIViewController?) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(from: navigationController.visibleViewController)
        }
        if let tabBarController = controller as? UITabBarController {
            return topViewController(from: tabBarController.selectedViewController)
        }
        if let presentedViewController = controller?.presentedViewController {
            return topViewController(from: presentedViewController)
        }
        return controller
    }
}
#endif
