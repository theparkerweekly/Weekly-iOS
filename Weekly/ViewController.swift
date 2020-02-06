//
//  ViewController.swift
//  Weekly
//
//  Created by Matthew Turk on 2/5/20.
//  Copyright © 2020 Francis W. Parker School. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamUI
import SDWebImage
import GoogleSignIn

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    @IBAction func showNews(_ sender: Any) {
        performSegue(withIdentifier: "CategorySegue", sender: news)
    }
    @IBAction func showFeatures(_ sender: Any) {
        performSegue(withIdentifier: "CategorySegue", sender: features)
    }
    @IBAction func showOpinions(_ sender: Any) {
        performSegue(withIdentifier: "CategorySegue", sender: opinions)
    }
    @IBOutlet private weak var featuredCollectionView: UICollectionView! {
        didSet { featuredCollectionView.register(cell: FeaturedCollectionViewCell.self) }
    }
    
    @IBOutlet private weak var newsCollectionView: UICollectionView! {
        didSet { newsCollectionView.register(cell: NewsCollectionViewCell.self) }
    }
    
    @IBOutlet private weak var featuresCollectionView: UICollectionView! {
        didSet { featuresCollectionView.register(cell: FeaturesCollectionViewCell.self) }
    }
    @IBOutlet weak var opinionsCollectionView: UICollectionView! {
        didSet {
            opinionsCollectionView.register(cell: OpinionsCollectionViewCell.self)
        }
    }
    
    private lazy var featuredCollectionViewAdapter = PostsDataViewAdapter(
        for: featuredCollectionView,
        delegate: self
    )
    
    private lazy var newsCollectionViewAdapter = PostsDataViewAdapter(
        for: newsCollectionView,
        delegate: self
    )
    
    private lazy var featuresCollectionViewAdapter = PostsDataViewAdapter(
        for: featuresCollectionView,
        delegate: self
    )
    
    private lazy var opinionsCollectionViewAdapter = PostsDataViewAdapter(for: opinionsCollectionView, delegate: self)
    
    let web = WPWeb(url: "https://weekly.fwparker.org")
    var featured: [WPPost]?
    var news: [WPPost]?
    var features: [WPPost]?
    var opinions: [WPPost]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if UserDefaults.isFirstLaunch() || !UserDefaults.standard.bool(forKey: "isSignedIn") { // or user is not logged in
            self.performSegue(withIdentifier: "Login", sender: nil)
        }
        
        load()
        configure()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case featuredCollectionView:
            return featured?.count ?? 0
        case newsCollectionView:
            return news?.count ?? 0
        case featuresCollectionView:
            return features?.count ?? 0
        case opinionsCollectionView:
            return opinions?.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case featuredCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FeaturedCollectionViewCell
