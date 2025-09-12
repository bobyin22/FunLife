//
//  HomeViewController.swift
//  FunLife
//
//  Created by 尹周舶 on 2023/6/15.
//

import UIKit
import Combine
import Foundation
import AVFoundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class HomeViewController: UIViewController {

    let homeView = HomeView()
    let viewModel: HomeViewModel

    var settingButtonItem = UIBarButtonItem()
    var addTaskButtonItem = UIBarButtonItem()

    let soundID = SystemSoundID(kSystemSoundID_Vibrate)     // 震動

    lazy var addTaskVC: AddTaskViewController = {
        let addTaskVM = AddTaskViewModel(firebaseService: FirebaseManager())
        return AddTaskViewController(viewModel: addTaskVM)
    }()

    private var cancellables = Set<AnyCancellable>()

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.viewModel = HomeViewModel(firebaseService: FirebaseManager())
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupHomeView()

        // 使用 NotificationCenter 監聽裝置方向變化的通知 UIDevice.orientationDidChangeNotification，一旦收到該通知，就會調用 orientationChanged 方法
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(orientationChanged),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: nil)
        print("函式執行後", UserDefaults.standard.dictionaryRepresentation())

        navbarAndtabbarsetup()
        dataBinding()
    }

    private func dataBinding() {

        viewModel.$formattedTime
            .receive(on: RunLoop.main)
            .sink { [weak self] time in
                self?.homeView.circleTimerLabel.text = time
            }
            .store(in: &cancellables)

        addTaskVC.viewModel.$editingTaskText
            .receive(on: RunLoop.main)
            .sink { [weak self] name in
                self?.viewModel.currentTaskText = name
            }
            .store(in: &cancellables)

        viewModel.$currentTaskText
            .sink { [weak self] name in
                self?.homeView.circleTaskButton.setTitle(name, for: .normal)  // UI 從 ViewModel 取得
            }
            .store(in: &cancellables)

        viewModel.$shouldVibrate
            .sink { shouldVibrate in
                if shouldVibrate {
                    AudioServicesPlaySystemSound(self.soundID)
                    self.viewModel.shouldVibrate = false
                }
            }
            .store(in: &cancellables)

        viewModel.$shouldShowAlert
            .sink { [weak self] shouldShow in
                if shouldShow {
                    if let content = self?.viewModel.alertContent {
                        self?.alertMsg(title: content.title, mssage:
                                            content.message)
                    }
                    self?.viewModel.shouldShowAlert = false
                }
            }
            .store(in: &cancellables)

        viewModel.$shouldPlayMusic
            .sink { [weak self] shouldPlay in
                if shouldPlay {
                    self?.viewModel.playMusic()
                    self?.viewModel.shouldPlayMusic = false
                }
            }
            .store(in: &cancellables)

        viewModel.$shouldNavigateToAddTask
              .sink { [weak self] shouldNavigate in
                  if shouldNavigate {
                      guard let self = self else { return }
                      self.navigationController?.pushViewController(self.addTaskVC, animated: true)
                      self.viewModel.shouldNavigateToAddTask = false
                  }
              }
              .store(in: &cancellables)
    }

    // MARK: 設定nav tab 底色與字顏色
    func navbarAndtabbarsetup() {
        // 設置 NavigationBar 的外觀
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true

        // 設置 TabBar 的外觀
        tabBarController?.tabBar.backgroundColor = UIColor(red: 42/255, green: 42/255, blue: 42/255, alpha: 1.0)
        tabBarController?.tabBar.barTintColor = UIColor(red: 42/255, green: 42/255, blue: 42/255, alpha: 1.0)
        tabBarController?.tabBar.shadowImage = UIImage()
        tabBarController?.tabBar.isTranslucent = false
    }

    // MARK: 讓每次返回本頁會顯示
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: 頁面出現後開啟Notification
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: nil)
    }

    // MARK: 頁面要消失的時候關掉Notification
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    // MARK: 建立UI NavBar +按鈕 與 設定按鈕
    func setupNavigation() {
        addTaskButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                            target: self,
                                            action: #selector(navToAddTaskVC))
        addTaskButtonItem.tintColor = UIColor(red: 186/255, green: 129/255, blue: 71/255, alpha: 1)

        navigationItem.rightBarButtonItems = [addTaskButtonItem]    // 一個按鈕
    }

    // MARK: 跳轉頁 點擊Nav進入跳轉新增任務頁面VC
    @objc func navToAddTaskVC() {
        viewModel.triggerAddTaskNavigation()
    }

    // MARK: 把自定義的View設定邊界
    func setupHomeView() {
        view.addSubview(homeView)
        homeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            homeView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            homeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            homeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            homeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)   // view.safeAreaLayoutGuide.bottomAnchor
        ])

        homeView.backgroundColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        homeView.circleTaskButton.addTarget(self, action: #selector(clickTaskBtn), for: .touchUpInside)
    }

    // MARK: 點擊任務按鈕會發生的事
    @objc func clickTaskBtn() {
        // 5️⃣ 當作是自己
        let sheetTaskVC = SheetTaskViewController()
        if let sheetPresentationController = sheetTaskVC.sheetPresentationController {
            sheetPresentationController.detents = [.medium()]
            sheetPresentationController.preferredCornerRadius = 60
        }

        // 6️⃣
        sheetTaskVC.delegate = self
        present(sheetTaskVC, animated: true)
    }

    @objc func orientationChanged() {
        viewModel.handleOrientationChange(UIDevice.current.orientation)
    }

    // MARK: 翻正面 提示框
    private func alertMsg (title: String, mssage: String) {
        let alert = UIAlertController(title: title, message: mssage,preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"),
                                      style: .default,
                                      handler: { _ in NSLog("The \"OK\" alert occured.")})
        )
        self.present(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension HomeViewController: SheetTaskViewControllerDelegate {
    func passValueTime(_ VC: SheetTaskViewController, parameterTime: String) {
    }

    // MARK: Delegate傳值
    func passValue(_ VC: SheetTaskViewController, parameter: String) {
//        print("傳出來的String Task是", parameter)
//        homeView.circleTaskButton.setTitle(parameter, for: .normal)
    }
}
