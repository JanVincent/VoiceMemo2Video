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
    
    //to set custom font color for Navigation Title
    func initialize(){
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.blue]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.blue]
              }

    
    var body: some View {
        NavigationView{
            VStack{
                if audioRecorder.recording == false{
                    Spacer()
                    Spacer()
                    // list of recordings
                    RecordingsList(audioRecorder: audioRecorder)
                    // button to start the recording
                    Button(action: {self.audioRecorder.startRecording()}){
                        Image("startRecording")
                    }//button
                }// if
                else{
                    Spacer()
                    //display recording duration
                    Text(Date().addingTimeInterval(0.0), style: .timer)
                        .foregroundColor(.white)
                        .font(.system(size: 60))
                    Spacer()
                    // button to stop the recording
                    Button(action: {self.audioRecorder.stopRecording()}){
                        Image("stopRecording")
                    }//button
                }//else
            }//Main Vstack
            .onAppear(perform: self.initialize)
            .navigationBarTitle(Text("VOICE MEMO 2 VIDEO"))
        }//Navigation View
        .preferredColorScheme(.dark)
    }//body
}//Struct ContentView

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(audioRecorder: AudioRecorder())
    }
}
