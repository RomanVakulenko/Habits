//
//  InfoViewController.swift
//  Habits
//
//  Created by Roman Vakulenko on 29.06.2023.
//

import UIKit


final class InfoViewController: UIViewController {

    // MARK: - Private properties
    private var viewModel: InfoViewModel

    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .natural
        textView.textColor = .black

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        paragraphStyle.paragraphSpacing = 8
        //        paragraphStyle.firstLineHeadIndent = 8.0 // Горизонтальный отступ для первой строки абзаца
        //        paragraphStyle.headIndent = 20.0 // Горизонтальный отступ для остальных строк абзаца

        let titleString = NSAttributedString(
            string: "Привычка за 21 день\n",
            attributes: [NSAttributedString.Key.font: UIFont(name: "SFProDisplay-Semibold", size: 20.0)!,
                         NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )
        let attributedText = NSAttributedString(
            string: "1. Провести 1 день без обращения к старым привычкам, стараться вести себя так, как будто цель, загаданная в перспективу, находится на расстоянии шага.\n2. Выдержать 2 дня в прежнем состоянии самоконтроля.\n3. Отметить в дневнике первую неделю изменений и подвести первые итоги — что оказалось тяжело, что — легче, с чем еще предстоит серьезно бороться.\n4. Поздравить себя с прохождением первого серьезного порога в 21 день. За это время отказ от дурных наклонностей уже примет форму осознанного преодоления и человек сможет больше работать в сторону принятия положительных качеств.\n5. Держать планку 40 дней. Практикующий методику уже чувствует себя освободившимся от прошлого негатива и двигается в нужном направлении с хорошей динамикой.\n6. На 90-й день соблюдения техники все лишнее из «прошлой жизни» перестает напоминать о себе, и человек, оглянувшись назад, осознает себя полностью обновившимся.\n",
            attributes: [NSAttributedString.Key.font: UIFont(name: "SFProText-Regular", size: 17.0)!,
                         NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )
        let referenceString = NSMutableAttributedString( //visual style, hyperlinks, or accessibility data) for portions of its text. Have additional methods for mutating the content of an attributed string.
            string: "Источник: psychbook.ru",
            attributes: [NSAttributedString.Key.font: UIFont(name: "SFProText-Regular", size: 17.0)!,
                         NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )
        if let url = URL(string: "https://psychbook.ru") {
            referenceString.addAttribute(.link, value: url, range: NSRange(location: 10, length: 12)) // после 10ого символа начинается ссылка и ее длинна 12 символов
        }

        let result = NSMutableAttributedString()
        result.append(titleString)
        result.append(attributedText)
        result.append(referenceString)

        textView.attributedText = result
        textView.scrollRangeToVisible(NSRange(location: 0, length: 0))

        return textView
    }()

    // MARK: - Init
    init(viewModel: InfoViewModel) {
        self.viewModel = viewModel
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Источник",
            style: .plain,
            target: self,
            action: #selector(showInfoSource))
    }

    // MARK: - Private methods
    private func setupView() {
        view.backgroundColor = .white
        title = "Информация"
        view.addSubview(textView)
    }

    private func layout() {
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

//MARK: - actions
    @objc func showInfoSource(_sender: UIBarButtonItem) {
        viewModel.didTapInfoSourceVC()
    }
}


//с использованием scrollView, contentView, stackView (нарушает DRY для текста)
//final class InfoViewController: UIViewController {
//
//    // MARK: - Private properties
//    private var viewModel: InfoViewModel
//
//    // MARK: - Subviews
//    private lazy var scrollView: UIScrollView = {
//        let scrollView = UIScrollView()
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.showsVerticalScrollIndicator = false
//        return scrollView
//    }()
//
//    private lazy var contentView: UIView = {
//        let contentView = UIView()
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.clipsToBounds = true
//        return contentView
//    }()
//
//    private lazy var textTitle: UILabel = {
//        let textTitle = UILabel()
//        textTitle.translatesAutoresizingMaskIntoConstraints = false
//        textTitle.font = UIFont(name: "SFProDisplay-Semibold", size: 20.0)
//        textTitle.textColor = .black
//        textTitle.text = "Привычка за 21 день"
//        return textTitle
//    }()
//
//    private lazy var text0: UILabel = {
//        let infoText = UILabel()
//        infoText.translatesAutoresizingMaskIntoConstraints = false
//        infoText.font = UIFont(name: "SFProText-Regular", size: 17.0)
//        infoText.textColor = .black
//        infoText.text = "Прохождение этапов, за которые за 21 день вырабатывается привычка, подчиняется следующему алгоритму:"
//        infoText.lineBreakMode = .byWordWrapping
//        infoText.numberOfLines = 0
//        return infoText
//    }()
//
//    private lazy var text1: UILabel = {
//        let infoText = UILabel()
//        infoText.translatesAutoresizingMaskIntoConstraints = false
//        infoText.font = UIFont(name: "SFProText-Regular", size: 17.0)
//        infoText.textColor = .black
//        infoText.text = "1. Провести 1 день без обращения к старым привычкам, стараться вести себя так, как будто цель, загаданная в перспективу, находится на расстоянии шага."
//        infoText.numberOfLines = 0
//        return infoText
//    }()
//
//    private lazy var text2: UILabel = {
//        let infoText = UILabel()
//        infoText.translatesAutoresizingMaskIntoConstraints = false
//        infoText.font = UIFont(name: "SFProText-Regular", size: 17.0)
//        infoText.textColor = .black
//        infoText.text = "2. Выдержать 2 дня в прежнем состоянии самоконтроля."
//        infoText.numberOfLines = 0
//        return infoText
//    }()
//
//    private lazy var text3: UILabel = {
//        let infoText = UILabel()
//        infoText.translatesAutoresizingMaskIntoConstraints = false
//        infoText.font = UIFont(name: "SFProText-Regular", size: 17.0)
//        infoText.textColor = .black
//        infoText.text = "3. Отметить в дневнике первую неделю изменений и подвести первые итоги — что оказалось тяжело, что — легче, с чем еще предстоит серьезно бороться."
//        infoText.numberOfLines = 0
//        return infoText
//    }()
//
//    private lazy var text4: UILabel = {
//        let infoText = UILabel()
//        infoText.translatesAutoresizingMaskIntoConstraints = false
//        infoText.font = UIFont(name: "SFProText-Regular", size: 17.0)
//        infoText.textColor = .black
//        infoText.text = "4. Поздравить себя с прохождением первого серьезного порога в 21 день. За это время отказ от дурных наклонностей уже примет форму осознанного преодоления и человек сможет больше работать в сторону принятия положительных качеств."
//        infoText.numberOfLines = 0
//        return infoText
//    }()
//
//    private lazy var text5: UILabel = {
//        let infoText = UILabel()
//        infoText.translatesAutoresizingMaskIntoConstraints = false
//        infoText.font = UIFont(name: "SFProText-Regular", size: 17.0)
//        infoText.textColor = .black
//        infoText.text = "5. Держать планку 40 дней. Практикующий методику уже чувствует себя освободившимся от прошлого негатива и двигается в нужном направлении с хорошей динамикой."
//        infoText.numberOfLines = 0
//        return infoText
//    }()
//
//    private lazy var text6: UILabel = {
//        let infoText = UILabel()
//        infoText.translatesAutoresizingMaskIntoConstraints = false
//        infoText.font = UIFont(name: "SFProText-Regular", size: 17.0)
//        infoText.textColor = .black
//        infoText.text = "6. На 90-й день соблюдения техники все лишнее из «прошлой жизни» перестает напоминать о себе, и человек, оглянувшись назад, осознает себя полностью обновившимся."
//        infoText.numberOfLines = 0
//        return infoText
//    }()
//
//    private lazy var text7: UILabel = {
//        let infoText = UILabel()
//        infoText.translatesAutoresizingMaskIntoConstraints = false
//        infoText.font = UIFont(name: "SFProText-Regular", size: 17.0)
//        infoText.textColor = .black
//        infoText.text = "Источник: psychbook.ru"
//        return infoText
//    }()
//
//    private lazy var stackView: UIStackView = {
//        let stack = UIStackView(arrangedSubviews: [text0, text1, text2, text3, text4, text5, text6, text7])
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.clipsToBounds = true
//        stack.axis = .vertical
//        stack.alignment = .fill
//        stack.distribution = .fill
//        stack.backgroundColor = .white
//        stack.spacing = 12.0
//        return stack
//    }()
//
//    // MARK: - Init
//    init(viewModel: InfoViewModel) {
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    // MARK: - Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupView()
//        layout()
//    }
//
//    // MARK: - Private methods
//    private func setupView() {
//        view.backgroundColor = .white
//        title = "Информация"
//        view.addSubview(scrollView)
//        scrollView.addSubview(contentView)
//        contentView.addSubview(textTitle)
//        contentView.addSubview(stackView)
//    }
//
//    private func layout() {
//        NSLayoutConstraint.activate([
//            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//
//            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
//            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
//            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
//            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
//            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
//            //constrains of content
//            textTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            textTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            textTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22),
//
//            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 62),
//            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//        ])
//    }
//}
