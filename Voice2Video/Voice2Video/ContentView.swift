//
//  ContentView.swift
//  Voice2Video
//
//  Created by Janeta Paul Vincent Paul on 4/2/22.
//

import SwiftUI

struct ContentView: View {
    // AudioRecorder instance
    @ObservedObject var audioRecorder : AudioRecorder
    var body: some View {
        NavigationView{
            VStack{
                // list of recordings
                RecordingsList(audioRecorder: audioRecorder)
                
                if audioRecorder.recording == false{
                    // button to start the recording
                    Button(action: {self.audioRecorder.startRecording()}){
                        Image("startRecording")
                    }//button
                }// if
                else{
                    // button to stop the recording
                    Button(action: {self.audioRecorder.stopRecording()}){
                        Image("stopRecording")
                    }//button
                }//else
            }//Main Vstack
            .navigationBarTitle("VOICE MEMO 2 VIDEO")
        }//Navigation View
    }//body
}//Struct ContentView

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(audioRecorder: AudioRecorder())
    }
}
