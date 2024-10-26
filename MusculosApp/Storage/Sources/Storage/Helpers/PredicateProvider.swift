//
//  PredicateProvider.swift
//
//
//  Created by Solomon Alexandru on 22.07.2024.
//

import CoreData
import Models

public struct PredicateProvider {
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

  public static func exerciseByGoals(_ goals: [Goal]) -> NSPredicate? {
    var predicate: NSPredicate?

    for goal in goals {
      if let categories = ExerciseConstants.goalToExerciseCategories[goal.category] {
        let categoryPredicate = NSPredicate(
          format: "%K IN %@",
          #keyPath(ExerciseEntity.category),
          categories
        )
        predicate = predicate == nil ? categoryPredicate : NSCompoundPredicate(orPredicateWithSubpredicates: [predicate!, categoryPredicate])
      }
    }

    return predicate
  }

  public static func musclesByIds(_ muscleIds: [Int]) -> NSPredicate {
    return NSPredicate(
      format: "%K IN %@",
      #keyPath(PrimaryMuscleEntity.muscleId),
      muscleIds
    )
  }

  public static func userProfileByEmail(_ email: String) -> NSPredicate {
    return NSPredicate(
      format: "%K == %@",
      #keyPath(UserProfileEntity.email),
      email
    )
  }

  public static func userProfileById(_ id: UUID) -> NSPredicate {
    return NSPredicate(
      format: "%K == %@",
      #keyPath(UserProfileEntity.userId),
      id as NSUUID
    )
  }

  public static func goalByID(_ id: UUID) -> NSPredicate {
    return NSPredicate(
      format: "%K == %@",
      #keyPath(GoalEntity.goalID),
      id as NSUUID
    )
  }
}
