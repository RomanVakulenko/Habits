//
//  SourceOfDescriptionVC.swift
//  Habits
//
//  Created by Roman Vakulenko on 24.11.2023.
//

import UIKit
import Kingfisher

final class SourceOfDescriptionVC: UIViewController {

    // MARK: - Private properties
    private lazy var viewForPictrure: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .gray
        return view
    }()

    private var model: SourceVCModel


    // MARK: - Init
    init(viewModel: SourceVCModel) {
        self.model = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        layout()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showImageWithKingFisher()
    }


    // MARK: - Private methods
    private func setupView() {
        view.backgroundColor = .white
        title = "Картинка через KingFisher"
        view.addSubview(viewForPictrure)
    }

    private func layout() {
        NSLayoutConstraint.activate([
            viewForPictrure.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            viewForPictrure.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            viewForPictrure.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            viewForPictrure.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -48),
        ])

    }

    private func showImageWithKingFisher() {
       //    Downloads a high-resolution image.
       //    Downsamples it to match the image view size.
       //    Makes it round cornered with a given radius.
       //    Shows a system indicator and a placeholder image while downloading.
       //    When prepared, it animates the small thumbnail image with a "fade in" effect.
       //    The original large image is also cached to disk for later use, to get rid of downloading it again in a detail view.
       //    A console log is printed when the task finishes, either for success or failure.
           let url = URL(string: "https://unsplash.com/photos/a-man-standing-on-top-of-a-roof-in-the-snow-m7yVul9-AbA")
           let processor = DownsamplingImageProcessor(size: viewForPictrure.bounds.size)
                        |> RoundCornerImageProcessor(cornerRadius: 10) //|> "pipe-forward" оператор, используется для передачи результата выражения слева от оператора в качестве 1ого аргумента функции справа от оператора.
        viewForPictrure.kf.indicatorType = .activity
        viewForPictrure.kf.setImage(
               with: url,
               placeholder: UIImage(named: "placeholderImage"),
               options: [
                   .processor(processor),
                   .scaleFactor(UIScreen.main.scale),
                   .transition(.fade(1)),
                   .cacheOriginalImage
               ])
           {
               result in
               switch result {
               case .success(let value):
                   print("Task done for: \(value.source.url?.absoluteString ?? "")")
               case .failure(let error):
                   print("Job failed: \(error.localizedDescription)")
               }
           }
    }
}
