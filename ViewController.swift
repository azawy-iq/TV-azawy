import UIKit

class ViewController: UIViewController {

    private let rotatingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AppIcon") // استخدام صورة AppIcon الموجودة في المستودع
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(rotatingImageView)
        
        NSLayoutConstraint.activate([
            rotatingImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rotatingImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            rotatingImageView.widthAnchor.constraint(equalToConstant: 150),
            rotatingImageView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        startRotating()
    }

    private func rotatingAnimation() {
        UIView.animate(withDuration: 4.0, delay: 0.0, options: [.curveLinear], animations: {
            self.rotatingImageView.transform = self.rotatingImageView.transform.rotated(by: CGFloat.pi)
        }) { finished in
            if finished {
                self.rotatingAnimation()
            }
        }
    }

    private func startRotating() {
        // حلقة تدوير مستمرة للأيقونة داخل التطبيق
        Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { _ in
            UIView.animate(withDuration: 4.0, delay: 0, options: .curveLinear) {
                self.rotatingImageView.transform = self.rotatingImageView.transform.rotated(by: .pi * 2)
            }
        }
    }
}
