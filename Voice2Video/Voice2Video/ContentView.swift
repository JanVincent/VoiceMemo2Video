//
//  ContentView.swift
//  Voice2Video
//
//  Created by Janeta Paul Vincent Paul on 4/2/22.
//

import SwiftUI
import AVFAudio

struct ContentView: View {
    // AudioRecorder instance
    @ObservedObject var audioRecorder : AudioRecorder
    //creste recording session
    let recordingSession = AVAudioSession.sharedInstance()
    
    //to set custom font color for Navigation Title
    func initialize(){
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
              }
    
    var body: some View {
        NavigationView{
            VStack{
                // While recording is OFF
                if audioRecorder.recording == false{
                    Spacer()
                    Spacer()
                    // list of recordings
                    RecordingsList(audioRecorder: audioRecorder)
                    // button to start the recording
                    Button(action: {
                        //request permission to record
                        recordingSession.requestRecordPermission { granted in
                            if granted{
                                self.audioRecorder.startRecording(recordingSession: recordingSession)
                            }
                            else{
                                let alertmsg = UIAlertController(title: "Grant Microphone access", message: "We need access to do recording", preferredStyle: .alert)
                                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                                let settingAction = UIAlertAction(title: "Open Settings", style: .default){ (_) -> Void in
                                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {return}
                                    if UIApplication.shared.canOpenURL(settingsUrl){
                                        UIApplication.shared.open(settingsUrl,completionHandler: { (success) in
                                            print("settings opened: \(success)")
                                        }// completionHandler
                                        )//open
                                    }//if
                                        
                                }
                                alertmsg.addAction(cancelAction)
                                alertmsg.addAction(settingAction)
                                UIApplication.topViewController()?.present(alertmsg, animated: false, completion: nil)
                                return
                            }// else: not granted
                        }// requestRecordPermisssion
                    })// button
                    {
                        Image("startRecording")
                    }//button image
                }// if
                //when recording is ON
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
        .navigationViewStyle(.stack)
    }//body
}//Struct ContentView

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(audioRecorder: AudioRecorder())
    }
}
