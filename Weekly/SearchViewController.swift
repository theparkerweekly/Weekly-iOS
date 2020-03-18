//
//  SearchViewController.swift
//  ShowBlog
//
//  Created by Matthew Turk on 1/26/20.
//  Copyright © 2020 Francis W. Parker School. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.contentInset.bottom += 20
        }
    }
    
    let web = WPWeb(url: "https://parkerweekly.org")
    var posts = [WPPost]()
    var filteredPosts = [WPPost]()
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    private lazy var searchController = UISearchController(searchResultsController: nil).with {
        $0.searchResultsUpdater = self
        $0.obscuresBackgroundDuringPresentation = false
        $0.searchBar.delegate = self
        $0.searchBar.placeholder = "Search"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        tableView.delegate = self
        tableView.dataSource = self
        load()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredPosts.count
        }
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let post: WPPost
        if isFiltering {
            post = filteredPosts[indexPath.row]
        } else {
            post = posts[indexPath.row]
        }
        cell.textLabel?.text = post.title.rendered.clean()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "DetailViewController") as? DetailViewController
        vc?.post = posts[indexPath.item]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredPosts = posts.filter({ (post: WPPost) -> Bool in
            return post.title.rendered.clean().lowercased().contains(searchText.lowercased()) || post.content.rendered.clean().lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    

    func load() {
        
        WPPost.getPosts(web: web, page: 1, postsPerPage: 100) { (posts) in
            DispatchQueue.main.async {
                self.posts = posts
                self.tableView.reloadData()
                print(posts)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
