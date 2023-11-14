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

    struct Input {

    }

    struct Output {

    }

    func transform(input: Input) -> Output {

        return Output()
    }
}
