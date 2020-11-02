//
//  Movie.swift
//  BillBoard
//
//  Created by Héctor Cuevas Morfín on 02/11/20.
//

import Foundation


struct Movie: Decodable {
	var id:Int
	var popularity : Float
	var vote_count: Int
	var video: Bool
	var poster_path: String
	var backdrop_path: String
	var original_language: String
	var original_title: String
	var title: String
	var vote_average: Float
	var overview: String
	var release_date: String
}
