//
//  processRecording.swift
//  Voice2Video
//
//  Created by Janeta Paul Vincent Paul on 4/3/22.
//

import Foundation
import AVFoundation

//func to merge the recording with a default video and save it as a .mov video
func audio2Video() {
    //create empty mutable composition with video and audio asset
    let movie = AVMutableComposition()
    let videoTrack = movie.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
    let audioTrack = movie.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
    
    do{
        
        let currentDuration = movie.duration
        //load the video to be merged
        let targetVideo = AVURLAsset(url: Bundle.main.url(forResource: "vm2v", withExtension: "mov")!)
        let targetVideoTrack = targetVideo.tracks(withMediaType: .video).first!
        
        //get the url for the latest recording
        let targetAudio =  AVURLAsset(url: Bundle.main.url(forResource: "rhyme", withExtension: "m4a")!)
        let targetAudioTrack = targetAudio.tracks(withMediaType: .audio).first!
        //the range of the final video will be same as the audio recording
        let videoRange = CMTimeRangeMake(start: CMTime.zero, duration: targetAudio.duration)
        
        // insert the video into the mutable video track
        try videoTrack?.insertTimeRange(videoRange, of: targetVideoTrack, at: currentDuration)
        //insert the audio into the mutable audio track
        try audioTrack?.insertTimeRange(videoRange, of: targetAudioTrack, at: currentDuration)
        
        videoTrack?.preferredTransform = targetVideoTrack.preferredTransform
        
    }//do
    catch(let error){
        print("Could not create movie \(error.localizedDescription)")
    }//catch
    
    //export/save the merged video
    

    //path to export to
    guard let outputMovieURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("exported.mov") else { return }
    
    exportVideo(movie, to: outputMovieURL)
    
}// func audio2Video

func exportVideo(_ asset: AVAsset, to outputMovieURL: URL){

    
    //create export session for movie
    let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)!
    
    //cofigure the exporter
    exporter.outputURL = outputMovieURL
    exporter.outputFileType = .mov
    
    exporter.exportAsynchronously(completionHandler: {[weak exporter] in DispatchQueue.main.async {
        if let error = exporter?.error {
            print("faile \(error.localizedDescription)")
        }//if
        else{
            print("movie has been exported to \(outputMovieURL)")
        }//else
    }//async
        
    }//completionHandler)
    )
}// func exportVideo
