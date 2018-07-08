//
//  TrackModel.swift
//  p_iTuneMusic
//
//  Created by Saffi on 2018/7/8.
//  Copyright © 2018 Saffi. All rights reserved.
//

import Foundation


struct Track: Codable {
    var artworkUrl100: URL  //album cover
    var trackName: String
    var artistName: String
    var collectionName: String?

    var previewUrl: URL     //play

    var trackPrice: Double?
    var releaseDate: Date
    var isStreamable: Bool?
}

//Track result: API fetched
struct TrackData: Codable {
    var resultCount: Int
    var results: [Track]
}

