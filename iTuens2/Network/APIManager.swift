//
//  APIManager.swift
//  iTunes
//
//  Created by 서승우 on 2023/11/12.
//

import Foundation
import Alamofire

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


    func request(completion: @escaping (AppInfoContainer) -> ()) {
        AF
            .request(
                "https://itunes.apple.com/search?term=kakao&country=kr&lang=ko_kr&entity=software&limit=10",
                method: .get
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

}
