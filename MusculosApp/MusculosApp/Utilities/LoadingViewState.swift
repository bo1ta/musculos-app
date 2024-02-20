//
//  LoadingViewState.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 20.02.2024.
//

import Foundation

enum LoadingViewState<Result> {
  case loading
  case loaded(Result)
  case empty(String)
  case error(String)
}
