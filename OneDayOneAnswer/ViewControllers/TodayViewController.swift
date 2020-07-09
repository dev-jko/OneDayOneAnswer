//
//  TodayViewController.swift
//  OneDayOneAnswer
//
//  Created by Mihye Kim on 23/04/2020.
//  Copyright © 2020 JMJ. All rights reserved.
//

import UIKit

// MARK: - UIViewController

class TodayViewController: BaseViewController {

    // MARK: - UI properties

    private let backgroundImage: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()

    private let bottomBox: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let questionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "DXPnMStd-Regular", size: 18)
        label.numberOfLines = 0
        label.textAlignment = .justified
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var answerText: UITextView = {
        let tv = UITextView()
        tv.textColor = .white
        tv.font = UIFont(name: "DXPnMStd-Regular", size: 17)
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    private let saveBtn: UIBarButtonItem = UIBarButtonItem(
        image: #imageLiteral(resourceName: "outline_save_black_36pt").withRenderingMode(.alwaysTemplate),
        style: .done,
        target: self,
        action: #selector(btnSaveTouchOn(_:))
    )

    // MARK: - Properties

    private let sqldb: DataBase
    private var article: Article?
    private var dateToSet: Date?
    private var imagePath: String?
    let picker = UIImagePickerController()

    // MARK: - Lifecycle

    init(dataBase: DataBase, date: Date? = nil) {
        self.sqldb = dataBase
        self.dateToSet = date
        super.init()

        let image = #imageLiteral(resourceName: "outline_image_black_36pt").withRenderingMode(.alwaysTemplate)
        let imagePickerBtnItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(pickImage(_:)))
        navigationItem.setRightBarButtonItems([saveBtn, imagePickerBtnItem], animated: true)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setArticle()

        picker.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: - Functions

    override func setAutoLayout() {
        setBottomBox()
        view.addSubview(backgroundImage)
        view.addSubview(bottomBox)

        [
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            bottomBox.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            bottomBox.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            bottomBox.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 33),
            bottomBox.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -33)

        ].forEach { $0.isActive = true }
    }

    private func setBottomBox() {
        bottomBox.addSubview(questionLabel)
        bottomBox.addSubview(answerText)

        [
            questionLabel.topAnchor.constraint(equalTo: bottomBox.topAnchor, constant: 30),
            questionLabel.leadingAnchor.constraint(equalTo: bottomBox.leadingAnchor, constant: 25),
            questionLabel.trailingAnchor.constraint(equalTo: bottomBox.trailingAnchor, constant: -25),

            answerText.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 30),
            answerText.bottomAnchor.constraint(equalTo: bottomBox.bottomAnchor, constant: -30),
            answerText.leadingAnchor.constraint(equalTo: bottomBox.leadingAnchor, constant: 25),
            answerText.trailingAnchor.constraint(equalTo: bottomBox.trailingAnchor, constant: -25)

        ].forEach { $0.isActive = true }

    }

    override func onLoading() {
        super.onLoading()
        bottomBox.isHidden = true
    }

    override func onLoadingSuccess() {
        guard article != nil else {
            state = .failure
            return
        }
        super.onLoadingSuccess()
        beginAnimate()
        showArticle()
        adjustWritingMode()
        bottomBox.isHidden = false
    }

    override func onLoadingFailure() {
        super.onLoadingFailure()
    }

    private func setArticle() {
        state = .loading
        if dateToSet == nil {
            dateToSet = Date()
        }
        guard let date = dateToSet else {
            state = .failure
            return
        }
        DispatchQueue.global().async { [weak self] in
            guard let `self` = self else { return }
            self.article = self.sqldb.selectArticle(date: date)
            self.imagePath = self.article?.imagePath
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                self.state = .success
            }
        }
    }

    private func beginAnimate() {
        bottomBox.alpha = 0
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            guard let `self` = self else { return }
            self.bottomBox.alpha = 1
        })
    }

    private func showArticle() {
        guard let article = self.article else {
            state = .failure
            return
        }
        navigationItem.title = dateToStr(article.date, "M월 d일")
        answerText.text = article.answer
        questionLabel.text = article.question

        if article.imagePath == "" {
            backgroundImage.image = UIImage(named: "catcat0")
        } else {
            backgroundImage.image = getUIImageFromDocDir(fileName: article.imagePath)
        }
    }

    private func adjustWritingMode() {
        if answerText.text == article?.answer && imagePath == article?.imagePath {
            saveBtn.isEnabled = false
            saveBtn.tintColor = .gray
        } else {
            saveBtn.isEnabled = true
            saveBtn.tintColor = .systemBlue
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @objc func btnListTouchOn(_ sender: UIButton) {
        if answerText.text != article?.answer {
            let dataLostAlert = UIAlertController(title: "작성한 내용을 잃게되어요",
                                                  message: "그래도 계속 할까요?",
                                                  preferredStyle: .alert)
            let doAction: UIAlertAction = UIAlertAction(title: "네", style: .default) { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            let undoAction: UIAlertAction = UIAlertAction(title: "아니오", style: .default)
            dataLostAlert.addAction(doAction)
            dataLostAlert.addAction(undoAction)
            present(dataLostAlert, animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    @objc func btnSaveTouchOn(_ sender: UIButton) {
        guard var article = article else { print("save error article is nil"); return }
        article.answer = answerText.text
        article.imagePath = imagePath ?? ""
        if sqldb.updateArticle(article: article) == true {
            self.navigationController?.popViewController(animated: true)
        } else {
            print("Update Test Error!")
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print("info: \(info)")
            backgroundImage.contentMode = .scaleAspectFill
            backgroundImage.image = pickedImage

            guard let fileName: String = saveUIImageToDocDir(image: pickedImage) else {
                print("save error")
                return
            }
            imagePath = fileName
            adjustWritingMode()
        }
        self.dismiss(animated: true, completion: nil)
    }

    @objc func pickImage(_ sender: Any) {
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
}

// MARK: - UITextViewDelegate

extension TodayViewController: UITextViewDelegate {
    func textViewDidChange(_ textViewAnswer: UITextView) {
        adjustWritingMode()
    }
}

// MARK: - UIImagePickerControllerDelegate

extension TodayViewController: UIImagePickerControllerDelegate {

}

// MARK: - UINavigationControllerDelegate

extension TodayViewController: UINavigationControllerDelegate {

}
