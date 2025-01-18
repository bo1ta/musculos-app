//
//  RouteExerciseSessionEntity.swift
//
//
//  Created by Solomon Alexandru on 17.01.2025.
//
//

import CoreData
import CoreLocation
import Foundation
import Models

// MARK: - RouteExerciseSessionEntity

@objc(RouteExerciseSessionEntity)
public class RouteExerciseSessionEntity: NSManagedObject {
  @NSManaged public var originLatitude: Double
  @NSManaged public var originLongitude: Double
  @NSManaged public var destinationLatitude: Double
  @NSManaged public var destinationLongitude: Double
  @NSManaged public var duration: Double
  @NSManaged public var distanceInMeters: Double
  @NSManaged public var averagePace: NSNumber?
  @NSManaged public var averageSpeed: NSNumber?
  @NSManaged public var caloriesBurned: NSNumber?
  @NSManaged public var elevationGain: NSNumber?
  @NSManaged public var originLocationName: String
  @NSManaged public var destinationLocationName: String
  @NSManaged public var dateStarted: Date
  @NSManaged public var dateFinished: Date
  @NSManaged public var weather: String?
  @NSManaged public var averageHeartRate: NSNumber
  @NSManaged public var maxHeartRate: NSNumber
  @NSManaged public var splits: [Double]?
  @NSManaged public var routeType: String?
  @NSManaged public var terrainType: String?
  @NSManaged public var notes: String?
  @NSManaged public var tags: [String]?
  @NSManaged public var userID: UUID
  @NSManaged public var uuid: UUID

  @nonobjc
  public class func fetchRequest() -> NSFetchRequest<RouteExerciseSessionEntity> {
    NSFetchRequest<RouteExerciseSessionEntity>(entityName: "RouteExerciseSessionEntity")
  }

  public var originCoordinate: CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: originLatitude, longitude: originLongitude)
  }

  public var destinationCoordinate: CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: destinationLatitude, longitude: destinationLongitude)
  }
}

// MARK: ReadOnlyConvertible

extension RouteExerciseSessionEntity: ReadOnlyConvertible {
  public func toReadOnly() -> RouteExerciseSession {
    var finalRouteType = RouteExerciseSession.RouteType.oneWay
    if let routeType, let enumType = RouteExerciseSession.RouteType(rawValue: routeType) {
      finalRouteType = enumType
    }

    var finalTerrainType = RouteExerciseSession.TerrainType.mixed
    if let terrainType, let enumType = RouteExerciseSession.TerrainType(rawValue: terrainType) {
      finalTerrainType = enumType
    }

    return RouteExerciseSession(
      uuid: uuid,
      originCoordinate: originCoordinate,
      destinationCoordinate: destinationCoordinate,
      distance: distanceInMeters,
      duration: duration,
      averagePace: averagePace?.doubleValue ?? 0,
      averageSpeed: averageSpeed?.doubleValue ?? 0,
      caloriesBurned: caloriesBurned?.doubleValue,
      elevationGain: elevationGain?.doubleValue,
      originLocationName: originLocationName,
      destinationLocationName: destinationLocationName,
      dateStarted: dateStarted,
      dateFinished: dateFinished,
      weather: weather,
      averageHeartRate: averageHeartRate.intValue,
      maxHeartRate: maxHeartRate.intValue,
      splits: splits,
      routeType: finalRouteType,
      terrainType: finalTerrainType,
      notes: notes,
      tags: tags ?? [],
      userID: userID)
  }
}

// MARK: EntitySyncable

extension RouteExerciseSessionEntity: EntitySyncable {
  public func populateEntityFrom(_ model: RouteExerciseSession, using _: StorageType) {
    uuid = model.uuid
    userID = model.userID
    originLatitude = model.originCoordinate.latitude
    originLongitude = model.originCoordinate.longitude
    destinationLatitude = model.destinationCoordinate.latitude
    destinationLongitude = model.destinationCoordinate.longitude
    distanceInMeters = model.distance
    duration = model.duration
    averagePace = model.averagePace as? NSNumber
    averageSpeed = model.averageSpeed as? NSNumber
    caloriesBurned = model.caloriesBurned as? NSNumber
    elevationGain = model.elevationGain as? NSNumber
    originLocationName = model.originLocationName
    destinationLocationName = model.destinationLocationName
    dateStarted = model.dateStarted
    dateFinished = model.dateFinished
    weather = model.weather
    splits = model.splits
    routeType = model.routeType.rawValue
    terrainType = model.terrainType.rawValue
    notes = model.notes
    tags = model.tags

    if let averageHeartRate = model.averageHeartRate {
      self.averageHeartRate = averageHeartRate as NSNumber
    }

    if let maxHeartRate = model.maxHeartRate {
      self.maxHeartRate = maxHeartRate as NSNumber
    }
  }

  public func updateEntityFrom(_: RouteExerciseSession, using _: StorageType) { }
}
