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
    var body: some View {
        List{
            ForEach(audioRecorder.recordings, id: \.createdAt) {
                recording in RecordingRow(audioURL: recording.fileURL)
            }
        }//ScrollView
        .foregroundColor(.blue)
        //.appBackground()
    }// main body
}// struct RecordingsList

//to display 1 recording per row
struct RecordingRow: View{
    var audioURL: URL
    var body: some View{
        HStack{
            Text("\(audioURL.lastPathComponent)")
            Spacer()
        }//HStack
    }//body
}//struct RecordingRow

struct RecordingsList_Previews: PreviewProvider {
    static var previews: some View {
        RecordingsList(audioRecorder: AudioRecorder())
    }
}
