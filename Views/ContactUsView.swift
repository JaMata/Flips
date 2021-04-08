//
//  ContactUsView.swift
//  Flips
//
//  Created by Jordan Foster on 3/30/21.
//

import SwiftUI

struct ContactUsView: View {
	
	@Environment(\.managedObjectContext) var context
	@State private var fullText: String = "Enter your feedback here."
	
	var body: some View {
		VStack(alignment: .center) {
			Spacer()
			Text("Thank you for using Flips!")
				.font(.title)
				.padding()
			Text("Please submit your feedback below so that we can keep improving and you can keep flipping!")
				.font(.subheadline)
				.padding()
			Spacer()
			HStack {
				Spacer(minLength: 50)
				TextEditor(text: $fullText)
					.frame(maxWidth: .infinity, maxHeight: 300)
					.border(Color.accentColor)
				Spacer(minLength: 50)
			}
			HStack {
				Spacer(minLength: 50)
				Button(action: {
					
					if submitFeedback() {
						fullText = "Submit more feedback?"
					} else {
						print("Error submitting feedback!")
					}
				}, label: { Text("submit") })
				.frame(maxWidth: .infinity)
				.border(Color.accentColor)
				Spacer(minLength: 50)
			}
			Spacer()
		}
	}
	
	func submitFeedback() -> Bool {
		do {
			let feedback: Feedback = Feedback(body: fullText)
			let feedbackEntity: FeedbackEntity = feedback.convertToManagedObject()
			try context.save()
		} catch {
			return false
		}
		
		return true
	}
}

struct ContactUsView_Previews: PreviewProvider {
	static var previews: some View {
		ContactUsView()
	}
}
