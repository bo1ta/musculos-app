//
//  PredicateFactory.swift
//
//
//  Created by Solomon Alexandru on 22.07.2024.
//

import CoreData

public struct PredicateFactory {
  public static func favoriteExercise() -> NSPredicate {
    return NSPredicate(
      format: "%K == true",
      #keyPath(ExerciseEntity.isFavorite)
    )
  }

  public static func exerciseById(_ id: UUID) -> NSPredicate {
    return NSPredicate(
      format: "%K == %@",
      #keyPath(ExerciseEntity.exerciseId),
      id as NSUUID
    )
  }

  public static func exerciseByName(_ name: String) -> NSPredicate {
    return NSPredicate(
      format: "%K CONTAINS %@",
      #keyPath(ExerciseEntity.name),
      name
    )
  }

  public static func musclesByIds(_ muscleIds: [Int]) -> NSPredicate {
    return NSPredicate(
      format: "%K IN %@",
      #keyPath(PrimaryMuscleEntity.muscleId),
      muscleIds)
  }
}
