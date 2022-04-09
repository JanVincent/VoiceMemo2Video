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

//implement share sheet using UIAcitivityViewController to share the mov video
// wrap UIActivityViewController with struct confirming to  UIViewControllerRepresentable protocol
struct ActivityView: UIViewControllerRepresentable{
    
    let activityItems: [Any]
    let applicationAcitivities: [UIActivity]? = nil
    
    //func responsibke to create ViewController
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationAcitivities)
        return controller
    }// func makeUIViewController
    
    //func to update the view controller when the SwiftUI state changes
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
    
    typealias UIViewControllerType = UIActivityViewController
    
}//struct ActivityView


