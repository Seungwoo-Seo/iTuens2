//
//  SearchViewModel.swift
//  iTunes
//
//  Created by 서승우 on 2023/11/12.
//

import Foundation
import RxCocoa
import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
}

final class SearchViewModel: ViewModelType {
    private let disposeBag = DisposeBag()

    private let sectionList: BehaviorRelay<[AppInfoContainer]> = BehaviorRelay(value: [])


    let error: PublishRelay<Error> = PublishRelay()


    struct Input {
        let query: ControlProperty<String?>
        let searchButtonClicked: ControlEvent<Void>

        let itemSelected: ControlEvent<IndexPath>
        let modelSelected: ControlEvent<AppInfo>
    }

    struct Output {
        let queryIsEmpty: BehaviorRelay<Bool>
        let sectionList: BehaviorRelay<[AppInfoContainer]>
        let containerList: PublishRelay<[AppInfoContainer]>
    }

    func transform(input: Input) -> Output {
        let queryIsEmpty: BehaviorRelay<Bool> = BehaviorRelay(value: true)
        let containerList: PublishRelay<[AppInfoContainer]> = PublishRelay()

        input.query
            .orEmpty
            .map { $0.isEmpty }
            .filter { $0 }
            .bind(with: self) { owner, bool in
                queryIsEmpty.accept(bool)
            }
            .disposed(by: disposeBag)




        // 1
//        input.searchButtonClicked
//            .throttle(.seconds(1), scheduler: MainScheduler.instance)
//            .withLatestFrom(input.query.orEmpty) { _, query in
//                return query
//            }
//            .filter { !$0.isEmpty }
//            .bind(with: self) { owner, query in
//                owner.requestFlow(query: query)
//            }
//            .disposed(by: disposeBag)


        // 2
//        input.searchButtonClicked
//            .throttle(.seconds(1), scheduler: MainScheduler.instance)
//            .withLatestFrom(input.query.orEmpty) { _, query in
//                return query
//            }
//            .filter { !$0.isEmpty }
//            .flatMap {
//                APIManager.shared.testRequest(query: $0)
//            }
//            .subscribe { result in
//                switch result {
//                case .success(let container):
//                    print("success")
//                case .failure(let error):
//                    print("failure")
//                }
//            } onError: { error in
//                print("onError")
//            } onCompleted: {
//                print("onCompleted")
//            } onDisposed: {
//                print("onDisposed")
//            }
//            .disposed(by: disposeBag)

        error
            .bind(with: self) { owner, error in
                print("먼 에러 ---> \(error)")
            }
            .disposed(by: disposeBag)

        // 3
        input.searchButtonClicked
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.query.orEmpty) { _, query in
                return query
            }
            .filter { !$0.isEmpty }
            .flatMap {
                return APIManager.shared.bestRequest(query: $0)
                    .catch { error in
                        self.error.accept(error)
                        return Single.just(AppInfoContainer())
                    }
            }
            .subscribe { container in
                print(container)
                print("asfasfasdfadsfasdf")

                print("success")
            } onError: { error in
                print("----------->", error)
            } onCompleted: {
                print("completed")
            } onDisposed: {
                print("disposed")
            }
            .disposed(by: disposeBag)

        Observable
            .zip(
                input.itemSelected,
                input.modelSelected
            )
            .map {
                [AppInfoContainer(items: [$0.1])]
            }
            .bind(with: self) { owner, list in
                containerList.accept(list)
            }
            .disposed(by: disposeBag)


        return Output(
            queryIsEmpty: queryIsEmpty,
            sectionList: sectionList,
            containerList: containerList
        )
    }

    func requestFlow(query: String) {
        APIManager.shared.request(query: query)
            .subscribe(with: self) { owner, container in
                owner.sectionList.accept([container])
            } onFailure: { owner, error in
                // error Observable에 이벤트 방출
                print("❌ 에러임 \(error.localizedDescription)")
            } onDisposed: { owner in
                print("onDisposed")
            }
            .disposed(by: disposeBag)
    }

}

