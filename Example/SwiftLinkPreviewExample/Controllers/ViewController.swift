//
//  ViewController.swift
//  SwiftLinkPreviewExample
//
//  Created by Leonardo Cardoso on 09/06/2016.
//  Copyright © 2016 leocardz.com. All rights reserved.
//

import UIKit
import SwiftyDrop
import ImageSlideshow

class ViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet var textField: UITextField!
    @IBOutlet var randomTextButton: UIButton!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var openWithButton: UIButton!
    @IBOutlet var indicator: UIActivityIndicatorView!
    @IBOutlet var previewArea: UIView!
    @IBOutlet var previewAreaLabel: UILabel!
    @IBOutlet var slideshow: ImageSlideshow!
    @IBOutlet var previewTitle: UILabel!
    @IBOutlet var previewCanonicalUrl: UILabel!
    @IBOutlet var previewDescription: UILabel!
    @IBOutlet var detailedView: UIView!
    @IBOutlet weak var favicon: UIImageView!
    
    
    // MARK: - Vars
    private var randomTexts: [String] = [
        
        "www.youtube.com",
        "www.google.com",
        "facebook.com",
        
        "https://leocardz.com/swift-link-preview-5a9860c7756f",
        "NASA! 🖖🏽 https://www.nasa.gov/",
        "https://www.theverge.com/2016/6/21/11996280/tesla-offer-solar-city-buy",
        "Shorten URL http://bit.ly/14SD1eR",
        "Tweet! https://twitter.com",
        
        "A Gallery https://www.nationalgallery.org.uk",
        
        "A Brazilian website http://globo.com",
        "Another Brazilian website https://uol.com.br",
        "Some Vietnamese chars https://vnexpress.net/",
        "Japan!!! https://www3.nhk.or.jp/",
        "A Russian website >> https://habrahabr.ru",
        
        "Youtube?! It does! https://www.youtube.com/watch?v=cv2mjAgFTaI",
        "Also Vimeo https://vimeo.com/67992157",
        
        "Even with image itself https://lh6.googleusercontent.com/-aDALitrkRFw/UfQEmWPMQnI/AAAAAAAFOlQ/mDh1l4ej15k/w337-h697-no/db1969caa4ecb88ef727dbad05d5b5b3.jpg",
        "Well, it's a gif! https://goo.gl/jKCPgp"
        
    ]
    private var result = SwiftLinkPreview.Response()
    private let placeholderImages = [ImageSource(image: UIImage(named: "Placeholder")!)]
    
    private let slp = SwiftLinkPreview(cache: InMemoryCache())
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.showHideAll(hide: true)
        self.setUpSlideshow()
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    private func getRandomText() -> String {
        
        return randomTexts[Int(arc4random_uniform(UInt32(randomTexts.count)))]
        
    }
    
    private func startCrawling() {
        
        self.updateUI(enabled: false)
        self.showHideAll(hide: true)
        self.textField.resignFirstResponder()
        
    }
    
    private func endCrawling() {
        
        self.updateUI(enabled: true)
        
    }
    
    // Update UI
    private func showHideAll(hide: Bool) {
        
        self.slideshow.isHidden = hide
        self.detailedView.isHidden = hide
        self.openWithButton.isHidden = hide
        self.previewAreaLabel.isHidden = !hide
        
    }
    
    private func updateUI(enabled: Bool) {
        
        self.indicator.isHidden = enabled
        self.textField.isEnabled = enabled
        self.randomTextButton.isEnabled = enabled
        self.submitButton.isEnabled = enabled
        
    }
    
    private func setData() {
        
        if let value: [String] = self.result[.images] as? [String] {
            
            if !value.isEmpty {
                
                var images: [InputSource] = []
                for image in value {
                    
                    if let source = AlamofireSource(urlString: image) {
                        
                        images.append(source)
                        
                    }
                    
                }
                
                self.setImage(images: images)
                
                
            } else {
                
                self.setImage(image: self.result[.image] as? String)
                
            }
            
        } else {
            
            self.setImage(image: self.result[.image] as? String)
            
        }
        
        if let value: String = self.result[.title] as? String {
            
            self.previewTitle.text = value.isEmpty ? "No title" : value
            
        } else {
            
            self.previewTitle.text = "No title"
            
        }
        
        if let value: String = self.result[.canonicalUrl] as? String {
            
            self.previewCanonicalUrl.text = value
            
        }
        
        if let value: String = self.result[.description] as? String {
            
            self.previewDescription.text = value.isEmpty ? "No description" : value
            
        } else {
            
            self.previewTitle.text = "No description"
            
        }
        
        if let value: String = self.result[.icon] as? String, let url = URL(string: value) {
            self.favicon.af_setImage(withURL: url)
        }
        
        self.showHideAll(hide: false)
        self.endCrawling()
        
    }
    
    private func setImage(image: String?) {
        
        if let image: String = image {
            
            if !image.isEmpty {
                
                if let source = AlamofireSource(urlString: image) {
                    
                    self.setImage(images: [source])
                    
                } else {
                    
                    self.slideshow.setImageInputs(placeholderImages)
                    
                }
                
                
            } else {
                
                self.slideshow.setImageInputs(placeholderImages)
                
            }
            
        } else {
            
            self.slideshow.setImageInputs(placeholderImages)
            
        }
        
    }
    
    private func setImage(images: [InputSource]?) {
        
        if let images = images {
            
            self.slideshow.setImageInputs(images)
            
        } else {
            
            self.slideshow.setImageInputs(placeholderImages)
            
        }
        
    }
    
    private func setUpSlideshow() {
        
        self.slideshow.backgroundColor = UIColor.white
        self.slideshow.slideshowInterval = 7.0
        self.slideshow.pageControlPosition = PageControlPosition.hidden
        self.slideshow.contentScaleMode = .scaleAspectFill
        
    }
    
    // MARK: - Actions
    @IBAction func randomTextAction(_ sender: AnyObject) {
        
        textField.text = getRandomText()
        
    }
    
    @IBAction func submitAction(_ sender: AnyObject) {
        
        guard !(textField.text?.isEmpty)! else {
            
            Drop.down("Please, enter a text", state: .warning)
            return
            
        }
        
        self.startCrawling()
        
        let url = self.slp.extractURL(text: textField.text!)
        if let cached = self.slp.cache.slp_getCachedResponse(url: url!.absoluteString) {
            
            self.result = cached
            self.setData()
            
        } else {
            self.slp.preview(
                textField.text,
                onSuccess: { result in
                    
                    print(result)
                    self.result = result
                    self.setData()
                    
            },
                onError: { error in
                    
                    print(error)
                    self.endCrawling()
                    
                    Drop.down(error.description, state: .error)
                    
            }
            )
        }
        
    }
    
    @IBAction func openWithAction(_ sender: UIButton) {
        
        if let url = self.result[.finalUrl] as? URL {

            UIApplication.shared.open(url, options: [:], completionHandler: nil)

        }
        
    }
    
    
}

// MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.submitAction(textField)
        self.textField.resignFirstResponder()
        return true
        
    }
    
}

