//
//  HeroesTableViewController.swift
//  DBHeroes-Reactivo
//
//  Created by Diego Herreros Parron on 26/11/24.
//

import UIKit
import Combine
import Kingfisher

final class HeroesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private var viewModel: HeroesViewModel
    private var suscriptions = Set<AnyCancellable>()
    
    // MARK: - Initializers
    init(viewModel: HeroesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureTitle()
        bindingUI()
    }
    
    // MARK: - TableView Configuration
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "HeroesTableViewCell", bundle: nil), forCellReuseIdentifier: HeroesTableViewCell.identifier)
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
    }
    
    // MARK: - UI Configuration
    private func configureTitle() {
        self.title = "Heroes"
    }
    
    // MARK: - Binding UI
    private func bindingUI() {
        self.viewModel.$heroesList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
                self?.tableView.refreshControl?.endRefreshing()
            }
            .store(in: &self.suscriptions)
    }
    
    // MARK: - Pull-to-Refresh Action
    @objc func callPullToRefresh() {
        Task {
            do {
                try await self.viewModel.getHeroes()
            } catch {
                print("Error al obtener los héroes: \(error)")
            }
        }
    }
    
    // MARK: - TableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.heroesList.count
    }
    
    // MARK: - TableView Delegate - Cell Configuration
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HeroesTableViewCell.identifier, for: indexPath) as! HeroesTableViewCell
        
        let hero = viewModel.heroesList[indexPath.row]
        cell.nameHero.text = hero.name
        cell.descriptionHero.text = hero.description
        cell.nextView.text = String(describing: ">")
        if let image = hero.photo {
            cell.heroImage.kf.setImage(with: URL(string: image))
        }
        return cell
    }
    
    // MARK: - TableView Delegate - Row Height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    // MARK: - TableView Delegate - Row Selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.heroesList.count > indexPath.row {
            let hero = viewModel.heroesList[indexPath.row]
            let detailViewModel = DetailHeroesViewModel(hero: hero)
            let detailViewController = DetailHeroesViewController(viewModel: detailViewModel)
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}
