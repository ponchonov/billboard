//
//  Response.swift
//  BillBoard
//
//  Created by Héctor Cuevas Morfín on 02/11/20.
//

import Foundation

struct Response: Decodable {
	var page : Int
	var total_results: Int
	var total_pages: Int
	var results: [Movie]
}
