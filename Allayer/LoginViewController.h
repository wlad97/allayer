//
//  LoginViewController.h
//  Allayer
//
//  Created by Vadim Molchanov on 2/5/16.
//  Copyright © 2016 Vadim Molchanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AccessToken;

typedef void(^LoginCompletionBlock)(AccessToken *token);

@interface LoginViewController : UIViewController

- (id)initWithCompletionBlock:(LoginCompletionBlock)completionBlock;

@end
