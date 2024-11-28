//
//  DetailHeroesViewController.swift
//  DBHeroes-Reactivo
//
//  Created by Diego Herreros Parron on 27/11/24.
//

import UIKit
import Combine
import Kingfisher

enum SectionsTransformation {
    case main
}

final class DetailHeroesViewController: UIViewController {
    
    @IBOutlet weak var heroImage: UIImageView!
    
    @IBOutlet weak var labelTransformation: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var descriptionHero: UILabel!
    
    private var viewModel: DetailHeroesViewModel
    private var suscriptions = Set<AnyCancellable>()
    
    init(viewModel: DetailHeroesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureView()
        bindUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        clearView()
    }
    
    private func bindUI() {
           viewModel.$hero
               .receive(on: DispatchQueue.main)
               .sink { [weak self] hero in
                   if let image = hero.photo {
                       self?.heroImage.kf.setImage(with: URL(string: image))
                   } else {
                       self?.heroImage.image = nil
                   }
                   self?.descriptionHero.text = hero.description
               }
               .store(in: &suscriptions)
           
           viewModel.$transformation
               .receive(on: DispatchQueue.main)
               .sink { [weak self] transformation in
                   if !transformation.isEmpty {
                       self?.collectionView.isHidden = false
                       self?.labelTransformation.isHidden = false
                       self?.collectionView.reloadData()
                   } else {
                       self?.collectionView.isHidden = true
                       self?.labelTransformation.isHidden = true
                   }
                   
               }
               .store(in: &suscriptions)
       }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.register(UINib(nibName: CollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: CollectionViewCell.identifier)
        collectionView.dataSource = self

    }
    
    private func configureView() {
        self.title = viewModel.hero.name
        heroImage.layer.cornerRadius = 20
        heroImage.layer.borderColor = UIColor.black.cgColor  
        heroImage.layer.borderWidth = 2.0
    }
    
    func clearView() {
        viewModel.clearTransformations()
        KingfisherManager.shared.cache.clearMemoryCache()
        collectionView.reloadData()
    }
}

extension DetailHeroesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.transformation.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let transformation = viewModel.transformation[indexPath.row]
        cell.nameTransformation.text = transformation.name
        if let image = transformation.photo {
            cell.imageTransformation.kf.setImage(with: URL(string: image))
        } else {
            cell.imageTransformation.image = nil
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
}
