//
//  API.swift
//  BillBoard
//
//  Created by Héctor Cuevas Morfín on 02/11/20.
//

import Foundation

class API: NSObject {
	static let shared = API()
	
	var baseURL = "https://api.themoviedb.org"
	var apiKey = "663bdcca49cb692e08017d6dd8b68a64"
	var currentPage = 1
	var language = "en"
	var currentFilter = "popular"
	
	override init() {
		super.init()
	}
	
	private func mutableRequest(url:URL) -> URLRequest {
		
		let headers = [
			"accept": "application/json",
			"content-type": "application/json",
		]
		var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 20)
		
		request.allHTTPHeaderFields = headers
		
		return request
	}
	
	private func apiCallWith(request:URLRequest,parameters:Dictionary<String,String>?, completion: @escaping (_ data:Data?,_ response: URLResponse?, _ error: Error?) -> Void) {
		
		let session = URLSession.shared
		var requestToSend = request;
		
		
		if let parameters = parameters  {
			for (key,value) in parameters {
				if var urlComp = URLComponents(url: requestToSend.url!, resolvingAgainstBaseURL: false)  {
					let queryItem = URLQueryItem(name: key, value: value)
					
					if (urlComp.queryItems == nil) {
						urlComp.queryItems = [URLQueryItem]()
					}
					
					urlComp.queryItems?.append(queryItem)
					if let finalurl = urlComp.url {
						requestToSend.url = finalurl
					}
				}
			}
		}
		
		let dataTask = session.dataTask(with: requestToSend) { (data, response, error) in
			completion(data,response,error)
		}
		dataTask.resume()
		
	}
	
	public func getMovies( nextPage:Bool = false, completion: @escaping ([Movie],_ error: Error?) -> Void) {
		if currentPage < 0 {
			currentPage = 1
		}
		guard let url = URL(string: "\(baseURL)/3/movie/\(currentFilter)")
		else {
			let error = NSError(domain: "", code: -100, userInfo: [:])
			completion([], error)
			return
		}
		
		if nextPage {
			currentPage = currentPage + 1
		}
		
		var request = mutableRequest(url: url)
		request.httpMethod = "GET"
		
		let parameters = [
			"api_key": apiKey,
			"page":"\(currentPage)",
			"language": language
		]
		
		apiCallWith(request: request, parameters: parameters) { (data, response, error) in
			
			if (error != nil) {
				self.currentPage = self.currentPage - 1
				print(error ?? " ")
				completion([], error)
			} else {
				do {
					let decoder = JSONDecoder()
					guard let data = data else {return}
					let responseObject =  try decoder.decode(Response.self, from: data)
					
					
					let results = responseObject.results
					
					completion(results, nil)
				} catch let e {
					self.currentPage = self.currentPage - 1
					completion([], e)
				}
			}
		}
	}
	
	public func getTrailers(movieId:Int, completion: @escaping ([Video],_ error: Error?) -> Void) {
		guard let url = URL(string: "\(baseURL)/3/movie/\(movieId)/videos")
		else {
			let error = NSError(domain: "", code: -100, userInfo: [:])
			completion([], error)
			return
		}
		
		
		var request = mutableRequest(url: url)
		request.httpMethod = "GET"
		
		let parameters = [
			"api_key": apiKey
		]
		
		apiCallWith(request: request, parameters: parameters) { (data, response, error) in
			
			if (error != nil) {
				print(error ?? " ")
				completion([], error)
			} else {
				do {
					let decoder = JSONDecoder()
					guard let data = data else {return}
					let responseObject =  try decoder.decode(ResponseTrailer.self, from: data)
					
					let results = responseObject.results
					
					completion(results, nil)
				} catch let e {
					completion([], e)
				}
			}
		}
	}
	
}
