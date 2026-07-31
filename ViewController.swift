import UIKit
import WebKit
import AVFoundation

class ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. تهيئة جلسة الصوت لتسمح بالتشغيل في الخلفية وبث الفيديو
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("خطأ في ضبط جلسة الصوت: \(error)")
        }

        // 2. إعدادات WKWebView لتفعيل Picture-in-Picture
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.allowsPictureInPictureMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        
        config.preferences.javaScriptCanOpenWindowsAutomatically = false
        
        // حظر الإعلانات بالنوافذ المنبثقة
        let blockScript = "window.open = function() { return null; };"
        let userScript = WKUserScript(source: blockScript, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        config.userContentController.addUserScript(userScript)

        // 3. إنشاء الـ WebView
        webView = WKWebView(frame: self.view.bounds, configuration: config)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        webView.backgroundColor = .black
        webView.scrollView.backgroundColor = .black
        
        self.view.addSubview(webView)
        
        if let url = URL(string: "https://starcima.com") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }

    override var shouldAutorotate: Bool {
        return true
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            let host = url.host?.lowercased() ?? ""
            if host.contains("starcima") || navigationAction.navigationType == .other {
                decisionHandler(.allow)
                return
            }
            if navigationAction.navigationType == .linkActivated || navigationAction.targetFrame == nil {
                decisionHandler(.cancel)
                return
            }
        }
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        return nil
    }
}
