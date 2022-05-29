//
//  HomeListVC.swift
//  DogsApp
//
//  Created by Artur Marchetto on 30/05/2022.
//

import UIKit
import Combine

final class HomeListVC: UIViewController {
    
    // MARK: - Views
    
    let tableView = UITableView()
    
    let activityIndicator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        
        let activity = UIActivityIndicatorView(style: .large)
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.startAnimating()
        activity.color = .darkGray
        view.addSubview(activity)
        
        activity.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activity.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        return view
    }()
    
    // MARK: - Data
    
    var coordinator: MainCoordinator?
    private let dogsService = DogsService(apiSession: APISession())
    
    private var isLoading = true
    private var breeds = [String]()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationView()
        refreshView()
        fetchAllBreeds()
    }
}

// MARK: - View setup
extension HomeListVC {
    
    private func setupTableView() {
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        
        tableView.register(BreedCellView.self, forCellReuseIdentifier: BreedCellView.identifier)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    private func setupNavigationView() {
        self.title = "Dog Breeds"
        view.backgroundColor = .white
        
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.backgroundColor = UIColor(hex: "50C7C3")
            navigationController?.navigationBar.tintColor = .white
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
    }
    
    private func refreshView() {
        setActivityIndicatorStatus()
        tableView.reloadData()
    }
    
    private func setActivityIndicatorStatus() {
        switch self.isLoading {
        case false:
            activityIndicator.removeFromSuperview()
        case true:
            view.addSubview(activityIndicator)
            
            let safeArea = view.safeAreaLayoutGuide
            
            activityIndicator.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
            activityIndicator.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
            activityIndicator.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
            activityIndicator.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        }
    }
}

// MARK: - Table view setup
extension HomeListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.breeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: BreedCellView.identifier, for: indexPath) as? BreedCellView {
            cell.setupCell(name: self.breeds[indexPath.row])
            return cell
        }
        fatalError()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        coordinator?.showBreedImages(breed: self.breeds[indexPath.row])
    }
}

// MARK: - Data fetching
extension HomeListVC {
    private func fetchAllBreeds() {
        dogsService
            .fetchAllBreeds()
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { _ in},
                receiveValue: { [weak self] breedsResponse in
                    
                    // Simply here to show the activity indicator xd - the API returns the data too quickly to see
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        
                        self?.isLoading = false
                        
                        guard
                            let self = self,
                            breedsResponse.status == "success"
                        else { return }
                        
                        self.breeds = breedsResponse.breeds
                        self.refreshView()
                    }
                }
            )
            .store(in: &self.cancellables)
    }
}
