//
//  RecommendListViewController.swift
//  MyNetflix
//
//  Created by joonwon lee on 2020/04/02.
//  Copyright © 2020 com.joonwon. All rights reserved.
//

import UIKit

class RecommendListViewController: UIViewController {

    @IBOutlet weak var sectionTitle: UILabel!
    let viewModel = RecommentListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    func updateUI() {
        sectionTitle.text = viewModel.type.title
    }
}

extension RecommendListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendCell", for: indexPath) as? RecommendCell else {
            return UICollectionViewCell()
        }
        
        let movie = viewModel.item(at: indexPath.item)
        cell.updateUI(movie: movie)
        return cell
    }
}


extension RecommendListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 160)
    }
}
class RecommendCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailImage: UIImageView!
    
    func updateUI(movie: DummyItem) {
        thumbnailImage.image = movie.thumbnail
    }
}

class MovieFetcher {
    static func fetch(_ type: RecommentListViewModel.RecommendingType) -> [DummyItem] {
        switch type {
        case .award:
            let movies = (1..<10).map { DummyItem(thumbnail: UIImage(named: "img_movie_\($0)")!) }
            return movies
        case .hot:
            let movies = (10..<19).map { DummyItem(thumbnail: UIImage(named: "img_movie_\($0)")!) }
            return movies
        case .my:
            let movies = (1..<10).map { $0 * 2 }.map { DummyItem(thumbnail: UIImage(named: "img_movie_\($0)")!) }
            return movies
        }
    }
}

struct DummyItem {
    let thumbnail: UIImage
}
