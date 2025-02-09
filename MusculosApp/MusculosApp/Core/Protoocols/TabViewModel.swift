//
//  TabViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 09.02.2025.
//

protocol TabViewModel {
  /// Controls whether the tab's content should be reloaded.
  ///
  /// This property helps optimize tab switching performance by preventing unnecessary data loading.
  /// When `true`, the tab will load its content. When `false`, it will maintain its existing state.
  ///
  /// Typical use cases for returning `false`:
  /// - When switching back to a previously loaded tab that doesn't need fresh data
  /// - When the content is static or rarely changes
  /// - When implementing a caching strategy
  ///
  var shouldLoad: Bool { get async }
}
