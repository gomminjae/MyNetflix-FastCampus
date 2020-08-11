//
//  SearchViewController.swift
//  MyNetflix
//
//  Created by joonwon lee on 2020/04/02.
//  Copyright © 2020 com.joonwon. All rights reserved.
//

import UIKit
import Kingfisher
import AVFoundation
import Firebase

class SearchViewController: UIViewController {
    
    let db = Database.database().reference().child("searchHistory")


    @IBOutlet weak var resultCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var movies = [Movie]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
//MARK: DataSource
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResultCell", for: indexPath) as? ResultCell else { return UICollectionViewCell() }
        
        let movie = movies[indexPath.item]
        let url = URL(string: movie.thumbnailPath)
        cell.movieThumbnail.kf.setImage(with: url)
        
        return cell
    }
}

//MARK: CollectionView
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //player vc
        //player vc에 movie 전달
        let movie = movies[indexPath.item]
        let itemUrl = URL(string: movie.previewURL)!
        let item = AVPlayerItem(url: itemUrl)
        
        let sb = UIStoryboard(name: "Player", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "PlayerViewController") as! PlayerViewController
        
        vc.modalPresentationStyle = .fullScreen
        
        vc.player.replaceCurrentItem(with: item)
        present(vc, animated: false, completion: nil)
    }
    
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let margin: CGFloat = 8
        let itemSpacing: CGFloat = 10
        
        let width = (collectionView.bounds.width - margin * 2 - itemSpacing * 2) / 3
        let height = width * 10/7
        
        return CGSize(width: width, height: height)
    }
}


//MARK: SearchBar Delegate
extension SearchViewController: UISearchBarDelegate {
    
    //키보드 내려가게 설정
    private func dissmissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        dissmissKeyboard()
        
        guard let searchTerm = searchBar.text , searchTerm.isEmpty == false else { return }
        
        SearchAPI.search(searchTerm) { (movies) in
            print("-->result: \(movies.count)")
            DispatchQueue.main.async {
                self.movies = movies
                self.resultCollectionView.reloadData()
                let time = Date().timeIntervalSince1970.rounded()
                self.db.childByAutoId().setValue(["term": searchTerm, "timeStamp": time])
                
            }
        }
        
        print("-->검색어: \(searchTerm)")
    }
    
}
