//
//  LoginViewController.m
//  Allayer
//
//  Created by Vadim Molchanov on 2/5/16.
//  Copyright © 2016 Vadim Molchanov. All rights reserved.
//

#import "LoginViewController.h"
#import "AccessToken.h"

@interface LoginViewController () <UIWebViewDelegate>

@property (copy, nonatomic) LoginCompletionBlock completionBlock;
@property (weak, nonatomic) UIWebView *webView;

@end

@implementation LoginViewController
- (id)initWithCompletionBlock:(LoginCompletionBlock)completionBlock {
    
    self = [super init];
    if (self) {
        self.completionBlock = completionBlock;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect rect = self.view.bounds;
    rect.origin = CGPointZero;
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:rect];
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:webView];
    self.webView = webView;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                     target:self
                                     action:@selector(actionCancel:)];
    
    [self.navigationItem setRightBarButtonItem:cancelButton animated:NO];
    self.navigationItem.title = @"Login";
    
    //5244235 - appID  //305779150 - vkID
    NSString *oAuthUrlString = @"https://oauth.vk.com/authorize?" // baseURL
                                "client_id=5244235&" // appID
                                "scope=65544&"
                                "redirect_uri=https://oauth.vk.com/blank.html&"
                                "display=mobile&"
                                "v=5.44&"
                                "response_type=token";
    
    NSURL *oAuthUrl = [NSURL URLWithString:oAuthUrlString];
    NSURLRequest *oAuthRequest = [NSURLRequest requestWithURL:oAuthUrl];
    webView.delegate = self;
    [webView loadRequest:oAuthRequest];
    
}

- (void)dealloc {
    self.webView.delegate = nil;
}

#pragma mark - Actions

- (void)actionCancel:(UIBarButtonItem *)item {
    
    if (self.completionBlock) {
        self.completionBlock(nil);
    }
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
//    NSLog(@"%@", [request URL]);
    if ([[[request URL] description] rangeOfString:@"#access_token"].location != NSNotFound) {
        
        AccessToken *token = [[AccessToken alloc] init];
        
        NSString *query = [[request URL] description];
        NSArray *components = [query componentsSeparatedByString:@"#"];
        
        if ([components count] > 1) {
            query = [components lastObject];
        }
        
        NSArray *pairs = [query componentsSeparatedByString:@"&"];
        
        for (NSString *iPair in pairs) {
            NSArray *values = [iPair componentsSeparatedByString:@"="];
            
            if ([values count] == 2) {
                
                NSString *key = [values firstObject];
                
                if ([key isEqualToString:@"access_token"]) {
                    token.token = [values lastObject];
                    
                } else if ([key isEqualToString:@"expires_in"]) {
                    
                    NSTimeInterval interval = [[values lastObject] doubleValue];
                    if (interval <= 0) {
                        interval = DBL_MAX;
                    }
                    
                    token.expirationDate = [NSDate dateWithTimeIntervalSinceNow:interval];
                    
                } else if ([key isEqualToString:@"user_id"]) {
                    token.userID = [values lastObject];
                }
            }
        }
        
        self.webView.delegate = nil;
        
        if (self.completionBlock) {
            self.completionBlock(token);
        }
        
        [self dismissViewControllerAnimated:NO completion:nil];
        
        return NO;
    }
    
    return YES;
}

@end
