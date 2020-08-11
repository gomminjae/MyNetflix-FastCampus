//
//  RecommendListViewModel.swift
//  MyNetflix
//
//  Created by Apple on 2020/06/14.
//  Copyright © 2020 com.joonwon. All rights reserved.
//

import Foundation

class RecommentListViewModel {
    enum RecommendingType {
        case award
        case hot
        case my
        
        var title: String {
            switch self {
            case .award: return "아카데미 호평 영황"
            case .hot: return "취한저격 HOT 콘텐츠"
            case .my: return "내가 찜한 콘텐츠"
            
            }
        }
    }
    private (set) var type: RecommendingType = .my
    private var items: [DummyItem] = []
    
    var numOfItems: Int {
        return items.count
    }
    
    func item(at index: Int) -> DummyItem {
        return items[index]
    }
    
    func updateType(_ type: RecommendingType) {
        self.type = type
    }
    
    func fetchItems() {
        self.items = MovieFetcher.fetch(type)
    }
}
