//
//  FlipsView.swift
//  Flips
//
//  Created by Jordan Foster on 3/30/21.
//

import SwiftUI

struct FlipsView: View {
  
	var flips: [Flip]
	
	var body: some View {
		Text("Hello, World! \(flips.count) flips !")
	}
}

struct FlipsView_Previews: PreviewProvider {
    static var previews: some View {
			FlipsView(flips: FlipsDataModel.designModel.flips)
    }
}
