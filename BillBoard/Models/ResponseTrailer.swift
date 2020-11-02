//
//  ResponseTrailer.swift
//  BillBoard
//
//  Created by Héctor Cuevas Morfín on 02/11/20.
//

import Foundation

struct ResponseTrailer: Decodable {
	var id: Int
	var results: [Video]
}
