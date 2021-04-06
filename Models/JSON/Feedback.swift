//
//  Feedback.swift
//  Flips
//
//  Created by Jordan Foster on 3/28/21.
//

import Foundation

struct Feedback: Codable {
	
	let id: UUID = UUID()
	let timestamp: Date = Date()
	let body: String
	
	init(feedbackEntity: FeedbackEntity) {
		
		self.body = feedbackEntity.body!
		
	}
	
	func convertToManagedObject() -> FeedbackEntity {
		
		let feedbackEntity = FeedbackEntity(context: PersistenceController.shared.container.viewContext)
		
		feedbackEntity.id = self.id
		feedbackEntity.timestamp = self.timestamp
		feedbackEntity.body = self.body
		
		return feedbackEntity
		
	}
}
