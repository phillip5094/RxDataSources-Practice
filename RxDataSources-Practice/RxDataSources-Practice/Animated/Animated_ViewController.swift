//
//  Animated_ViewController.swift
//  RxDataSources-Practice
//
//  Created by Philip Chung on 2022/11/05.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class Animated_ViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private let disposeBag = DisposeBag()

    private var sections = BehaviorSubject(value: [
        SectionOfAnimatedData(header: "Animated_First", items: [
            AnimatedData(title: "1111"),
            AnimatedData(title: "2222")
        ]),
        SectionOfAnimatedData(header: "Animated_Second", items: [
            AnimatedData(title: "3333"),
            AnimatedData(title: "4444")
        ]),
        SectionOfAnimatedData(header: "Animated_Third", items: [
            AnimatedData(title: "5555"),
            AnimatedData(title: "6666"),
            AnimatedData(title: "7777"),
        ])
    ])

    override func viewDidLoad() {
        super.viewDidLoad()

        let dataSource = RxTableViewSectionedAnimatedDataSource<SectionOfAnimatedData>(animationConfiguration: AnimationConfiguration(insertAnimation: .top, reloadAnimation: .fade, deleteAnimation: .left)) { data, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnimatedCell", for: indexPath)
            cell.textLabel?.text = item.title
            return cell
        }

        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource[index].header
        }

        dataSource.canMoveRowAtIndexPath = { dataSource, index in
            return false
        }

        dataSource.canEditRowAtIndexPath = { dataSource, index in
            return true
        }
        
        self.sections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        tableView.rx.itemDeleted
            .subscribe(with: self, onNext: { owner, indexPath in
                guard var sections = try? owner.sections.value() else { return }
                var items = sections[indexPath.section].items
                items.remove(at: indexPath.row)
                sections[indexPath.section] = SectionOfAnimatedData(original: sections[indexPath.section], items: items)
                owner.sections.onNext(sections)
            })
            .disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.setEditing(true, animated: true)
        tableView.isEditing = true
    }
}

