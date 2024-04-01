//
//  ShoppingViewModel.swift
//  RxSwitfPractice-ShoppingList
//
//  Created by JinwooLee on 4/1/24.
//

import Foundation
import RxSwift

final class ShoppingViewModel {
    
    var ShoppingList : [ShoppingListModel] = [
        ShoppingListModel(isDone: false, title: "그립톡 구매하기", isFavorite: false),
        ShoppingListModel(isDone: false, title: "밀키스제로 구매하기", isFavorite: false),
        ShoppingListModel(isDone: false, title: "M3 맥북 구매하기", isFavorite: false),
        ShoppingListModel(isDone: false, title: "양말", isFavorite: false)
    ]
    
    lazy var items = BehaviorSubject(value: ShoppingList)
    
    let disposeBag = DisposeBag()
    
//    init () {
//        bind()
//    }
//    
//    private func bind() {
//        
//        
//    }
    
}
