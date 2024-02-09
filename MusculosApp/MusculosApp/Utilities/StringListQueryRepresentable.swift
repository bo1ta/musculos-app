//
//  StringListQueryRepresentable.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 09.02.2024.
//

import Foundation
import PostgREST

struct StringListQueryRepresentable: URLQueryRepresentable {
  let list: [String]

  var queryValue: String {
    return #"{\#(list.map { "\"\($0)\"" }.joined(separator: ","))}"#
  }
}
