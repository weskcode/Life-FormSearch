//
//  SearchAPIData.swift
//  Life-FormSearch
//
//  Created by Wesley Keetch on 1/7/25.
//

import Foundation

struct SearchResult: Codable {
  let id: Int
  let title: String
  let content: String?
  let link: String
}

struct SearchResponse: Codable {
  let results: [SearchResult]
}

class EOLAPIManager {
  static let shared = EOLAPIManager()

  let baseURL = "https://eol.org/api/search/1.0.json"

  func fetchSearchResults(query: String) async throws -> [SearchResult] {
    var components = URLComponents(string: baseURL)!
    components.queryItems = [
      URLQueryItem(name: "q", value: query),
      URLQueryItem(name: "page", value: "1"),
    ]
    guard let url = components.url else {
      throw URLError(.badURL)
    }
    let (data, _) = try await URLSession.shared.data(from: url)
    print(data)
    let searchResponse = try JSONDecoder().decode(
      SearchResponse.self, from: data)
    return searchResponse.results
  }
}

extension Data {
  func prettyPrintedJSONString() {
    guard
      let jsonObject = try? JSONSerialization.jsonObject(
        with: self, options: []),
      let jsonData = try? JSONSerialization.data(
        withJSONObject: jsonObject, options: [.prettyPrinted]),
      let prettyJSONString = String(data: jsonData, encoding: .utf8)
    else {
      print("Failed to read JSON object.")
      return
    }
    print(prettyJSONString)
  }
}
