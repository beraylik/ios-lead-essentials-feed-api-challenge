//
//  FeedImageMapper.swift
//  FeedAPIChallenge
//
//  Created by Genrikh Beraylik on 15.07.2021.
//  Copyright © 2021 Essential Developer Ltd. All rights reserved.
//

import Foundation

final class FeedLoaderMapper {
	static func map(data: Data) throws -> [FeedImage] {
		let itemsList = try JSONDecoder().decode(FeedImageList.self, from: data)

		let feedImages = itemsList.items.map {
			FeedImage(id: $0.id,
			          description: $0.description,
			          location: $0.location,
			          url: $0.url)
		}
		return feedImages
	}
}
