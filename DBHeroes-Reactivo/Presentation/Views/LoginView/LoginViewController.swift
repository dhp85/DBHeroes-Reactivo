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
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var activityIndacator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    
    private var viwModel: LoginViewModel?
    private var user: String = ""
    private var pass: String = ""
    private var subscriptions = Set<AnyCancellable>()
    
    init(viewModel: LoginViewModel) {
        self.viwModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configLenguage()
        bindViewModel()
        bindingUI()
    }
    
    func bindingUI() {
        if let userName = self.userName {
            userName.textPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] data in
                    if let usr = data {
                        print("Text user: \(usr)")
                        self?.user = usr
                        
                        if let button = self?.loginButton {
                            if (self?.user.count)! >= 5 {
                                button.isEnabled = true
                            } else {
                                button.isEnabled = false
                            }
                        }
                    }
                }
                .store(in: &subscriptions)
        }
        
        if let password = self.password {
            password.textPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] data in
                    if let pwd = data {
                        print("Text password: \(pwd)")
                        self?.pass = pwd
                    }
                }
                .store(in: &subscriptions)
        }
        
        if let button = self.loginButton {
            button.tapPublisher
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] _ in
                    if let user = self?.user,
                       let pass = self?.pass, !pass.isEmpty {
                        self?.viwModel?.login(username: user, password: pass)
                    } else {
                        self?.showAlert(titleKey: "Error", messageKey: "Contraseña vacia")
                    }
                }).store(in: &subscriptions)
        }
    }
    
    func configLenguage() {
        loginButton.setTitle(NSLocalizedString("Login", comment: ""), for: .normal)
        userName.placeholder = NSLocalizedString("Email", comment: "")
        password.placeholder = NSLocalizedString("Password", comment: "")
    }
    
    func bindViewModel() {
        viwModel?.$statusLogin
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.handleLoginStatus(status)
            }
            .store(in: &subscriptions)
    }
    
    private func handleLoginStatus(_ status: LoginStatus) {
        switch status {
        case .none:
            print("None")
        case .loading:
            activityIndacator.startAnimating()
        case .success:
            let HomeviewController = HeroesTableViewController(viewModel: HeroesViewModel())
            let navigationController = UINavigationController(rootViewController: HomeviewController)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
        case .error:
            activityIndacator.stopAnimating()
            showAlert(titleKey: "Error", messageKey: "Usuario o contraseña incorrectos")
        }
    }
    
    /*func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }*/
    func showAlert(titleKey: String, messageKey: String) {
        let title = NSLocalizedString(titleKey, comment: "")
        let message = NSLocalizedString(messageKey, comment: "")
        let okButtonTitle = NSLocalizedString("OK", comment: "OK button text")

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: okButtonTitle, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
