//
//  LoginViewController.swift
//  DBHeroes-Reactivo
//
//  Created by Diego Herreros Parron on 25/11/24.
//

import UIKit
import Foundation
import Combine
import CombineCocoa

final class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var activityIndacator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - Properties
    private var viwModel: LoginViewModel?
    private var user: String = ""
    private var pass: String = ""
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Initializers
    init(viewModel: LoginViewModel) {
        self.viwModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configLenguage()
        bindViewModel()
        bindingUI()
    }
    
    // MARK: - UI Bindings
    func bindingUI() {
        // Bind username text field
        self.userName?.textPublisher
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] userName in
                print("Text user: \(userName)")
                self?.user = userName
                self?.loginButton?.isEnabled = userName.count >= 5
            }
            .store(in: &subscriptions)
        
        // Bind password text field
        self.password?.textPublisher
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                print("Text password: \(data)")
                self?.pass = data
            }
            .store(in: &subscriptions)
        
        // Bind login button tap
        self.loginButton?.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                guard let user = self?.user,
                      let pass = self?.pass, !pass.isEmpty else {
                    self?.showAlert(titleKey: "Error", messageKey: "Contraseña vacia")
                    return
                }
                self?.viwModel?.login(username: user, password: pass)
            })
            .store(in: &subscriptions)
    }
    
    // MARK: - Language Configuration
    func configLenguage() {
        loginButton.setTitle(NSLocalizedString("Login", comment: ""), for: .normal)
        userName.placeholder = NSLocalizedString("Email", comment: "")
        password.placeholder = NSLocalizedString("Password", comment: "")
    }
    
    // MARK: - ViewModel Binding
    func bindViewModel() {
        viwModel?.$statusLogin
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.handleLoginStatus(status)
            }
            .store(in: &subscriptions)
    }
    
    // MARK: - Handling Login Status
    private func handleLoginStatus(_ status: LoginStatus) {
        switch status {
        case .none:
            print("None")
        case .loading:
            activityIndacator.startAnimating()
        case .success:
            navigateToHome()
        case .error:
            activityIndacator.stopAnimating()
            showAlert(titleKey: "Error", messageKey: "Usuario o contraseña incorrectos")
        }
    }
    
    // MARK: - Navigation
    private func navigateToHome() {
        let homeViewController = HeroesTableViewController(viewModel: HeroesViewModel())
        let navigationController = UINavigationController(rootViewController: homeViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - Alert Presentation
    func showAlert(titleKey: String, messageKey: String) {
        let title = NSLocalizedString(titleKey, comment: "")
        let message = NSLocalizedString(messageKey, comment: "")
        let okButtonTitle = NSLocalizedString("OK", comment: "OK button text")
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: okButtonTitle, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
