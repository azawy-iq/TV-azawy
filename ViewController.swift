import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = WKWebViewConfiguration()
        config.preferences.javaScriptCanOpenWindowsAutomatically = false
        
        // منع فتح النوافذ المنبثقة الإعلانية
        let blockScript = "window.open = function() { return null; };"
        let userScript = WKUserScript(source: blockScript, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        config.userContentController.addUserScript(userScript)

        // إعداد الـ WebView لملء الشاشة بالكامل
        webView = WKWebView(frame: .zero, configuration: config)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        // جعل خلفية الـ WebView داكنة لتناسب تصميم الموقع
        webView.backgroundColor = .black
        webView.scrollView.backgroundColor = .black
        
        // السماح بالتمرير حتى حدود الشاشة
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        
        self.view.addSubview(webView)
        
        // ربط الـ WebView بأطراف الشاشة الكاملة (Edge-to-Edge)
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

    // السماح بالدوران بالطول والعرض
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    // حظر التوجيه الخارجي غير المرغوب به
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
