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
        controller.searchBar.delegate = self
        return controller
    }()
    lazy var tableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.separatorStyle = .none
        view.rowHeight = UITableView.automaticDimension
        view.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.identifier)
        return view
    }()

    let viewModel = SearchViewModel()
    let disposeBag = DisposeBag()
    let sections: BehaviorRelay<[AppInfoContainer]> = BehaviorRelay(value: [])

    override func viewDidLoad() {
        super.viewDidLoad()

        bind()

//        APIManager.shared.request { [weak self] appContainer in
//            guard let self else {return}
//            self.sections.accept([appContainer])
//        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.prefersLargeTitles = true
    }


    func bind() {
        searchController.searchBar.rx.text
            .orEmpty
            .map { $0.isEmpty }
            .bind(with: self) { owner, bool in
                if bool {
                    owner.tableView.isHidden = bool
                }
            }
            .disposed(by: disposeBag)

        searchController.searchBar.rx.searchButtonClicked
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(searchController.searchBar.rx.text.orEmpty) { _, query in
                return query
            }
            .filter { !$0.isEmpty }
            .bind(with: self) { owner, query in
                APIManager.shared.request(query: query) { appInfoConatiner in
                    owner.sections.accept([appInfoConatiner])

                    DispatchQueue.main.async {
                        owner.tableView.isHidden = false
                    }
                }
            }
            .disposed(by: disposeBag)


        Observable
            .zip(
                tableView.rx.itemSelected,
                tableView.rx.modelSelected(AppInfo.self)
            )
            .bind(with: self) { owner, value in
                let vc = DetailViewController()

                let container = AppInfoContainer(items: [value.1])
                vc.appInfoContainer.accept([container])

                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)





        let input = SearchViewModel.Input(

        )
        
        let output = viewModel.transform(input: input)

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

        // output
        sections
            .bind(to: tableView.rx.items(dataSource: dataSource))
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

extension SearchViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
    }

}

