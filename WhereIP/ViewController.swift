//
//  ViewController.swift
//  WhereIP
//
//  Created by Pandora on 4/28/2560 BE.
//  Copyright © 2560 Pandora. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Google
import GoogleSignIn


class ViewController: UIViewController,GIDSignInUIDelegate,GIDSignInDelegate,FBSDKLoginButtonDelegate{
    let loginButton = FBSDKLoginButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var error:NSError?
        GGLContext.sharedInstance().configureWithError(&error)
        if error != nil{
            print(error ?? "")
            return
        }
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        let signInButton = GIDSignInButton(frame: CGRect(x:16, y: 24, width: view.frame.width-32, height: 50))
        signInButton.center = view.center
        view.addSubview(signInButton)
        //facebook
        
        loginButton.frame = CGRect(x: 16, y: 400, width: view.frame.width-32, height: 50)
        
        
        view.addSubview(loginButton)
        loginButton.delegate = self
        loginButton.readPermissions = ["email","public_profile"]
        loginButtonDidLogOut(loginButton)
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            print(error)
            return
        }
        //loadname = user.profile.email
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login") as? LoginedViewController
        //vc?.name = loadname
        self.present(vc!, animated: true, completion: nil)
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        print("Did log out of facebook")
        
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)	
            return
        }
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login") as? LoginedViewController
            
            //vc?.name = self.loadname
            self.present(vc!, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }


}