//            print(indexPath.row)
            if let featured = featured {
                cell.titleLabel.text = featured[indexPath.row].title.rendered.clean()
                cell.summaryLabel.text = "\(Date.monthName(Date.parse(featured[indexPath.row].date).month())) \(Date.parse(featured[indexPath.row].date ).day()), \(Date.parse(featured[indexPath.row].date ).year())"
                cell.backgroundColor = .secondarySystemBackground
                cell.borderColor = .separator
                cell.borderWidth = self.traitCollection.userInterfaceStyle == .dark ? 0 : 1
                cell.cornerRadius = 10
                cell.featuredImage.setImage(from: featured[indexPath.row].better_featured_image?.source, placeholder: UIImage(named: "placeholder"))

                let width = cell.bounds.width
                let height = cell.bounds.height
                let sHeight:CGFloat = 60.0
                let shadow = UIColor.black.withAlphaComponent(0.6).cgColor

                let bottomImageGradient = CAGradientLayer()
                bottomImageGradient.frame = CGRect(x: 0, y: height - sHeight, width: width, height: sHeight)
                bottomImageGradient.colors = [UIColor.clear.cgColor, shadow]
                cell.featuredImage.layer.insertSublayer(bottomImageGradient, at: 0)
                cell.titleLabel.bringSubviewToFront(view)
            }
            
            return cell
        case newsCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! NewsCollectionViewCell
            if let featured = featured {
                if let news = self.news?.filter({!featured.contains($0)}) {
                    cell.titleLabel.text = news[indexPath.row].title.rendered.clean()
                    cell.summaryLabel.text = news[indexPath.row].excerpt.rendered.clean()
                    cell.featuredImage.setImage(from: news[indexPath.row].better_featured_image?.source, placeholder: UIImage(named: "placeholder"))
                } else {
                    cell.titleLabel.text = ""
                    cell.summaryLabel.text = ""
                }
            }
            
            
            return cell
        case featuresCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FeaturesCollectionViewCell
            if let features = features {
                cell.titleLabel.text = features[indexPath.row].title.rendered.clean()
                cell.summaryLabel.text = "\(Date.monthName(Date.parse(features[indexPath.row].date).month())) \(Date.parse(features[indexPath.row].date).day()), \(Date.parse(features[indexPath.row].date).year())"
                cell.featuredImage.setImage(from: features[indexPath.row].better_featured_image?.source, placeholder: UIImage(named: "placeholder"))
            }
            print(indexPath.row)
            return cell
        case opinionsCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! OpinionsCollectionViewCell
            if let opinions = opinions {
                cell.titleLabel.text = opinions[indexPath.row].title.rendered.clean()
                cell.featuredImage.setImage(from: opinions[indexPath.row].better_featured_image?.source, placeholder: UIImage(named: "opinion-\(Int.random(in: 0 ..< 5))"))
                cell.summaryLabel.text = opinions[indexPath.row].excerpt.rendered.clean()
                cell.featuredImage.cornerRadius = 10
            }
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            return cell
        }
        


    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        
        let vc = storyboard?.instantiateViewController(identifier: "DetailViewController") as? DetailViewController
        
        switch collectionView {
        case featuredCollectionView:
            vc?.post = featured?[indexPath.item]
        case newsCollectionView:
            if let news = self.news?.filter({!(featured?.contains($0))!}) {
                vc?.post = news[indexPath.item]
            }
        case featuresCollectionView:
            vc?.post = features?[indexPath.item]
        case opinionsCollectionView:
            vc?.post = opinions?[indexPath.item]
        default:
            print(indexPath.section, indexPath.row, "default")
        }
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CategorySegue" {
            if let vc = segue.destination as? CategoryTableViewController {
                vc.category = sender as? [WPPost]
            }
        }
    }
    
}

private extension ViewController {

    func configure() {
//        self.title = "Weekly"
//        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = UIColor(named: "Accent")

        let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: 270, height: 30))

        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 270, height: 30))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "wordmark")
        imageView.image = image
        logoContainer.addSubview(imageView)
        
        self.navigationItem.titleView = logoContainer
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
        
        if let a = featuredCollectionView, let b = newsCollectionView, let c = featuresCollectionView, let d = opinionsCollectionView {
            a.collectionViewLayout = SnapPagingLayout(
                centerPosition: true,
                peekWidth: 30,
                spacing: 20,
                inset: 16
            )
            b.collectionViewLayout = SnapPagingLayout(
                centerPosition: false,
                peekWidth: 20,
                spacing: 10,
                inset: 16
            )
            c.decelerationRate = .fast
            c.collectionViewLayout = MultiRowLayout(
                rowsCount: 3,
                inset: 16
            )
            d.collectionViewLayout = SnapPagingLayout(centerPosition: false, peekWidth: 20, spacing: 10, inset: 16)
        }

        
        
        ThemedSeparator.appearance().with {
            $0.backgroundColor = .separator
            $0.alpha = 0.5
        }
        ThemedView.appearance(whenContainedInInstancesOf: [FeaturedCollectionViewCell.self]).with {
            $0.backgroundColor = .secondarySystemBackground
            $0.borderColor = .separator
            $0.borderWidth = 1
            $0.cornerRadius = 10
        }
        
        ThemedImageView.appearance(whenContainedInInstancesOf: [NewsCollectionViewCell.self]).with {
            $0.borderColor = .secondarySystemBackground
            $0.borderWidth = 1
            $0.cornerRadius = 10
        }
        
        ThemedImageView.appearance(whenContainedInInstancesOf: [FeaturesCollectionViewCell.self]).with {
            $0.borderColor = .secondarySystemBackground
            $0.borderWidth = 1
            $0.cornerRadius = 10
        }
        
        RoundedImageView.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).with {
            $0.borderColor = .secondarySystemBackground
            $0.borderWidth = 1
        }
    }
}

