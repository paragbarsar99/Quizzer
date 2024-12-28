//
//  HapticGenerator.swift
//  Quizzer
//
//  Created by parag on 27/12/24.
//

import Foundation
import UIKit

class Utils {
    func triggerImpactFeeback(style:UIImpactFeedbackGenerator.FeedbackStyle){
        let haptic = UIImpactFeedbackGenerator(style: style);
        haptic.prepare();
        haptic.impactOccurred()
    }
}
