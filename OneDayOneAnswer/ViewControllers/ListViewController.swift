//
//  ListViewController.swift
//  OneDayOneAnswer
//
//  Created by Mihye Kim on 23/04/2020.
//  Copyright © 2020 JMJ. All rights reserved.
//

import UIKit

class ListViewController: BaseViewController {

    // MARK: - UI properties

    private let backgroundImage: UIImageView = {
        let iv = UIImageView()
        let image = UIImage(imageLiteralResourceName: "catcat0")
        iv.image = image
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.dataSource = self
        tv.delegate = self
        tv.backgroundColor = .clear
        tv.showsVerticalScrollIndicator = false
        tv.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tv.isHidden = true
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    private let label: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "나의 기록"
        lb.textColor = .white
        lb.font = UIFont(name: "DXPnMStd-Regular", size: 22)
        return lb
    }()

    // MARK: - properties

    private let displayViewControllerFactory: () -> DisplayViewController
    private let sqldb: DataBase
    private var articles: [Article] = []

    // MARK: - initializers

    init(
        displayViewControllerFactory: @escaping () -> DisplayViewController,
        dataBase: DataBase
    ) {
        self.displayViewControllerFactory = displayViewControllerFactory
        self.sqldb = dataBase
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - life cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadArticles()

        // TODO: - 유저 이름 표시하기
//        if let name = signManager?.user?.displayName {
//            self.label.text = "\(name)님의 기록"
//        }
    }

    // MARK: - methods

    override func onLoading() {
        super.onLoading()
        tableView.isHidden = true
    }

    override func onLoadingSuccess() {
        super.onLoadingSuccess()
        guard !articles.isEmpty else {
            state = .failure
            return
        }
        tableView.reloadData()
        tableView.isHidden = false
    }

    override func onLoadingFailure() {
        super.onLoadingFailure()
    }

    func loadArticles() {
        state = .loading
        DispatchQueue.global().async { [weak self] in
            guard let `self` = self else {
                return
            }
            let today = Date()
            self.articles = self.sqldb.selectArticles().filter { $0.date <= today }
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                self.state = .success
            }
        }
    }

    override func setAutoLayout() {
        view.addSubview(backgroundImage)
        view.addSubview(label)
        view.addSubview(tableView)

        [
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            label.heightAnchor.constraint(equalToConstant: 30),
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            tableView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 30),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 33),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -33)
        ].forEach { $0.isActive = true }
    }
}

// MARK: - UITableViewDataSource

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return articles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath)
        guard let tvCell = cell as? TableViewCell else {
            return cell
        }

        let item = articles[articles.count - indexPath.row - 1]

        tvCell.questionLabel.text = item.question
        tvCell.answerLabel.text = item.answer
        tvCell.dateLabel.text = dateToStr(item.date, "M월 d일")
        return tvCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

// MARK: - UITableViewDelegate

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let count = articles.count - 1
        let item = articles[count - (indexPath.row)]

        let displayVC = displayViewControllerFactory()
        displayVC.modalTransitionStyle = .flipHorizontal
        displayVC.modalPresentationStyle = .fullScreen
        displayVC.dateToSet = item.date
        present(displayVC, animated: true, completion: nil)
    }

}
