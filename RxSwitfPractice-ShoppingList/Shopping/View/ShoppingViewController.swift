//
//  ShoppingViewController.swift
//  RxSwitfPractice-ShoppingList
//
//  Created by JinwooLee on 4/1/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class ShoppingViewController: UIViewController {
    
    private let textField = UITextField().then {
        $0.placeholder = "무엇을 구매하실 건가요?"
        $0.borderStyle = .roundedRect
        $0.backgroundColor = .systemGray6
    }
    
    private let textAddButton = UIButton().then {
        $0.setTitle("추가", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 12, weight: .heavy)
        $0.backgroundColor = .systemGray4
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    private let tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.register(ShoppingTableViewCell.self, forCellReuseIdentifier: ShoppingTableViewCell.identifier)
        $0.backgroundColor = .systemGray6
    }
    
    private let viewModel = ShoppingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        configureLayout()
        configureView()
        configureNavigation()
        
        bindData()
        
    }
    
    // 이것이 MVVM은 아닌 것 같다 ㅎㅎ;;;;
    // RxSwift + MVVM은 공부하고 적용해야할 듯
    private func bindData() {
        
        // 즐겨찾기 및 완료 기능
        viewModel.items
            .bind(to: tableView.rx.items(cellIdentifier: ShoppingTableViewCell.identifier, cellType: ShoppingTableViewCell.self)) { row, element, cell in
                
                cell.doneButton
                    .rx
                    .tap
                    .subscribe(with: self) { owner, _ in
                        print("isDone Button 눌림 🔆 ", row)
                        owner.viewModel.ShoppingList[row].isDone.toggle()
                        owner.viewModel.items.onNext(owner.viewModel.ShoppingList)
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.favoriteButton
                    .rx
                    .tap
                    .subscribe(with: self) { owner, _ in
                        print("isFavorite Button 눌림 🔆 ", row)
                        owner.viewModel.ShoppingList[row].isFavorite.toggle()
                        owner.viewModel.items.onNext(owner.viewModel.ShoppingList)
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.updateUI(data: element)
            }
            .disposed(by: viewModel.disposeBag)
        
        // 추가
        // 중복체크 해야되는데.. 일단 최소 기능만
        textAddButton
            .rx
            .tap
            .withLatestFrom(textField.rx.text.orEmpty)
            .bind(with: self) { owner, value in
                print("입력된 값 ", value)
                owner.viewModel.ShoppingList.append(ShoppingListModel(isDone: false, title: value, isFavorite: false))
                owner.viewModel.items.onNext(owner.viewModel.ShoppingList)
                
            }
            .disposed(by: viewModel.disposeBag)
                
        // 화면전환
        tableView
            .rx
            .itemSelected
            .bind(with : self){ owner,  _ in
                owner.navigationController?.pushViewController(ViewController(), animated: true)
            }
            .disposed(by: viewModel.disposeBag)
        
        // 실시간 검색
        textField
            .rx
            .text
            .orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                print("실시간 검색 : ", value)
                
                let result = value.isEmpty ? owner.viewModel.ShoppingList : owner.viewModel.ShoppingList.filter { $0.title.contains(value)}
                owner.viewModel.items.onNext(result)
            }
            .disposed(by: viewModel.disposeBag)
        
    }
    
    
    private func configureLayout() {
        view.addSubview(textField)
        view.addSubview(textAddButton)
        view.addSubview(tableView)
        
        textField.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(5)
            make.height.equalTo(50)
        }
        
        textAddButton.snp.makeConstraints { make in
            make.centerY.equalTo(textField)
            make.trailing.equalTo(textField).inset(20)
            make.width.equalTo(40)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom)
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureView() {
        view.backgroundColor = .white
    }
    
    private func configureNavigation() {
        // 배경색
        navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = .black
        navigationController?.navigationBar.barTintColor = UIColor.black

        navigationItem.title = "쇼핑"
    }
}
