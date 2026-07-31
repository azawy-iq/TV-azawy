import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    var webView: WKWebView!

    // -------------------------------------------------------------
    // 💡 عدّل هذه النسبة يدوياً لتكبير أو تصغير قياسات محتوى الموقع:
    // 1.0 = القياس الطبيعي
    // 1.15 = تكبير بنسبة 115%
    // 1.25 = تكبير بنسبة 125% (ممتاز لملء شاشة 12 Pro Max)
    let zoomLevel: Double = 1.20
    // -------------------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = WKWebViewConfiguration()
        config.preferences.javaScriptCanOpenWindowsAutomatically = false
        
        // 1. حظر الإعلانات والنوافذ المنبثقة
        let blockScript = "window.open = function() { return null; };"
        let userScript = WKUserScript(source: blockScript, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        config.userContentController.addUserScript(userScript)

        // 2. كود تعديل القياسات وإجبار الموقع على التمدد والزوم
        let customScaleScript = """
            var meta = document.createElement('meta');
            meta.name = 'viewport';
            meta.content = 'width=device-width, initial-scale=1.0, viewport-fit=cover';
            document.getElementsByTagName('head')[0].appendChild(meta);
            
            var style = document.createElement('style');
            style.innerHTML = `
                body, html {
                    margin: 0 !important;
                    padding: 0 !important;
                    width: 100% !important;
                    zoom: \(zoomLevel) !important;
                    -webkit-transform-origin: 0 0;
                }
                .container, .wrapper, main {
                    max-width: 100% !important;
                    width: 100% !important;
                }
            `;
            document.head.appendChild(style);
        """
        
        let scaleUserScript = WKUserScript(source: customScaleScript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        config.userContentController.addUserScript(scaleUserScript)

        // 3. إعداد الـ WebView لملء إطار الهاتف كلياً
        webView = WKWebView(frame: .zero, configuration: config)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        webView.backgroundColor = .black
        webView.scrollView.backgroundColor = .black
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        
        self.view.addSubview(webView)
        
        // ربط أطراف الـ WebView بالحواف الحقيقية للجهاز
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

    override var prefersStatusBarHidden: Bool {
        return true
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
