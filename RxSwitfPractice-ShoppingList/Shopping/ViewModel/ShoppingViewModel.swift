//
//  ShoppingViewModel.swift
//  RxSwitfPractice-ShoppingList
//
//  Created by JinwooLee on 4/1/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ShoppingViewModel {
        
    var input = Input()
    let output = Output()
    let disposeBag = DisposeBag()
    
    struct Input {
        
        var ShoppingList : [ShoppingListModel] = [
            ShoppingListModel(_id : UUID().uuidString, isDone: false, title: "그립톡 구매하기", isFavorite: false),
            ShoppingListModel(_id : UUID().uuidString, isDone: false, title: "밀키스제로 구매하기", isFavorite: false),
            ShoppingListModel(_id : UUID().uuidString, isDone: false, title: "M3 맥북 구매하기", isFavorite: false),
            ShoppingListModel(_id : UUID().uuidString, isDone: false, title: "양말", isFavorite: false)
        ]
        
        lazy var inputItems = BehaviorSubject(value: ShoppingList)
        let inputDoneButtonTap = PublishRelay<Int>()
        let inputFavoriteButtonTap = PublishRelay<Int>()
        let inputTextAdd = PublishSubject<String>()
        let inputSearchText = PublishSubject<String>()
        let inputDeleteRow = PublishSubject<IndexPath>()
    }
    
    struct Output {
        let outputItems = BehaviorRelay<[ShoppingListModel]>(value: [])
    }
    
    
    init() {
        transfrom()
    }
    
    private func transfrom() {
        
        input.inputItems
            .bind(with:self) { owner, value in
                owner.output.outputItems.accept(value)
            }
            .disposed(by: disposeBag)
        
        input.inputDoneButtonTap
            .bind(with:self) { owner, value in
                owner.input.ShoppingList[value].isDone.toggle()
                owner.output.outputItems.accept(owner.input.ShoppingList)
            }
            .disposed(by: disposeBag)
        
        input.inputFavoriteButtonTap
            .bind(with:self) { owner, value in
                owner.input.ShoppingList[value].isFavorite.toggle()
                owner.output.outputItems.accept(owner.input.ShoppingList)
            }
            .disposed(by: disposeBag)
        
        
        input.inputTextAdd
            .bind(with:self) { owner, value in
                
                let newItem =  ShoppingListModel(_id : UUID().uuidString, isDone: false, title: value, isFavorite: false)
                owner.input.ShoppingList.append(newItem)
                owner.output.outputItems.accept(owner.input.ShoppingList)
            }
            .disposed(by: disposeBag)
        
        input.inputSearchText
            .bind(with: self) { owner, value in
                    
                let searchResult = value.isEmpty ? owner.input.ShoppingList : owner.input.ShoppingList.filter { $0.title.contains(value)}
                owner.output.outputItems.accept(searchResult)
            }
            .disposed(by: disposeBag)
        
        input.inputDeleteRow
            .bind(with: self) { owner, value in
                    
                print(value)
                
                owner.output.outputItems.accept(owner.input.ShoppingList)
            }
            .disposed(by: disposeBag)
    }
    
}



