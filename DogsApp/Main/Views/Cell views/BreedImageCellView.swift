//
//  BreedImageCellView.swift
//  DogsApp
//
//  Created by Artur Marchetto on 30/05/2022.
//

import SwiftUI

final class BreedImageCellView: UICollectionViewCell {
    
    static let identifier = "BreedImageCellView"
    
    private var urlString: String?
    private var isLoading = true
    private var image: UIImage?
    
    lazy var pictureView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleToFill
        imageView.frame = cardView.frame
        imageView.layer.cornerRadius = 8
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.5
        imageView.layer.shadowRadius = 8
        imageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        imageView.image = image
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .tertiarySystemBackground
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 8
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCardView()
    }
    
    func setupCell(urlString: String) {
        self.urlString = urlString
        fetchImage()
    }
    
    private func fetchImage() {
        guard let urlString = urlString,
              let url = URL(string: urlString)
        else { return }
        url.downloadImage { [weak self] image, error in
            
            guard let self = self, let image = image, error == nil else { return }
            
            DispatchQueue.main.async {
                self.image = image
                self.setupPictureView()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup view
extension BreedImageCellView {
    
    private func setupCardView() {
        contentView.addSubview(cardView)
        cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        cardView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    private func setupPictureView() {
        self.contentView.addSubview(self.pictureView)
        self.pictureView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        self.pictureView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        self.pictureView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.pictureView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
    }
}
