//
//  UserAuth.swift
//  Flips
//
//  Created by Jordan Foster on 3/17/21.
//

import Foundation

class UserAuth: ObservableObject {
	
	@Published var isLoggedIn = false
	
	func login() {
		self.isLoggedIn = true
	}
	
	func logout() {
		self.isLoggedIn = false
	}
}
