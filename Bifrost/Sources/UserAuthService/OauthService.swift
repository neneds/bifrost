//
//  OauthService.swift
//  Bifrost
//
//  Created by Dennis Merli on 21/03/19.
//  Copyright © 2019 Dennis Merli. All rights reserved.
//

import SafariServices
import URLNavigator
import Alamofire
import RxSwift

public protocol OauthServiceType {
    func authorize(url: URL) -> Observable<AccessToken>
    func callback(code: String)
}

public final class OauthService: OauthServiceType {
    
    fileprivate var clientCredentials: ClientCredentialsType
    
    fileprivate var currentViewController: UIViewController?
    fileprivate let callbackSubject = PublishSubject<String>()
    
    private let navigator: NavigatorType
    
    public init(navigator: NavigatorType, clientCredentials: ClientCredentialsType) {
        self.clientCredentials = clientCredentials
        self.navigator = navigator
    }
    
    public func authorize(url: URL) -> Observable<AccessToken> {
        let safariViewController = SFSafariViewController(url: url)
        let navigationController = UINavigationController(rootViewController: safariViewController)
        navigationController.isNavigationBarHidden = true
        self.navigator.present(navigationController)
        self.currentViewController = navigationController
        
        return self.callbackSubject
            .flatMap(self.accessToken)
    }
    
    public func callback(code: String) {
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

