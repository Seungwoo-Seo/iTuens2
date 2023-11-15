//
//  SearchViewController.swift
//  iTunes
//
//  Created by 서승우 on 2023/11/10.
//

import UIKit
import RxCocoa
import RxDataSources
import RxSwift

final class SearchViewController: BaseViewController {
    lazy var searchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchBar.placeholder = "게임, 앱, 스토리 등"
        return controller
    }()
    lazy var tableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.separatorStyle = .none
        view.rowHeight = UITableView.automaticDimension
        view.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.identifier)
        return view
    }()

    private let viewModel = SearchViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.prefersLargeTitles = true
    }


    private func bind() {
        let input = SearchViewModel.Input(
            query: searchController.searchBar.rx.text,
            searchButtonClicked: searchController.searchBar.rx.searchButtonClicked,
            itemSelected: tableView.rx.itemSelected,
            modelSelected: tableView.rx.modelSelected(AppInfo.self)
        )
        
        let output = viewModel.transform(input: input)

        output.queryIsEmpty
            .bind(with: self) { owner, bool in
                owner.tableView.isHidden = bool
            }
            .disposed(by: disposeBag)

        output.containerList
            .bind(with: self) { owner, list in
                let vc = DetailViewController()
                vc.appInfoContainer.accept(list)
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)

        // config
        let dataSource = RxTableViewSectionedReloadDataSource<AppInfoContainer>(
            configureCell: { dataSource, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: SearchResultCell.identifier,
                    for: indexPath
                ) as? SearchResultCell

                cell?.bind(with: item)

                return cell ?? UITableViewCell()
            })

        output.sectionList
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        output.sectionList
            .bind(with: self) { owner, container in
                owner.tableView.isHidden = false
            }
            .disposed(by: disposeBag)
    }

    override func initialAttributes() {
        super.initialAttributes()

        view.backgroundColor = .systemBackground
        navigationItem.title = "검색"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        view.addSubview(tableView)
    }

    override func initialLayout() {
        super.initialLayout()

        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

}
