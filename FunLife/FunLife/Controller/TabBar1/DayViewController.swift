//
//  DayViewController.swift
//  FunLife
//
//  Created by 尹周舶 on 2023/6/17.
//

import UIKit
import Combine
import FSCalendar

class DayViewController: UIViewController, FSCalendarDelegate {

    let viewModel: DayViewModel

    var calendar: FSCalendar!
    let myTableView = UITableView()
    
    let selectedBackgroundView = UIView()
    private var cancellables = Set<AnyCancellable>()

    required init?(coder: NSCoder) {
        let firebaseManager = FirebaseManager()
        self.viewModel = DayViewModel(firebaseService: firebaseManager)
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendar()
        calendar.delegate = self
        
        setupMyTableView()
        myTableView.register(DayTableViewCell.self, forCellReuseIdentifier: "DayTableViewCell")
        myTableView.delegate = self
        myTableView.dataSource = self
        
        myTableView.rowHeight = UITableView.automaticDimension
        myTableView.estimatedRowHeight = UITableView.automaticDimension
        
        navbarAndtabbarsetup()
        setupDayVCNavBarColor()
        
        selectedBackgroundView.backgroundColor = UIColor(red: 58/255, green: 58/255, blue: 60/255, alpha: 1)

        biding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetch()
        self.myTableView.reloadData()
    }

    func biding() {
        viewModel.$tasks
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.myTableView.reloadData()
            }
            .store(in: &cancellables)
    }

    // MARK: 設定nav tab 底色與字顏色
    func navbarAndtabbarsetup() {
        // 設置 NavigationBar 的外觀
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        tabBarController?.tabBar.barTintColor = UIColor(red: 42/255, green: 42/255, blue: 42/255, alpha: 1.0)
        tabBarController?.tabBar.shadowImage = UIImage()
        tabBarController?.tabBar.isTranslucent = false
    }
    
    // MARK: 設定第三方套件日曆View尺寸
    func setupCalendar() {
        calendar = FSCalendar(frame: CGRect.zero)
        calendar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calendar)

        // 設定頂部對齊約束
        let topConstraint = calendar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0)
        topConstraint.isActive = true

        // 設定其他約束
        NSLayoutConstraint.activate([
            calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendar.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        calendar.scrollDirection = .vertical
        calendar.scope = .month
        calendar.backgroundColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        
        calendar.appearance.headerTitleColor = UIColor(red: 185/255, green: 131/255, blue: 69/255, alpha: 1)
        calendar.appearance.selectionColor = .blue
        calendar.appearance.weekdayTextColor = .white
        calendar.appearance.titleDefaultColor = .white
    }
    
    // MARK: - Delegate
    // MARK: 點擊日，會印出當日日期
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        viewModel.selectDate(date)
    }
    
    func setupDayVCNavBarColor() {
        let dayVCNavBarColorView = UIView()
        view.addSubview(dayVCNavBarColorView)
        dayVCNavBarColorView.backgroundColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        dayVCNavBarColorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dayVCNavBarColorView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            dayVCNavBarColorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            dayVCNavBarColorView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            dayVCNavBarColorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
        ])
    }
    
    // MARK: 建置自訂義的tableView尺寸
    func setupMyTableView() {
        view.addSubview(myTableView)
        myTableView.backgroundColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        myTableView.separatorStyle = .none
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myTableView.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 0),
            myTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            myTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            myTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
    }
}

// MARK: 寫入自定義tableView的指派工作
extension DayViewController: UITableViewDelegate {
    
}

// MARK: 寫入自定義tableView的資料
extension DayViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   willDisplayHeaderView view: UIView,
                   forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor(red: 185/255, green: 131/255, blue: 69/255, alpha: 1) // UIColor.orange
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        header.textLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        // 設定左邊距約束
        let leadingConstraint = header.textLabel?.leadingAnchor.constraint(equalTo: header.contentView.leadingAnchor, constant: 10)
        leadingConstraint?.isActive = true
        
        header.contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            header.contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            header.contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            header.contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            header.contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
        header.textLabel?.textAlignment = .left
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.headTitle
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.taskCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: "DayTableViewCell",
                                                        for: indexPath) as? DayTableViewCell
        else {
            // 處理轉換失敗的情況，例如創建一個預設的 UITableViewCell
            return UITableViewCell()
        }
        cell.backgroundColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        cell.settingInfo.text = viewModel.getTask(at: indexPath.row)
        cell.selectedBackgroundView = selectedBackgroundView

        let taskTime = Int(viewModel.getTaskTime(at: indexPath.row))
        cell.settingTime.text = taskTime?.toTimeString()
        return cell
        
    }
}
