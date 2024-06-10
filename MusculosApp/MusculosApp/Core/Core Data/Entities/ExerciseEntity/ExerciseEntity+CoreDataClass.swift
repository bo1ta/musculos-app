//
//  ExerciseEntity+CoreDataClass.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 09.05.2024.
//
//

import Foundation
import CoreData

@objc(ExerciseEntity)
public class ExerciseEntity: NSManagedObject {
  
  /// Populate default fields where is needed
  ///
  public override func awakeFromInsert() {
    super.awakeFromInsert()
    
    self.exerciseSessions = Set<ExerciseSessionEntity>()
  }
}
