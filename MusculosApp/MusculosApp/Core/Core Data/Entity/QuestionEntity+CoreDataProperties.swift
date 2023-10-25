//
//  QuestionEntity+CoreDataProperties.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.07.2023.
//
//

import Foundation
import CoreData

extension QuestionEntity {

  @nonobjc public class func fetchRequest() -> NSFetchRequest<QuestionEntity> {
    return NSFetchRequest<QuestionEntity>(entityName: "QuestionEntity")
  }

  @NSManaged public var content: String
  @NSManaged public var questionId: Int
  @NSManaged public var answers: [AnswerEntity]

}

extension QuestionEntity: Identifiable {

}
