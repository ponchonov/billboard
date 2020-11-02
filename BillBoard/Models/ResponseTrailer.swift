//
//  ResponseTrailer.swift
//  BillBoard
//
//  Created by Héctor Cuevas Morfín on 02/11/20.
//

import Foundation

//In this case we dont save the information for that reason its recomendable to use only the decodable instead a codable that use Decodable and Encodable

struct ResponseTrailer: Decodable {
	var id: Int
	var results: [Video]
}
