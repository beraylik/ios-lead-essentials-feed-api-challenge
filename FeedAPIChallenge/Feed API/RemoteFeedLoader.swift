//
//  Copyright © 2018 Essential Developer. All rights reserved.
//

import Foundation

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

	private let OK_STATUS_CODE = 200
	
	private func handleSuccess(data: Data, response: HTTPURLResponse) -> FeedLoader.Result {
		guard response.statusCode == OK_STATUS_CODE else {
			return .failure(Error.invalidData)
		}
		do {
			let items = try FeedLoaderMapper.map(data: data)
			return .success(items)
		} catch {
			return .failure(Error.invalidData)
		}
	}
}
