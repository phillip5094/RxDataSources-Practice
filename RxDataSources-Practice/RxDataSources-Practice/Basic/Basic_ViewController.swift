//
//  Basic_ViewController.swift
//  RxDataSources-Practice
//
//  Created by Philip Chung on 2022/10/03.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class Basic_ViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private let disposeBag = DisposeBag()

    private var sections = BehaviorSubject(value: [
        SectionOfBasicData(header: "Basic_First", items: [
            BasicData(title: "1111"),
            BasicData(title: "2222")
        ]),
        SectionOfBasicData(header: "Basic_Second", items: [
            BasicData(title: "3333"),
            BasicData(title: "4444")
        ]),
        SectionOfBasicData(header: "Basic_Third", items: [
            BasicData(title: "5555"),
            BasicData(title: "6666"),
            BasicData(title: "7777"),
        ])
    ])
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.setEditing(true, animated: true)
        tableView.isEditing = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfBasicData>(configureCell: { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
            cell.textLabel?.text = item.title
            return cell
        })
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            /*
             subscript 때문에 아래 코드는 동일한 코드임.
             */
            return dataSource[index].header
            // return dataSource.sectionModels[index].header
        }

        dataSource.canMoveRowAtIndexPath = { dataSource, index in
            /*
             내부적으로 무언가를 하는건 아니고, binding 이후에 설정하는 경우 크래시를 냄.
             결국 tableView delegate에 설정한 값을 그대로 리턴하는 역할
             */
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
                sections[indexPath.section] = SectionOfBasicData(original: sections[indexPath.section], items: items)
                owner.sections.onNext(sections)
            })
            .disposed(by: disposeBag)
    }
}
