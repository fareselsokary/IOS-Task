//
//  UIImageViewExtension.swift
//  IOS Task
//
//  Created by fares on 05/12/2021.
//

import Combine
import UIKit

private var subscriptions: Set<AnyCancellable> = []

extension UIImageView {
    private func downloaded(from url: URL) -> AnyPublisher<UIImage?, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { response in
                UIImage(data: response.data)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func downloaded(from link: String) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url).sink { completion in
            switch completion {
            case .finished:
                print("fininsh download image")
            case let .failure(error):
                print(error)
            }
        } receiveValue: { [weak self] image in
            self?.image = image
        }
        .store(in: &subscriptions)
    }
}
