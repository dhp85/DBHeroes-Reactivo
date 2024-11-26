//
//  HeroesTableViewController.swift
//  DBHeroes-Reactivo
//
//  Created by Diego Herreros Parron on 26/11/24.
//

import UIKit
import Combine
import Kingfisher


class HeroesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
    
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: HeroesViewModel
    var suscriptions = Set<AnyCancellable>()
    
    init(viewModel: HeroesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "HeroesTableViewCell", bundle: nil), forCellReuseIdentifier: HeroesTableViewCell.identifier)
        self.title = "Heroes"
        self.bindingUI()
        
    }
    
    private func bindingUI() {
        self.viewModel.$heroesList
            .receive(on: DispatchQueue.main)
            .sink{ data in
                self.tableView.reloadData()
            }
            .store(in: &suscriptions)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.heroesList.count
    }
    
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
 

}
