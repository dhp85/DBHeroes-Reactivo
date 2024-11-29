//
//  CollectionViewCell.swift
//  DBHeroes-Reactivo
//
//  Created by Diego Herreros Parron on 28/11/24.
//

import UIKit
import Kingfisher

// MARK: - CollectionViewCell
final class CollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var nameTransformation: UILabel!
    @IBOutlet weak var imageTransformation: UIImageView!
    
    // MARK: - Static Properties
    static var identifier: String {
        return String(describing: CollectionViewCell.self)
    }
    
    // MARK: - Lifecycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCellAppearance()
    }
    
    // MARK: - Helper Methods
    private func configureCellAppearance() {
        // Configuración del borde del contentView de la celda.
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.black.cgColor
        
        // Aplicar esquinas redondeadas al contentView.
        self.contentView.layer.cornerRadius = 8.0
        self.contentView.layer.masksToBounds = true
    }
}
