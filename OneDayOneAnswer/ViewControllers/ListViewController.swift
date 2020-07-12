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

    private let backgroundImage: UIImageView = UIImageView()
    private let tableView: UITableView = UITableView()

    // MARK: - properties

    private let displayViewControllerFactory: DisplayViewControllerFactory
    private let sqldb: DataBase
    private var articles: [Article] = []

    // MARK: - life cycle

    init(
        displayViewControllerFactory: @escaping DisplayViewControllerFactory,
        dataBase: DataBase
    ) {
        self.displayViewControllerFactory = displayViewControllerFactory
        self.sqldb = dataBase
        super.init()

        setTableView()
        bindStyles()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadArticles()
    }

    // MARK: - methods

    private func setTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
    }

    private func bindStyles() {
        self.navigationItem.title = "나의 기록"

        _ = self.backgroundImage
            |> defaultBackgroundImageViewStyle()

        _ = self.tableView
            |> defaultTableViewStyle()
    }

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
        view.addSubview(tableView)

        self.backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 33),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -33)
        ])
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

        let displayVC = displayViewControllerFactory(item.date)
        navigationController?.pushViewController(displayVC, animated: true)
    }

}
