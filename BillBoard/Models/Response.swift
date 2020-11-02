//
//  Response.swift
//  BillBoard
//
//  Created by Héctor Cuevas Morfín on 02/11/20.
//

import Foundation

//In this case we dont save the information for that reason its recomendable to use only the decodable instead a codable that use Decodable and Encodable

struct Response: Decodable {
	var page : Int
	var total_results: Int
	var total_pages: Int
	var results: [Movie]
}
