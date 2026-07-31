import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = WKWebViewConfiguration()
        
        // 1. منع فتح النوافذ المنبثقة التلقائية عبر JavaScript
        config.preferences.javaScriptCanOpenWindowsAutomatically = false
        
        // 2. تطبيق قواعد حظر شبكات الإعلانات والنوافذ المنبثقة (Content Blocking Rules)
        let blockRules = """
        [
            {
                "trigger": {
                    "url-filter": ".*",
                    "resource-type": ["script", "image", "style", "raw", "document", "popup"],
                    "if-domain": [
                        "*popads*", "*popcash*", "*bet*", "*1xbet*", "*exoclick*", 
                        "*propellerads*", "*adsterra*", "*juicyads*", "*revenuehits*", 
                        "*yandex*", "*doubleclick*", "*google-analytics*", "*adnxs*",
                        "*clickadu*", "*hilltopads*", "*monetag*", "*outbrain*"
                    ]
                },
                "action": {
                    "type": "block"
                }
            },
            {
                "trigger": {
                    "url-filter": ".*",
                    "load-type": ["third-party"]
                },
                "action": {
                    "type": "block-cookies"
                }
            }
        ]
        """
        
        // 3. تعطيل الدوال البرمجية الخبيثة التي تستخدمها مواقع الأفلام لتخطي الحظر
        let antiAdScript = """
            // تعطيل window.open لمنع الإعلانات المنبثقة عند الضغط على المشغل
            window.open = function() { return null; };
            
            // إلغاء الأحداث الموجهة لإعادة التوجيه (Redirect Ads)
            document.addEventListener('click', function(e) {
                var target = e.target;
                while (target && target.tagName !== 'A') {
                    target = target.parentNode;
                }
                if (target && target.host && target.host !== window.location.host) {
                    // إذا كان الرابط خارج دومين starcima يتم تعليقه
                    if (!target.host.includes('starcima')) {
                        e.preventDefault();
                        e.stopPropagation();
                    }
                }
            }, true);
        """
        
        let userScript = WKUserScript(source: antiAdScript, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        config.userContentController.addUserScript(userScript)
        
        // إكمال إعدادات WKContentRuleList
        WKContentRuleListStore.default().compileContentRuleList(
            forIdentifier: "AdBlockRules",
            encodedContentRuleList: blockRules
        ) { [weak self] (ruleList, error) in
            if let ruleList = ruleList {
                config.userContentController.add(ruleList)
            }
            
            DispatchQueue.main.async {
                self?.setupWebView(configuration: config)
            }
        }
    }

    private func setupWebView(configuration: WKWebViewConfiguration) {
        webView = WKWebView(frame: self.view.bounds, configuration: configuration)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        self.view.addSubview(webView)
        
        if let url = URL(string: "https://starcima.com") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

    // 4. منع التوجيهات الإعلانية الخارجية (Navigation Control)
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            let host = url.host?.lowercased() ?? ""
            
            // السماح فقط بدومين Starcima الأساسي أو السيرفرات التابعة له
            if host.contains("starcima") || navigationAction.navigationType == .other {
                decisionHandler(.allow)
                return
            }
            
            // حظر أي توجيه خارجي ناتج عن ضغطة زر أو نوافذ إعلانية
            if navigationAction.navigationType == .linkActivated || navigationAction.targetFrame == nil {
                decisionHandler(.cancel)
                return
            }
        }
        decisionHandler(.allow)
    }

    // 5. حظر إنشاء أي WebView فرعي للإعلانات المنبثقة
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        return nil
    }
}