extension UIViewController {
    
    /// Open Safari view controller overlay.
    ///
    /// - Parameters:
    ///   - url: URL to display in the browser.
    ///   - constants: The app constants.
    ///   - theme: The style of the Safari view controller.
    func modal(safari url: String, theme: Theme) {
        // Handle Safari display in split view differently
        splitViewController?.present(safari: url, theme: theme)
            ?? present(safari: url, theme: theme)
    }
    
    /// Open Safari view controller overlay.
    ///
    /// - Parameters:
    ///   - slug: The slug of the page.
    ///   - constants: The app constants.
    ///   - theme: The style of the Safari view controller.
    func modal(pageSlug slug: String, constants: ConstantsType, theme: Theme) {
        let url = constants.baseURL
            .appendingPathComponent(slug)
            .appendingQueryItem("mobileembed", value: 1)
            .absoluteString
        
        modal(safari: url, theme: theme)
    }
}



private extension ViewController {

    func load() {
        WPPost.getPosts(web: web, numberOfPosts: 10, after: nil, categories: [11]) { (posts) in
            DispatchQueue.main.async {
                self.featured = posts
                if let c = self.featuredCollectionView {
                    c.reloadData()
                }

            }

        }
        WPPost.getPosts(web: web, numberOfPosts: 30, after: nil, categories: [23]) { (posts) in
            DispatchQueue.main.async {
                self.news = posts
                if let c = self.newsCollectionView {
                    c.reloadData()
                }

            }
        }
        WPPost.getPosts(web: web, numberOfPosts: 30, after: nil, categories: [6]) { (posts) in
            DispatchQueue.main.async {
                self.features = posts
                if let c = self.featuresCollectionView {
                    c.reloadData()
                }

            }
        }

        WPPost.getPosts(web: web, numberOfPosts: 30, after: nil, categories: [7]) { (posts) in
            DispatchQueue.main.async {
                self.opinions = posts
                if let c = self.opinionsCollectionView {
                    c.reloadData()
                }

            }
        }
        
    }
}

extension ViewController: PostsDataViewDelegate, UIScrollViewDelegate {
    func postsDataView(didSelect model: PostsDataViewModel, at indexPath: IndexPath, from dataView: DataViewable) {
        print(indexPath.row, "asdfghj")
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
                let snapPagingLayout: ScrollableFlowLayout? = {
            switch scrollView {
            case featuredCollectionView:
                return featuredCollectionView.collectionViewLayout as? SnapPagingLayout
            case newsCollectionView:
                return newsCollectionView.collectionViewLayout as? SnapPagingLayout
            case featuresCollectionView:
                return featuresCollectionView.collectionViewLayout as? MultiRowLayout
            case opinionsCollectionView:
                return opinionsCollectionView.collectionViewLayout as? SnapPagingLayout
            default:
                return nil
            }
        }()
        
        snapPagingLayout?.willBeginDragging()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
                let snapPagingLayout: ScrollableFlowLayout? = {
            switch scrollView {
            case featuredCollectionView:
                return featuredCollectionView.collectionViewLayout as? SnapPagingLayout
            case newsCollectionView:
                return newsCollectionView.collectionViewLayout as? SnapPagingLayout
            case featuresCollectionView:
                return featuresCollectionView.collectionViewLayout as? MultiRowLayout
            case opinionsCollectionView:
                return opinionsCollectionView.collectionViewLayout as? SnapPagingLayout
            default:
                return nil
            }
        }()
        
        snapPagingLayout?.willEndDragging(
            withVelocity: velocity,
            targetContentOffset: targetContentOffset
        )
    }
    
    @objc func searchTapped() {
        performSegue(withIdentifier: "SearchSegue", sender: nil)
    }
    
}
