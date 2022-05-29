//
//  DetailViewVC.swift
//  DogsApp
//
//  Created by Artur Marchetto on 30/05/2022.
//

import UIKit
import Combine

final class DetailViewVC: UIViewController {
    
    private let dogsService = DogsService(apiSession: APISession())
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 30
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        let width = UIScreen.main.bounds.width - 40
        layout.itemSize = CGSize(width: width, height: width - 120)
        layout.minimumLineSpacing = spacing
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var breed: String
    var imageURLs = [String]()
    private var cancellables = Set<AnyCancellable>()
    
    init(breed: String) {
        self.breed = breed
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = breed
        view.backgroundColor = .white
        setupCollectionView()
        fetchImageURLs()
    }
    
    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.frame = view.bounds
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(BreedImageCellView.self, forCellWithReuseIdentifier: BreedImageCellView.identifier)
    }
    
    private func fetchImageURLs() {
        
        dogsService
            .fetchRandomImagesForBreed(name: breed, count: 10)
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { _ in},
                receiveValue: { [weak self] imagesResponse in
                    
                    guard let self = self,
                          imagesResponse.status == "success"
                    else { return }
                    
                    self.imageURLs = imagesResponse.images
                    self.collectionView.reloadData()
                }
            )
            .store(in: &self.cancellables)
    }
}

extension DetailViewVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BreedImageCellView.identifier, for: indexPath) as? BreedImageCellView {
            cell.setupCell(urlString: self.imageURLs[indexPath.row])
            return cell
        }
        fatalError()
    }
}
