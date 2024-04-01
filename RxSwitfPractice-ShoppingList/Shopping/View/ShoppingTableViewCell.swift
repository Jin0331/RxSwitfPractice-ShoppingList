//
//  ShoppingTableViewCell.swift
//  RxSwitfPractice-ShoppingList
//
//  Created by JinwooLee on 4/1/24.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class ShoppingTableViewCell: UITableViewCell {
    
    static let identifier = "ShoppingTableViewCell"
    
    var disposeBag = DisposeBag()
    
    let doneButton = UIButton().then {
        $0.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        $0.tintColor = .black
    }
    
    let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
    }
    
    let favoriteButton = UIButton().then {
        $0.setImage(UIImage(systemName: "star"), for: .normal)
        $0.tintColor = .black
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none

        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        contentView.addSubview(doneButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(favoriteButton)
        
        doneButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(20)
            make.size.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(doneButton)
            make.leading.equalTo(doneButton.snp.trailing).offset(15)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(20)
            make.size.equalTo(30)
        }
    }
    
    func updateUI(data : ShoppingListModel) {
        titleLabel.text = data.title
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
}
