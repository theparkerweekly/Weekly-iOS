//
//  DetailViewController.swift
//  Weekly
//
//  Created by Matthew Turk on 1/22/20.
//  Copyright © 2020 Francis W. Parker School. All rights reserved.
//

import UIKit
import WebKit
import ZamzamUI
import SwiftyPress
import SDWebImage

class DetailViewController: UIViewController, StatusBarable, WKNavigationDelegate {
    let application = UIApplication.shared
    
    var statusBar: UIView?
    private let templateFile = Bundle.main.string(file: "post.html")
    private let styleSheetFile = Bundle.main.string(file: "style.css")
    var barIsHidden = false

    var post: WPPost?
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.titleView = nil
        title = post?.title.rendered ?? ""
        navigationItem.rightBarButtonItem = nil
//        navigationController?.hidesBarsOnSwipe = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped(_:)))
        contentTextView.text = post?.content.rendered.clean().replacingOccurrences(of: "\n", with: "\n\n")
//        scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: contentLabel.bottomAnchor).isActive = true

        let fullString = NSMutableAttributedString(string: "")

        // create our NSTextAttachment
        let image1Attachment = NSTextAttachment()
//        image1Attachment.setImage(from: post?.better_featured_image?.source ?? "")
        image1Attachment.setImageHeight(height: 200)
        // wrap the attachment in its own attributed string so we can append it
        let image1String = NSAttributedString(attachment: image1Attachment)

        // add the NSTextAttachment wrapper to our full string, then add some more text.
//        fullString.append(image1String)
        fullString.append(post?.content.rendered.htmlAttributed.0 ?? NSAttributedString(string: ""))
        contentTextView.attributedText = fullString
        contentTextView.font = UIFont(name: "Georgia", size: 18)
        contentTextView.textColor = UIColor.label
        print(post?.content.rendered)
        

        // wrap the attachment in its own attributed string so we can append it
//        let data = Data((post?.content.rendered.utf8)!)
//        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
//            contentTextView.attributedText = attributedString
//            contentTextView.font = UIFont(name: "Georgia", size: 18.0)
//        }
    }
    
    @objc func shareTapped(_ sender: UIBarButtonItem) {
        guard let title = post?.title.rendered.clean(),
        let link = post?.link, let url = URL(string: link) else { return }
        
        let safariActivity = UIActivity.make(
            title: .localized(.openInSafari),
            imageName: "UIImage.ImageName.safariShare.rawValue",
            handler: {
                UIApplication.shared.open(url)
            }
        )
        
        present(
            activities: [title.htmlDecoded, link],
            barButtonItem: sender,
            applicationActivities: [safariActivity]
        )
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        navigationController?.hidesBarsOnSwipe = true
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.hidesBarsOnSwipe = false
//    }

}

extension DetailViewController: UITextViewDelegate {
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        // Display navigation/toolbar when scrolled to the bottom
//        guard scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) else { return }
//        navigationController?.setNavigationBarHidden(false, animated: true)
//    }
}
