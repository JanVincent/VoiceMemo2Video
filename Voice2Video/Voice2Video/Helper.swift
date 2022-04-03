//
//  Helper.swift
//  Voice2Video
//
//  Created by Janeta Paul Vincent Paul on 4/2/22.
//

import Foundation
import SwiftUI


//to get the date audio file was created
func getCreationDate(for file: URL) -> Date{
    if let attributes = try? FileManager.default.attributesOfItem(atPath: file.path) as [FileAttributeKey: Any],
       let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
               return creationDate
    } else {
        return Date()
    }
}

//ViewModifiers

//for setting background
struct setBackground: ViewModifier{
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
            .ignoresSafeArea(.all)
            .background(.black)

    }
}


//extension
extension View{
    
    func appBackground() -> some View {
        modifier(setBackground())
    }
}//extension view

