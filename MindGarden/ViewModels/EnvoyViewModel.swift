//
//  EnvoyViewModel.swift
//  MindGarden
//
//  Created by Vishal Davara on 15/10/22.
//

import Foundation
import Combine

class EnvoyViewModel: ObservableObject {
    
    @Published var url: String = ""
    @Published var userQuota: Int = 0
    var cancellationToken: AnyCancellable?

}

extension EnvoyViewModel {
    
    func generateLink(body:EnvoyData) {
        cancellationToken = EnvoyDB.request(body:body)
            .mapError({ (error) -> Error in
                print(error)
                return error
            })
            .sink(receiveCompletion: { _ in },
                  receiveValue: {
                self.url = $0.url ?? ""
            })
    }
    
    func getGiftQuota() {
        var userID = UUID().uuidString
        if let uID = UserDefaults.standard.value(forKey: K.defaults.giftQuotaId) as? String, uID.count > 0 {
            userID = uID
        } else {
            UserDefaults.standard.setValue(userID, forKey: K.defaults.giftQuotaId)
        }
        
        let url = URL(string: "\(EnvoyDB.giftUrl)\(userID)")
        cancellationToken = EnvoyDB.getRequest(url:url)
            .mapError({ (error) -> Error in
                print(error)
                return error
            })
            .sink(receiveCompletion: { _ in },
                  receiveValue: {
                self.userQuota = $0.userRemainingQuota ?? 0
            })
    }
    
}


struct APIClient {

    struct Response<T> {
        let value: T
        let response: URLResponse
    }
    
    func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<Response<T>, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { result -> Response<T> in
                let value = try JSONDecoder().decode(T.self, from: result.data)
                return Response(value: value, response: result.response)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}


enum EnvoyDB {
    static let apiClient = APIClient()
    static let baseUrl = URL(string: "https://osh7r2l4od.execute-api.eu-west-2.amazonaws.com/prod/partner/create-link")
    static let giftUrl = "https://osh7r2l4od.execute-api.eu-west-2.amazonaws.com/prod/partner/user-quota/"
    static let key = "X2BWh9IFnCaGheUIJ3bjN1M6a7t8hY924EXGavEI"
    
    //TODO: uncomment below for send box
//    static let baseUrl = URL(string: "https://osh7r2l4od.execute-api.eu-west-2.amazonaws.com/prod/partner/create-sandbox-link")
}

extension EnvoyDB {
    
    static func request(body:EnvoyData ) -> AnyPublisher<EnvoyResponse, Error> {
        guard let url = baseUrl else { fatalError("Couldn't get url") }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(EnvoyDB.key, forHTTPHeaderField: "x-api-key")
        
        let jsonData = try? JSONEncoder().encode(body)
        request.httpBody = jsonData
        
        return apiClient.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    static func getRequest(url:URL?) -> AnyPublisher<UserQuota, Error> {
        guard let url = url else { fatalError("Couldn't get url") }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(EnvoyDB.key, forHTTPHeaderField: "x-api-key")
        
        return apiClient.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}




