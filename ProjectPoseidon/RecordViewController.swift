//
//  RecordViewController.swift
//  ProjectPoseidon
//
//  Created by Thomas Clements on 25/09/2017.
//  Copyright © 2017 Thomas Clements. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController {
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    
    var audioRecorder : AVAudioRecorder?
    var audioPlayer : AVAudioPlayer?
    var audioURL : URL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create audio session
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try? session.overrideOutputAudioPort(.speaker)
        try? session.setActive(true)
        
        //Create local URL to save audio
        if let basePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first{
            let pathComponents = [basePath,"audio.m4a"]
            if let audioURL = NSURL.fileURL(withPathComponents: pathComponents){
                //Create settings
                self.audioURL = audioURL
                var settings : [String:Any] = [:]
                settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC)
                settings[AVSampleRateKey] = 44100.0
                settings[AVNumberOfChannelsKey] = 2
                
                
                //Create audio recorder
                audioRecorder = try? AVAudioRecorder(url: audioURL, settings: settings)
                audioRecorder?.prepareToRecord()
                
            }
        }
        playButton.isEnabled = false
        saveButton.isEnabled = false
        nameTextField.isEnabled = false
    }
    
    
    @IBAction func recordButton(_ sender: Any) {
        
        if let audioRecorder = self.audioRecorder{
            if audioRecorder.isRecording{
                   audioRecorder.stop()
                recordButton.setTitle("Record", for: .normal)
                playButton.isEnabled = true
                saveButton.isEnabled = true
                nameTextField.isEnabled = true
             
            } else {
                audioRecorder.record()
                recordButton.setTitle("Stop", for: .normal)
                playButton.isEnabled = false
                saveButton.isEnabled = false
                nameTextField.isEnabled = false
                
            }
        }
    }
    
    @IBAction func playButton(_ sender: Any) {
        if let audioURL = self.audioURL{
        audioPlayer = try? AVAudioPlayer(contentsOf: audioURL)
            audioPlayer?.play()
    }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
            let sound = SoundRecording(entity:SoundRecording.entity(), insertInto:context)
            sound.name = nameTextField.text
            if let audioURL = self.audioURL{
            sound.soundURL = try? Data(contentsOf:audioURL)
                try? context.save()
                navigationController?.popViewController(animated: true)
        }
        }
    }
}
