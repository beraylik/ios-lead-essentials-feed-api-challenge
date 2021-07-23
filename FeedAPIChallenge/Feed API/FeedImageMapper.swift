//
//  FeedImageMapper.swift
//  FeedAPIChallenge
//
//  Created by Genrikh Beraylik on 15.07.2021.
//  Copyright © 2021 Essential Developer Ltd. All rights reserved.
//

import Foundation

struct FeedLoaderMapper {
	private init() {}

	static func map(data: Data) throws -> [FeedImage] {
		let itemsList = try JSONDecoder().decode(FeedImageList.self, from: data)

		let feedImages = itemsList.items.map {
			FeedImage(id: $0.image_id,
			          description: $0.image_desc,
			          location: $0.image_loc,
			          url: $0.image_url)
		}
		return feedImages
	}

	// MARK: - Helper Structs

	private struct FeedImageList: Decodable {
		let items: [FeedImageDto]
	}

	private struct FeedImageDto: Decodable {
		let image_id: UUID
		let image_desc: String?
		let image_loc: String?
		let image_url: URL
	}
}
