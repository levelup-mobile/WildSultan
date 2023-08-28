
import UIKit
import Lottie

class LoaderViewController: UIViewController {
    var completion: () -> Void

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let animationView = LottieAnimationView(name: "load")
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.contentMode = .scaleAspectFill
        view.addSubview(animationView)
        view.addConstraints([
            animationView.topAnchor.constraint(equalTo: view.topAnchor),
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            animationView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        animationView.play { _ in
            self.dismiss(animated: true)
            self.completion()
        }
    }
    
    init(_ completion: @escaping () -> Void) {
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .landscape
    }
    
    override var prefersStatusBarHidden: Bool {
        true
    }
}
