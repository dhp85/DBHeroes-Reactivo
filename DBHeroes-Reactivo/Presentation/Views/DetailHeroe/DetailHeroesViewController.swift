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
        bindUI()
        configureCollectionView()
        configureView()
    }
    
    private func bindUI() {
        // Combina ambos publicadores usando combineLatest, sin mapear sus valores
        Publishers.CombineLatest(viewModel.$hero, viewModel.$transformation)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] hero, transformation in
                self?.updateUI(hero: hero, transformation: transformation) // Actualizar UI con ambos valores
            }
            .store(in: &suscriptions)
    }

    // Función para actualizar la interfaz con los nuevos valores de hero y transformation
    private func updateUI(hero: HeroesModel, transformation: [TransformationModel]) {
        
        if let imageUrl = hero.photo {
            heroImage.kf.setImage(with: URL(string: imageUrl))
        } else {
            heroImage.image = nil
        }

       
        descriptionHero.text = hero.description
        collectionView.reloadData()
        
        if transformation.isEmpty {
            labelTransformation.isHidden = true
            collectionView.isHidden = true
        } else {
            labelTransformation.isHidden = false
            collectionView.isHidden = false
        }
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: CollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: CollectionViewCell.identifier)
    }
    
    private func configureView() {
        self.title = viewModel.hero.name
        heroImage.layer.cornerRadius = 20
        heroImage.layer.borderColor = UIColor.black.cgColor  // Establecer el color del contorno
        heroImage.layer.borderWidth = 2.0  //
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
        return CGSize(width: 160, height: 160)
    }
}
