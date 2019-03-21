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

protocol OauthServiceType {
    func authorize(url: URL) -> Observable<AccessToken>
    func callback(code: String)
}

final class OauthService: OauthServiceType {
    
    fileprivate var clientCredentials: ClientCredentials

    fileprivate var currentViewController: UIViewController?
    fileprivate let callbackSubject = PublishSubject<String>()
    
    private let navigator: NavigatorType
    
    init(navigator: NavigatorType, clientCredentials: ClientCredentials) {
        self.clientCredentials = clientCredentials
        self.navigator = navigator
    }
    
    func authorize(url: URL) -> Observable<AccessToken> {
        let safariViewController = SFSafariViewController(url: url)
        let navigationController = UINavigationController(rootViewController: safariViewController)
        navigationController.isNavigationBarHidden = true
        self.navigator.present(navigationController)
        self.currentViewController = navigationController

        return self.callbackSubject
            .flatMap(self.accessToken)
    }
    
    func callback(code: String) {
        self.callbackSubject.onNext(code)
        self.currentViewController?.dismiss(animated: true, completion: nil)
        self.currentViewController = nil
    }
    
    fileprivate func accessToken(code: String) -> Single<AccessToken> {
        return Single.create { observer in
            let request = Alamofire
                .request(self.clientCredentials.accessTokenURL.absoluteString, method: .post, parameters: self.clientCredentials.parameters)
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
        }
    }
}

