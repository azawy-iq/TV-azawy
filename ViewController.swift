import UIKit

class ViewController: UIViewController {

    // الأيقونة الدائرية العليا لفتح معلومات المطور
    private let profileButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemCyan.cgColor
        // استخدام صورة التطبيق أو الشعار كأيقونة للزر
        if let image = UIImage(named: "AppIcon") {
            button.setImage(image, for: .normal)
        }
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()

    // الكارد المنبثق لمعلومات المطور
    private let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.secondarySystemBackground
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 10
        view.alpha = 0
        return view
    }()

    private let developerImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 40
        iv.clipsToBounds = true
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.systemPurple.cgColor
        iv.image = UIImage(named: "AppIcon") // صورة المطور أو الشعار
        iv.contentMode = .scaleAspectFill
        return iv
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "أنور العزاوي"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()

    private let socialStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 15
        sv.distribution = .fillEqually
        return sv
    }()

    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("إغلاق", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.tintColor = .systemRed
        return button
    }()

    private let rotatingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AppIcon")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupViews()
        setupConstraints()
        setupActions()
        startRotating()
    }

    private func setupViews() {
        view.addSubview(rotatingImageView)
        view.addSubview(profileButton)
        
        view.addSubview(cardView)
        cardView.addSubview(developerImageView)
        cardView.addSubview(nameLabel)
        cardView.addSubview(socialStackView)
        cardView.addSubview(closeButton)

        // أزرار السوشيال ميديا
        let telegramButton = createSocialButton(title: "Telegram", color: .systemBlue, url: "https://t.me/your_username")
        let githubButton = createSocialButton(title: "GitHub", color: .darkGray, url: "https://github.com/azawy-iq")
        
        socialStackView.addArrangedSubview(telegramButton)
        socialStackView.addArrangedSubview(githubButton)
    }

    private func createSocialButton(title: String, color: UIColor, url: String) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = color
        btn.layer.cornerRadius = 10
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.tag = url.hashValue
        return btn
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // أيقونة النجمة المتحركة بالمنتصف
            rotatingImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rotatingImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            rotatingImageView.widthAnchor.constraint(equalToConstant: 150),
            rotatingImageView.heightAnchor.constraint(equalToConstant: 150),

            // زر الملف الشخصي الدائري في الأعلى
            profileButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            profileButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            profileButton.widthAnchor.constraint(equalToConstant: 40),
            profileButton.heightAnchor.constraint(equalToConstant: 40),

            // تصميم الكارد المنبثق
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardView.widthAnchor.constraint(equalToConstant: 300),
            cardView.heightAnchor.constraint(equalToConstant: 320),

            // صورة المطور داخل الكارد
            developerImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 25),
            developerImageView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            developerImageView.widthAnchor.constraint(equalToConstant: 80),
            developerImageView.heightAnchor.constraint(equalToConstant: 80),

            // اسم المطور
            nameLabel.topAnchor.constraint(equalTo: developerImageView.bottomAnchor, constant: 15),
            nameLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),

            // روابط السوشيال ميديا
            socialStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            socialStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            socialStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            socialStackView.heightAnchor.constraint(equalToConstant: 40),

            // زر الإغلاق
            closeButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -15),
            closeButton.centerXAnchor.constraint(equalTo: cardView.centerXAnchor)
        ])
    }

    private func setupActions() {
        profileButton.addTarget(self, action: #selector(showCard), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(hideCard), for: .touchUpInside)
    }

    @objc private func showCard() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            self.cardView.alpha = 1
            self.cardView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.cardView.transform = .identity
            }
        }
    }

    @objc private func hideCard() {
        UIView.animate(withDuration: 0.2) {
            self.cardView.alpha = 0
            self.cardView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } completion: { _ in
            self.cardView.transform = .identity
        }
    }

    private func startRotating() {
        Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { _ in
            UIView.animate(withDuration: 4.0, delay: 0, options: .curveLinear) {
                self.rotatingImageView.transform = self.rotatingImageView.transform.rotated(by: .pi * 2)
            }
        }
    }
}
