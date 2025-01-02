//
//  PredicateProvider.swift
//
//
//  Created by Solomon Alexandru on 22.07.2024.
//

import CoreData
import Models

public enum PredicateProvider {
  public static func favoriteExercise() -> NSPredicate {
    NSPredicate(
      format: "%K == true",
      #keyPath(ExerciseEntity.isFavorite))
  }

  public static func exerciseById(_ id: UUID) -> NSPredicate {
    NSPredicate(
      format: "%K == %@",
      #keyPath(ExerciseEntity.exerciseId),
      id as NSUUID)
  }

  public static func exerciseByName(_ name: String) -> NSPredicate {
    NSPredicate(
      format: "%K CONTAINS %@",
      #keyPath(ExerciseEntity.name),
      name)
  }

  public static func userExperienceByID(_ id: UUID) -> NSPredicate {
    NSPredicate(
      format: "%K == %@",
      #keyPath(UserExperienceEntity.modelID),
      id as NSUUID)
  }

  public static func exerciseByGoals(_ goals: [Goal]) -> NSPredicate? {
    var predicate: NSPredicate?

    for goal in goals {
      if let categories = ExerciseConstants.goalToExerciseCategories[goal.category ?? ""] {
        let categoryPredicate = NSPredicate(
          format: "%K IN %@",
          #keyPath(ExerciseEntity.category),
          categories)

        predicate =
          if predicate == nil {
            categoryPredicate
          } else {
            NSCompoundPredicate(orPredicateWithSubpredicates: [
              predicate!, // swiftlint:disable:this force_unwrapping
              categoryPredicate,
            ])
          }
      }
    }

    return predicate
  }

  public static func exerciseByCategories(_ categories: [String]) -> NSPredicate? {
    NSPredicate(
      format: "%K IN %@",
      #keyPath(ExerciseEntity.category),
      categories)
  }

  public static func musclesByIds(_ muscleIDs: [Int]) -> NSPredicate {
    NSPredicate(
      format: "%K IN %@",
      #keyPath(PrimaryMuscleEntity.muscleID),
      muscleIDs)
  }

  public static func userProfileByEmail(_ email: String) -> NSPredicate {
    NSPredicate(
      format: "%K == %@",
      #keyPath(UserProfileEntity.email),
      email)
  }

  public static func userProfileById(_ id: UUID) -> NSPredicate {
    NSPredicate(
      format: "%K == %@",
      #keyPath(UserProfileEntity.userId),
      id as NSUUID)
  }

  public static func exerciseSessionsBetweenDates(_ startDate: Date, endDate: Date) -> NSPredicate {
    NSPredicate(
      format: "dateAdded >= %@ AND dateAdded <= %@",
      argumentArray: [startDate, endDate])
  }

  public static func exerciseSessionsForUser(_ userID: UUID) -> NSPredicate {
    NSPredicate(format: "user.userId == %@", userID.uuidString)
  }

  public static func exerciseSessionByID(_ id: UUID) -> NSPredicate {
    NSPredicate(format: "%K == %@", #keyPath(ExerciseSessionEntity.sessionId), id as NSUUID)
  }

  public static func userExperienceEntryByID(_ id: UUID) -> NSPredicate {
    NSPredicate(format: "%K == %@", #keyPath(UserExperienceEntryEntity.modelID), id as NSUUID)
  }

  public static func goalByID(_ id: UUID) -> NSPredicate {
    NSPredicate(format: "%K == %@", #keyPath(GoalEntity.goalID), id as NSUUID)
  }

  public static func exerciseRatingByID(_ id: UUID) -> NSPredicate {
    NSPredicate(format: "%K == %@", #keyPath(ExerciseRatingEntity.ratingID), id as NSUUID)
  }

  public static func progressEntryByID(_ id: UUID) -> NSPredicate {
    NSPredicate(format: "%K == %@", #keyPath(ProgressEntryEntity.progressID), id as NSUUID)
  }

  public static func workoutByID(_ id: UUID) -> NSPredicate {
    NSPredicate(format: "%K == %@", #keyPath(WorkoutEntity.modelID), id as NSUUID)
  }
}
