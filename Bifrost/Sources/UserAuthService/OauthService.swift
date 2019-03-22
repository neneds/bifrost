//
//  OauthService.swift
//  Bifrost
//
//  Created by Dennis Merli on 21/03/19.
//  Copyright © 2019 Dennis Merli. All rights reserved.
//

import SafariServices
import Alamofire
import RxSwift
import UIKit

public protocol OauthServiceType {
    func authorize(url: URL) -> Observable<AccessToken>
    func handleURL(_ url: URL) -> Bool
}

public final class OauthService: OauthServiceType {
    fileprivate var clientCredentials: ClientCredentialsType
    fileprivate var currentViewController: UIViewController?
    fileprivate let callbackSubject = PublishSubject<String>()
    fileprivate var currentWindow: UIWindow?
    
    public init(currentWindow: UIWindow, clientCredentials: ClientCredentialsType) {
        self.currentWindow = currentWindow
        self.clientCredentials = clientCredentials
    }
    
    public func authorize(url: URL) -> Observable<AccessToken> {
        let safariViewController = SFSafariViewController(url: url)
        let navigationController = UINavigationController(rootViewController: safariViewController)
        navigationController.isNavigationBarHidden = true
        if let window = currentWindow {
            window.rootViewController?.present(navigationController, animated: true, completion: nil)
        }
        self.currentViewController = navigationController
        
        return self.callbackSubject
            .flatMap(self.accessToken)
    }
    
    public func handleURL(_ url: URL) -> Bool {
        let equalScheme = url.scheme == clientCredentials.callbackURL.scheme
        let equalHost = url.host == clientCredentials.callbackURL.host
        if equalScheme && equalHost {
            guard let code = url.queryParameter("code") else { return false } 
            self.callback(code: code)
            return true
        } else {
            return false
        }
    }
    
    private func callback(code: String) {
        self.callbackSubject.onNext(code)
        self.currentViewController?.dismiss(animated: true, completion: nil)
        self.currentViewController = nil
    }
    
    fileprivate func accessToken(code: String) -> Single<AccessToken> {
        return Single.create { observer in
            do {
                guard let requestURL = try self.clientCredentials.tokenRequestURL(code: code) else {
                    observer(.error(CustomError.nilParameter(parameter: "Token request URL")))
                    return Disposables.create()
                }
                let request = Alamofire
                    .request(requestURL)
                    .responseData { response in
                        switch response.result {
                        case let .success(jsonData):
                            do {
                                let accessToken = try JSONDecoder().decode(AccessToken.self, from: jsonData)
                                observer(.success(accessToken))
                            } catch let error {
                                observer(.error(error))
                            }
                            
                        case let .failure(error):
                            observer(.error(error))
                        }
                }
                return Disposables.create {
                    request.cancel()
                }
            } catch {
                observer(.error(error))
                return Disposables.create()
            }
        }
    }
}

