//
//  Exercise.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 04.02.2024.
//

import Foundation

struct Exercise: Codable {
  var id: UUID
  var primaryMuscles: [String]
  var secondaryMuscles: [String]
  var force: ForceType?
  var level: Level?
  var equipment: String?
  var category: String?
  var instructions: [String]
  let name: String
  var imageUrl: URL? {
    return images.first
  }
  var images: [URL] = []
  
  enum CodingKeys: String, CodingKey {
    case id, force, level, equipment, category, instructions, name
    case primaryMuscles = "primary_muscles"
    case secondaryMuscles = "secondary_muscles"
  }
  
  enum ForceType: String, Codable {
    case pull, push, stay = "static"
  }
  
  enum Level: String, Codable {
    case intermediate, beginner, expert
  }
  
  var imageFolder: String {
    let formatted = name.replacingOccurrences(of: " ", with: "_").replacingOccurrences(of: "/", with: "_")
    return  "\(formatted)/images"
  }
  
  var firstImagePath: String {
    "\(imageFolder)/0.jpg"
  }

  func getImagesPaths(_ filesCount: Int) -> [String] {
    var pathList: [String] = []
    
    if filesCount > 0 {
      for i in 0...filesCount {
        let imagePath = "\(imageFolder)/\(i).jpg"
        pathList.append(imagePath)
      }
    }
    return pathList
  }
  
  mutating func addImageUrl(_ imageUrl: URL?) {
    guard let imageUrl else { return }
    images.append(imageUrl)
  }
}
