//
//  LoginViewController.m
//  JamMates
//
//  Created by Stephen Sherwood on 2/24/15.
//  Copyright (c) 2015 Stephen Sherwood. All rights reserved.
//

#import "LoginViewController.h"
#import <WebKit/WebKit.h>

@interface LoginViewController () <WKNavigationDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame];
  [self.view addSubview:webView];
  webView.navigationDelegate = self;
  NSString *urlString = @"https://soundcloud.com/connect?client_id=0c179b66c4fe77ec437daa893f8e564a&redirect_uri=JamMates://oauth";
  NSURL *url = [NSURL URLWithString:urlString];
  [webView loadRequest:[NSURLRequest requestWithURL:url]]; //sets up webview for request with url
}

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
  
  NSURLRequest *request = navigationAction.request;
  NSURL *url = request.URL;
  
  if ([url.description containsString:@"access_token"]) {
    
    NSArray *components = [[url description]componentsSeparatedByString:@"="];
    NSString *token = components.lastObject;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:token forKey:@"token"];
    [userDefaults synchronize];
    
    [self dismissViewControllerAnimated:true completion:nil];
  }
  decisionHandler(WKNavigationActionPolicyAllow);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
