//
//  processRecording.swift
//  Voice2Video
//
//  Created by Janeta Paul Vincent Paul on 4/3/22.
//

import Foundation
import AVFoundation
import UIKit


//func to merge the recording with a default video and save it as a .mov video
func audio2Video(audioURL : URL) {
    let audioURL = audioURL
    let movieName = audioURL.deletingPathExtension().lastPathComponent
    //create empty mutable composition with video and audio asset
    let movie = AVMutableComposition()
    let videoTrack = movie.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
    let audioTrack = movie.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
    
    do{
        
        let currentDuration = movie.duration
        // check if the video to be merged is present
        guard Bundle.main.path(forResource: "vm2v", ofType: "mov") != nil else {
            let alertmsg = UIAlertController(title: "Try Again", message: "Video to be merged not available", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertmsg.addAction(ok)
            UIApplication.topViewController()?.present(alertmsg, animated: false, completion: nil)
            return
         }
        
        //load the video to be mergedm
        let targetVideo = AVURLAsset(url: Bundle.main.url(forResource: "vm2v", withExtension: "mov")!)
        let targetVideoTrack = targetVideo.tracks(withMediaType: .video).first!
        //get the url for the latest recording
        let targetAudio =  AVURLAsset(url: audioURL)
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
        let alertmsg = UIAlertController(title: "Try Again", message: "Could not create movie \(error.localizedDescription)", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertmsg.addAction(ok)
        UIApplication.topViewController()?.present(alertmsg, animated: false, completion: nil)
    }//catch
    
    //export/save the merged video
    

    //path to export to
    guard let outputMovieURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("\(movieName).mov") else {return }
    
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
            let alertmsg = UIAlertController(title: "Try Again", message: "failed \(error.localizedDescription)", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertmsg.addAction(ok)
            UIApplication.topViewController()?.present(alertmsg, animated: false, completion: nil)
        }//if
    }//async
        
    }//completionHandler)
    )//exportAsynchronously
}// func exportVideo

