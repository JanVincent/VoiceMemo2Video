//
//  RecordingList.swift
//  Voice2Video
//
//  Created by Janeta Paul Vincent Paul on 4/2/22.
//

import SwiftUI

struct RecordingsList: View {
    // instance of audioReorder
    @ObservedObject var audioRecorder : AudioRecorder
    //initialize to set the background of the list as clear
    func initialize(){
            UITableView.appearance().backgroundColor = .clear
            UITableViewCell.appearance().backgroundColor = .clear
            UITableView.appearance().tableFooterView = UIView()
     }
    
    var body: some View {
        List{
            ForEach(audioRecorder.recordings, id: \.createdAt) {
                recording in RecordingRow(audioURL: recording.fileURL)
                    .listRowBackground(Color.clear)
            }
        }//List
        .padding()
        .foregroundColor(.blue)
        .onAppear(perform: self.initialize)
    }// main body
}// struct RecordingsList

//to display 1 recording per row
struct RecordingRow: View{
    var audioURL: URL
    @State private var isShareSheetPresented = false
    var body: some View{
        HStack{
            //display file name
            Text("\(audioURL.lastPathComponent)")
            Spacer()
            //share button
            Image(systemName: "square.and.arrow.up")
                .onTapGesture {
                    self.isShareSheetPresented.toggle()
                }
            .sheet(isPresented: $isShareSheetPresented, content: {ActivityView(activityItems: [audioURL])})
        }//HStack
    }//body
}//struct RecordingRow

struct RecordingsList_Previews: PreviewProvider {
    static var previews: some View {
        RecordingsList(audioRecorder: AudioRecorder())
    }
}
