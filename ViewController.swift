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

        // 1. تحديد أبعاد الشاشة يدوياً على كامل الحجم الفيزيائي للجهاز
        let screenSize = UIScreen.main.bounds
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height), configuration: config)
        
        // 2. تمديد الـ WebView تلقائياً مع دوران الشاشة
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // 3. إلغاء الهوامش الآمنة (Safe Area) يدوياً لتغطي الشاشة بالكامل
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        
        // خلفية سوداء لتجنب ظهور أي حواف بيضاء
        self.view.backgroundColor = .black
        webView.backgroundColor = .black
        webView.scrollView.backgroundColor = .black
        
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        self.view.addSubview(webView)
        
        if let url = URL(string: "https://starcima.com") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

    // إعادة ضبط الأبعاد يدوياً عند تدوير الشاشة (طول / عرض)
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.webView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        }, completion: nil)
    }

    // تفعيل الدوران لجميع الاتجاهات
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }

    override var shouldAutorotate: Bool {
        return true
    }

    // حظر التوجيه الإعلاني الخارجي
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
