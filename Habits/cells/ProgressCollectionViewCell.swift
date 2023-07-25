//
//  ProgressCollectionViewCell.swift
//  Habits
//
//  Created by Roman Vakulenko on 18.07.2023.
//

import UIKit

final class ProgressCollectionViewCell: UICollectionViewCell {

    private let whiteView: UIView = {
        let whiteView = UIView()
        whiteView.translatesAutoresizingMaskIntoConstraints = false
        whiteView.backgroundColor = .white
        whiteView.layer.cornerRadius = 8
        return whiteView
    }()

    private let progressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.progress = 0
        progress.observedProgress?.totalUnitCount = 100
        progress.progressTintColor = #colorLiteral(red: 0.6309858561, green: 0.08523046225, blue: 0.8001720309, alpha: 1)
        progress.trackTintColor = #colorLiteral(red: 0.8487350345, green: 0.8487350941, blue: 0.8487350345, alpha: 1)
        return progress
    }()

    private let labelView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 0.557, green: 0.557, blue: 0.576, alpha: 1)
        label.text = "Все получится!"
        label.font = UIFont(name: "SFProText-Semibold", size: 13)
        return label
    }()

    private lazy var percentLabelView: UILabel = {
        let progressLabel = UILabel()
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        progressLabel.textColor = UIColor(red: 0.557, green: 0.557, blue: 0.576, alpha: 1)
        progressLabel.font = UIFont(name: "SFProText-Semibold", size: 13)
        progressLabel.textAlignment = .right
        return progressLabel
    }()
    

    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - setup
    func setupProgressCell(with value: Float) {
        percentLabelView.text = String(value * 100) + "%"
        progressView.setProgress(value, animated: true)
    }

    //MARK: - layout
    private func layout() {
        [progressView, labelView, percentLabelView].forEach { whiteView.addSubview($0) }
        contentView.addSubview(whiteView)

        NSLayoutConstraint.activate([
            whiteView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            whiteView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            whiteView.topAnchor.constraint(equalTo: contentView.topAnchor),
            whiteView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            labelView.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor, constant: 12),
            labelView.topAnchor.constraint(equalTo: whiteView.topAnchor, constant: 10),
            labelView.heightAnchor.constraint(equalToConstant: 18),

            percentLabelView.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor, constant: -12),
            percentLabelView.topAnchor.constraint(equalTo: whiteView.topAnchor, constant: 10),
            percentLabelView.heightAnchor.constraint(equalToConstant: 18),

            progressView.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor, constant: 12),
            progressView.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor, constant: -12),
            progressView.topAnchor.constraint(equalTo: percentLabelView.bottomAnchor, constant: 10),
            progressView.bottomAnchor.constraint(equalTo: whiteView.bottomAnchor, constant: -15),
            progressView.heightAnchor.constraint(equalToConstant: 7)
        ])

    }
}
