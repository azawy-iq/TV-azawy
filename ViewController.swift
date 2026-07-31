import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = WKWebViewConfiguration()
        config.preferences.javaScriptCanOpenWindowsAutomatically = false
        
        // 1. حظر الإعلانات والنوافذ المنبثقة
        let blockScript = "window.open = function() { return null; };"
        let userScript = WKUserScript(source: blockScript, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        config.userContentController.addUserScript(userScript)

        // 2. كود CSS لإلغاء أي حواف خفية داخل الموقع نفسه (Margin/Padding)
        let removeMarginsScript = """
            var style = document.createElement('style');
            style.innerHTML = 'html, body { margin: 0 !important; padding: 0 !important; width: 100vw !important; height: 100vh !important; max-width: 100% !important; }';
            document.head.appendChild(style);
        """
        let marginUserScript = WKUserScript(source: removeMarginsScript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        config.userContentController.addUserScript(marginUserScript)

        // 3. إنشاء الـ WebView
        webView = WKWebView(frame: .zero, configuration: config)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        webView.backgroundColor = .black
        webView.scrollView.backgroundColor = .black
        
        // 🚨 نقطة السر: إيقاف تعديل Safe Area تلقائياً ليمتد المحتوى لأطراف الهاتف
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        
        self.view.addSubview(webView)
        
        // 4. ربط حواف الـ WebView بالحواف الحقيقية للشاشة (view.topAnchor وليس safeAreaLayoutGuide)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: self.view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
        if let url = URL(string: "https://starcima.com") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

    // إخفاء شريط الساعة والبطارية (Status Bar) للحصول على شاشة كاملة حقيقية
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }

    override var shouldAutorotate: Bool {
        return true
    }

    // حظر التوجيه الإعلاني
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
