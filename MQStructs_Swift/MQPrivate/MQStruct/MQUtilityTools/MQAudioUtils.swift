//
//  MQAudioUtils.swift
//  MQStructs
//
//  Created by JuanFelix on 2017/4/7.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit
import AudioToolbox

class MQAudioUtils: NSObject {

    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    static func takeMedicineAudio() {
        self.play(forResource: "TakeMedicine", ofType: "caf")
        let path = Bundle.main
    }

    static func play(forResource resouce:String?,ofType type:String?) {
        if let file = Bundle.main.path(forResource: resouce, ofType: type) {
            var soundId: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(URL.init(fileURLWithPath: file) as CFURL, &soundId)
            self.play(withId: soundId)
        }
    }
    
    static func play(withId id: SystemSoundID) {
        AudioServicesPlaySystemSound(id)
    }
    
    
}
