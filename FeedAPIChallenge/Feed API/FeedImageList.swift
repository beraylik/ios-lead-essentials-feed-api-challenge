//
//  FeedImageList.swift
//  FeedAPIChallenge
//
//  Created by Genrikh Beraylik on 15.07.2021.
//  Copyright © 2021 Essential Developer Ltd. All rights reserved.
//

import Foundation

struct FeedImageList: Decodable {
	let items: [FeedImage]

	struct FeedImage: Decodable {
		let id: UUID
		let description: String?
		let location: String?
		let url: URL

		enum CodingKeys: String, CodingKey {
			case id = "image_id"
			case description = "image_desc"
			case location = "image_loc"
			case url = "image_url"
		}
	}
}
