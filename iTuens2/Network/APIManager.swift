//
//  APIManager.swift
//  iTunes
//
//  Created by 서승우 on 2023/11/12.
//

import Foundation
import Alamofire
import RxSwift

enum NetworkError: Error {
    case one
    case two
    case three
}

final class APIManager {
    static let shared = APIManager()

    private init() {}

    func request(query: String, completion: @escaping (AppInfoContainer) -> ()) {
        let url = "https://itunes.apple.com/search?term=\(query)&country=kr&lang=ko_kr&entity=software&limit=10"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        AF
            .request(
                url,
                encoding: JSONEncoding.default
            )
            .validate()
            .responseDecodable(of: AppInfoContainer.self) { response in
                switch response.result {
                case .success(let succes):
                    completion(succes)
                case .failure(let error):
                    print("❌ \(error)")
                }
            }
    }



    func request(query: String, completion: @escaping (Result<AppInfoContainer, AFError>) -> ()) {
        let url = "https://itunes.apple.com/search?term=\(query)&country=kr&lang=ko_kr&entity=software&limit=10"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        AF
            .request(url)
            .validate()
            .responseDecodable(of: AppInfoContainer.self) { response in
                completion(response.result)
            }
    }

    func request(query: String) -> Single<AppInfoContainer> {
        return Single.create { (single) -> Disposable in

            let url = "https://itunes.apple.com/search?term=\(query)&country=kr&lang=ko_kr&entity=software&limit=10"
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

            AF
                .request(url)
                .validate()
                .responseDecodable(of: AppInfoContainer.self) { response in
                    switch response.result {
                    case .success(let container):
                        single(.success(container))
                    case .failure(let error):
                        single(.failure(NetworkError.one))
                    }
                }

            return Disposables.create()
        }
    }


    func testRequest(query: String) -> Single<Result<AppInfoContainer, Error>> {
        return Single.create { (single) -> Disposable in

            let url = "https://itunes.apple.com/search?term=\(query)&country=kr&lang=ko_kr&entity=software&limit=10"
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

            AF
                .request(url)
                .validate()
                .responseDecodable(of: AppInfoContainer.self) { response in
                    switch response.result {
                    case .success(let container):
                        single(.success(.success(container)))
                    case .failure(let error):
                        single(.success(.failure(error)))
                    }
                }

            return Disposables.create()
        }
    }

    func bestRequest(query: String) -> Single<AppInfoContainer> {
        return Single.create { (single) -> Disposable in

            let url = "https://itunes.apple.com/search?term=\(query)&country=kr&lang=ko_kr&entity=software&limit=10"
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

            AF
                .request(url)
                .validate()
                .responseDecodable(of: AppInfoContainer.self) { response in
                    switch response.result {
                    case .success(let container):
                        single(.success(container))

                    case .failure:
                        single(.failure(NetworkError.one))
                    }
                }

            return Disposables.create()
        }
        .debug()
    }


//    func request(completion: @escaping (AppInfoContainer) -> ()) {
//        AF
//            .request(
//                "https://itunes.apple.com/search?term=kakao&country=kr&lang=ko_kr&entity=software&limit=10",
//                method: .get
//            )
//            .validate()
//            .responseDecodable(of: AppInfoContainer.self) { response in
//                switch response.result {
//                case .success(let succes):
//                    completion(succes)
//                case .failure(let error):
//                    print("❌ \(error)")
//                }
//            }
//    }

}
