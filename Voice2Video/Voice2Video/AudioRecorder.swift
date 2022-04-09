//
//  AudioRecorder.swift
//  Voice2Video
//
//  Created by Janeta Paul Vincent Paul on 4/2/22.
//

import Foundation
import UIKit
import Combine
import AVFoundation

class AudioRecorder:NSObject, ObservableObject{
    
    //fetchReccording neeeds to be called when the app is opened and AudioRecorder is first initialized
    // Hence AudioRecorder needs to overwrtite the init function
    //it also needs to adopt to NSObject
    override init() {
        super.init()
        fetchRecording()
    }
    
    //to inform observing views about change
    let objectWillChange = PassthroughSubject<AudioRecorder, Never>()
    //AVAudioRecorder instance - use to start recording session
    var audioRecorder : AVAudioRecorder!
    //array to store the recordings
    var recordings = [Recording]()
    //variable to update view about chnages using objectWilChange
    var recording = false{
        didSet{
            objectWillChange.send(self)
        }
    }
    //func to start recording on Button Press
    func startRecording(){
        //creste recording session
        let recordingSesson = AVAudioSession.sharedInstance()
        
        do{
            //define type of recording session
            try recordingSesson.setCategory(.playAndRecord, mode: .default)
            //activate the recording session
            try recordingSesson.setActive(true)
        } catch{
            print("Failed to set up recording session")
        }//catch
        
        //define path to save the recording
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        //define the naming and format(.m4a extension, mpeg format) for the recording
        let audioFileName = documentPath.appendingPathComponent("\(Date().toString(dateFormat: "MM_dd_YYYY_'at'_HH-mm-ss")).m4a")
        
        //settings for recording
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            
        ]
        
        //start recording
        do{
            audioRecorder = try AVAudioRecorder(url: audioFileName, settings: settings)
            audioRecorder.record()
            recording = true
        } catch{
            print("Could not start recording")
        }

    }// func startRecording
    
    // func to stop recording the audio session
    func stopRecording(){
        audioRecorder.stop()
        recording = false
        //to be called every time a recording is done
        audio2Video(audioURL: audioRecorder.url)
        //delete the audio file
        audioRecorder.deleteRecording()
        fetchRecording()
       
    }
    func recordingDuration() -> Double{
        return audioRecorder.currentTime
    }

    
    //func to fetch the recordings
    func fetchRecording(){
        // empty recordings array to avoid repeatation
        recordings.removeAll()
        //access the directory where audio files are saved
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
        //cycle through all save audios
        for audio in directoryContents{
            let recording = Recording(fileURL: audio, createdAt: getCreationDate(for: audio))
            recordings.append(recording)
        }
        //sort recordings by the creation date(latest files on top)
        recordings.sort(by: {$0.createdAt.compare($1.createdAt) == .orderedDescending})
        objectWillChange.send(self)
    }
    
}// class AudioRecorder
