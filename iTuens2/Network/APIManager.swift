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

    func request() {
        AF
            .request(
                "https://itunes.apple.com/search?term=kakao&country=kr&lang=ko_kr&entity=software&limit=10",
                method: .get
            )
            .validate()
            .responseDecodable(of: AppInfoContainer.self) { response in
                switch response.result {
                case .success(let succes):
                    print("✅ \(succes)")
                case .failure(let error):
                    print("❌ \(error)")
                }
            }
    }

}
