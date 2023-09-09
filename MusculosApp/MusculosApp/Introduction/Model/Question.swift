//
//  Question.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.07.2023.
//

import Foundation
import CoreData

struct Question: Codable, DecodableModel {
    var id: Int
    var content: String
    var answers: [Answer]
}

extension Question {
    init(questionEntity: QuestionEntity) {
        self.id = questionEntity.questionId
        self.content = questionEntity.content
        self.answers = questionEntity.answers.map { $0.toModel() }
    }
    
    func toEntity(in context: NSManagedObjectContext) -> QuestionEntity {
        let questionEntity = QuestionEntity(context: context)
        questionEntity.questionId = self.id
        questionEntity.content = self.content
        questionEntity.answers = self.createAnswerEntities(from: self.answers)
        return questionEntity
    }
    
    func createAnswerEntities(from answers: [Answer]) -> [AnswerEntity] {
        let viewContext = DataController.shared.container.viewContext
        return answers.map { $0.toEntity(in: viewContext) }
    }
}
