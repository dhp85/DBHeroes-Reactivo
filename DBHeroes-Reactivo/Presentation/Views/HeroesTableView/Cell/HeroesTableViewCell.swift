//
//  HeroesTableTableViewCell.swift
//  DBHeroes-Reactivo
//
//  Created by Diego Herreros Parron on 26/11/24.
//

import UIKit

final class HeroesTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var nameHero: UILabel!
    @IBOutlet weak var descriptionHero: UILabel!
    @IBOutlet weak var nextView: UILabel!
    
    // MARK: - Static Properties
    static var identifier: String {
        String(describing: HeroesTableViewCell.self)
    }

    // MARK: - Lifecycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        configureImage()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // MARK: - Private Methods
    private func configureImage() {
        heroImage.layer.cornerRadius = heroImage.frame.size.width / 2
        heroImage.layer.borderColor = UIColor.black.cgColor
        heroImage.layer.borderWidth = 2.0
        heroImage.layer.masksToBounds = true
        heroImage.contentMode = .scaleAspectFill
    }
}
