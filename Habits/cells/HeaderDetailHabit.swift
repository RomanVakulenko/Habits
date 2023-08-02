//
//  HeaderDetailHabit.swift
//  Habits
//
//  Created by Roman Vakulenko on 29.07.2023.
//

import UIKit

final class HeaderDetailHabit: UIView {

    private lazy var header: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SFProText-Regular", size: 13)
        label.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.6)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//MARK: - private

    private func layout() {
        addSubview(header)
        NSLayoutConstraint.activate([
            header.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            header.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            header.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            header.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }

    func setup(textForHeader: String){
        header.text = textForHeader
    }

}
