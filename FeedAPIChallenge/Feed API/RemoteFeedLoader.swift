//
//  Copyright © 2018 Essential Developer. All rights reserved.
//

import Foundation

struct FeedImageList: Decodable {
	let items: [FeedImage]

	struct FeedImage: Decodable {
		let id: UUID
		let description: String?
		let location: String?
		let url: URL
	}
}

public final class RemoteFeedLoader: FeedLoader {
	private let url: URL
	private let client: HTTPClient

	public enum Error: Swift.Error {
		case connectivity
		case invalidData
	}

	public init(url: URL, client: HTTPClient) {
		self.url = url
		self.client = client
	}

	public func load(completion: @escaping (FeedLoader.Result) -> Void) {
		client.get(from: url) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case let .success((data, response)):
				let successResult = self.handleSuccess(data: data, response: response)
				completion(successResult)
			default:
				completion(.failure(Error.connectivity))
			}
		}
	}

	private func handleSuccess(data: Data, response: HTTPURLResponse) -> FeedLoader.Result {
		guard response.statusCode == 200 else {
			return .failure(Error.invalidData)
		}

		guard let itemsList = try? JSONDecoder().decode(FeedImageList.self, from: data) else {
			return .failure(Error.invalidData)
		}

		let feedImages = itemsList.items.map({
			FeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url)
		})

		return .success(feedImages)
	}
}
