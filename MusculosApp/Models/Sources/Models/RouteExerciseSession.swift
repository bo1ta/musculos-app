//
//  RouteExerciseSession.swift
//  Models
//
//  Created by Solomon Alexandru on 17.01.2025.
//

import CoreLocation
import Foundation

public struct RouteExerciseSession: Sendable {
  public var uuid: UUID
  public var originCoordinate: CLLocationCoordinate2D
  public var destinationCoordinate: CLLocationCoordinate2D
  public var distance: Double
  public var duration: Double
  public var averagePace: Double
  public var averageSpeed: Double
  public var caloriesBurned: Double?
  public var elevationGain: Double?
  public var originLocationName: String
  public var destinationLocationName: String
  public var dateStarted: Date
  public var dateFinished: Date
  public var weather: String?
  public var averageHeartRate: Int?
  public var maxHeartRate: Int?
  public var splits: [Double]?
  public var routeType: RouteType
  public var terrainType: TerrainType
  public var notes: String?
  public var tags: [String]
  public var userID: UUID

  public enum RouteType: String, Sendable {
    case circular, outAndBack, oneWay
  }

  public enum TerrainType: String, Sendable {
    case road, trail, beach, treadmill, mixed
  }

  public init(
    uuid: UUID = UUID(),
    originCoordinate: CLLocationCoordinate2D,
    destinationCoordinate: CLLocationCoordinate2D,
    distance: Double,
    duration: Double,
    averagePace: Double,
    averageSpeed: Double,
    caloriesBurned: Double? = nil,
    elevationGain: Double? = nil,
    originLocationName: String,
    destinationLocationName: String,
    dateStarted: Date,
    dateFinished: Date,
    weather: String? = nil,
    averageHeartRate: Int? = nil,
    maxHeartRate: Int? = nil,
    splits: [Double]? = nil,
    routeType: RouteType,
    terrainType: TerrainType,
    notes: String? = nil,
    tags: [String],
    userID: UUID)
  {
    self.uuid = uuid
    self.originCoordinate = originCoordinate
    self.destinationCoordinate = destinationCoordinate
    self.distance = distance
    self.duration = duration
    self.averagePace = averagePace
    self.averageSpeed = averageSpeed
    self.caloriesBurned = caloriesBurned
    self.elevationGain = elevationGain
    self.originLocationName = originLocationName
    self.destinationLocationName = destinationLocationName
    self.dateStarted = dateStarted
    self.dateFinished = dateFinished
    self.weather = weather
    self.averageHeartRate = averageHeartRate
    self.maxHeartRate = maxHeartRate
    self.splits = splits
    self.routeType = routeType
    self.terrainType = terrainType
    self.notes = notes
    self.tags = tags
    self.userID = userID
  }
}
