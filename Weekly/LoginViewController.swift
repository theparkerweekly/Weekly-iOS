//
//  LoginViewController.swift
//  Weekly
//
//  Created by Matthew Turk on 2/2/20.
//  Copyright © 2020 Francis W. Parker School. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInDelegate {

    @IBOutlet weak var accessLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance()?.presentingViewController = self

        // Automatically sign in the user.
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        let email = user.profile.email
        if email!.contains("@fwparker.org") {
            self.dismiss()
        } else {
            accessLabel.text = "Not Parker email. Try again."
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
