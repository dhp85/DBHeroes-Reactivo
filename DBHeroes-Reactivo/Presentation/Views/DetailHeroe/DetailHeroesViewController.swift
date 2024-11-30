//
//  DetailHeroesViewController.swift
//  DBHeroes-Reactivo
//
//  Created by Diego Herreros Parron on 27/11/24.
//

import UIKit
import Combine
import Kingfisher

// MARK: - Enums
enum SectionsTransformation {
    case main
}

// MARK: - DetailHeroesViewController
final class DetailHeroesViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var labelTransformation: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var descriptionHero: UILabel!
    @IBOutlet weak var labelTransformations: UILabel!
    // MARK: - Properties
    private var viewModel: DetailHeroesViewModel
    private var suscriptions = Set<AnyCancellable>()
    
    // MARK: - Initializers
    init(viewModel: DetailHeroesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureView()
        bindUI()
        labelTransformation.text = NSLocalizedString("Transformaciones", comment: "")
    }
    
    // tenia problemas con la carga de datos de transformaciones cuando cargaba por segunda vez un heroe con transformaciones y lo solucione asi.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        clearView()
    }
    
    // MARK: - Binding Methods
    private func bindUI() {
        Publishers.CombineLatest(viewModel.$hero, viewModel.$transformation)// Combina los valores emitidos por ambos publishers en un unico flujo. Siempre que uno de los publishers emite un valor, el combinador genera un nuevo par con los valores actuales de ambos publishers.
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (hero, transformation) in
                // Configurar la imagen del héroe
                if let image = hero.photo {
                    self?.heroImage.kf.setImage(with: URL(string: image))
                } else {
                    self?.heroImage.image = nil
                }
                self?.descriptionHero.text = hero.description

                // Mostrar/ocultar elementos según la transformación
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
    
    // MARK: - Configuration Methods
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
    
    // MARK: - Helper Methods
    func clearView() {
        self.viewModel.transformation.removeAll()
        KingfisherManager.shared.cache.clearMemoryCache()
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension DetailHeroesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDataSource Methods
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
    
    // MARK: - UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 232, height: 232)
    }
}
