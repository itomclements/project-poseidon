//
//  RecordingsTableViewController.swift
//  ProjectPoseidon
//
//  Created by Thomas Clements on 25/09/2017.
//  Copyright © 2017 Thomas Clements. All rights reserved.
//

import UIKit
import AVFoundation
class RecordingsTableViewController: UITableViewController {

    
    var sounds : [SoundRecording] = []
    var audioPlayer : AVAudioPlayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
    }
    func getSounds(){
         if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
            if let tempSounds = try? context.fetch(SoundRecording.fetchRequest()) as? [SoundRecording]{
                if let theSounds = tempSounds{
                    sounds = theSounds
                    tableView.reloadData()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getSounds()
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sounds.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        let sound = sounds[indexPath.row]
        cell.textLabel?.text = sound.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sound = sounds[indexPath.row]
        if let soundURL = sound.soundURL{
            audioPlayer = try? AVAudioPlayer(data:soundURL)
            audioPlayer?.play()
    }
        tableView.deselectRow(at: indexPath, animated: true)
    }
 


    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            let sound = sounds[indexPath.row]
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
            context.delete(sound)
                getSounds()
            }
            
            
        }
    }
 

   

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
