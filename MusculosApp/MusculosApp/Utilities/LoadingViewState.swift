//
//  LoadingViewState.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 20.02.2024.
//

import Foundation

enum LoadingViewState<T> {
  case loading
  case loaded(T)
  case empty
  case error(String)
}
