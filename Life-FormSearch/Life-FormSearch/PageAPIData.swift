//
//  PageAPIData.swift
//  Life-FormSearch
//
//  Created by Wesley Keetch on 1/7/25.
//

import Foundation

struct PageResponse: Codable {
  let details: TaxonConcept
  enum codingKeys: String, CodingKey {
    case details = "taxonConcept"
  }
}

struct TaxonConcept: Codable {
  let scientificName: String?
  let identifier: Int?
  let dataObjects: [DataObject]?
  let taxonConcepts: [TaxonDescription]?
  enum CodingKeys: String, CodingKey {
    case scientificName, identifier, dataObjects, taxonConcepts
  }
}

struct DataObject: Codable {
  let eolMediaURL: String?
  let mimeType: String?
  let license: String?
  let rightsHolder: String?
  let agents: [Agent]?
  enum CodingKeys: String, CodingKey {
    case eolMediaURL, mimeType, license, rightsHolder, agents
  }
}

struct Agent: Codable {
  let role: String?
  let fullName: String?
  enum CodingKeys: String, CodingKey {
    case role
    case fullName = "full_name"
  }
}

struct TaxonDescription: Codable {
  let nameAccordingTo: String?
  let identifier: Int?
  let scientificName: String?
  enum CodingKeys: String, CodingKey {
    case nameAccordingTo, identifier, scientificName
  }
}

extension EOLAPIManager {
  func fetchPageDetails(for id: Int) async throws -> PageResponse {
    let urlString = "https://eol.org/api/pages/1.0/\(id).json"
    var components = URLComponents(string: urlString)!
    components.queryItems = [
      URLQueryItem(name: "taxonomy", value: "true"),
      URLQueryItem(name: "images_per_page", value: "1"),
      URLQueryItem(name: "language", value: "en"),
    ]
    guard let url = components.url else {
      throw URLError(.badURL)
    }
    let (data, _) = try await URLSession.shared.data(from: url)
    return try JSONDecoder().decode(PageResponse.self, from: data)
  }
}
