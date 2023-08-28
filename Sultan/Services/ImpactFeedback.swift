
import UIKit

class ImpactFeedback {
    static var shared = ImpactFeedback()
    
    func makeImpackFeedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        guard UserSavingsService.shared.vibrations else { return }
        
        let feedback = UIImpactFeedbackGenerator(style: style)
        feedback.impactOccurred()
    }
}
