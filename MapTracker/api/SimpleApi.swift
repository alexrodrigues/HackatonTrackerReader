//
//  SimpleApi.swift
//  MapTracker
//
//  Created by Alex Rodrigues on 1/19/20.
//  Copyright © 2020 Alex Rodrigues. All rights reserved.
//

import UIKit

protocol SimpleApiDelegate {
    func didFinishParse(list: [TrackLocation])
}

class SimpleApi {

    private let baseUrl = "https://app-alexrodrigues-tracker.herokuapp.com/Route"
    private var remoteTask: URLSessionTask!
    
    func fetchData(delegate: SimpleApiDelegate) {
            guard let url = URL(string: baseUrl)  else {
                return
            }
            var urlRequest = URLRequest(url: url)
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            remoteTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard let dataReceived = data else {
                    return
                }
                do {
                    let objectResponse = try JSONDecoder().decode([TrackLocation].self, from: dataReceived)
                    delegate.didFinishParse(list: objectResponse)
                } catch {
                    print("")
                }
            };
            remoteTask.resume()
    }
}
