//
//  HMViewController.m
//  04-加载网页
//
//  Created by apple on 14-9-26.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMViewController.h"

@interface HMViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardItem;
- (IBAction)back;
- (IBAction)forward;

@property (nonatomic, weak) UIWebView *webView;
@end

@implementation HMViewController

- (void)viewDidLoad
{    [super viewDidLoad];
    // 1.创建webView
    UIWebView *webView = [[UIWebView alloc] init];
    CGRect frame = self.view.bounds;
    frame.origin.y = 64;
    webView.frame = frame;
    [self.view addSubview:webView];
    
    // 2.加载请求
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"login" withExtension:@"html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
    // 3.设置代理（监听网页的加载过程）
    webView.delegate = self;
    
    self.webView = webView;
}

- (IBAction)back{
    [self.webView goBack];
}

- (IBAction)forward {
    [self.webView goForward];
}

#pragma mark - UIWebViewDelegate
/**
 *  网页加载完毕就调用
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    if ([webView canGoBack]) {
//        self.backItem.enabled = YES;
//    } else {
//        self.backItem.enabled = NO;
//    }
    self.backItem.enabled = [webView canGoBack];
    self.forwardItem.enabled = [webView canGoForward];
    NSLog(@"webViewDidFinishLoad");
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError");
}

/**
 *  作用：一般用来拦截webView发出的所有请求（加载新的网页）
 *  每当webView即将发送一个请求之前，会先调用这个方法
 *
 *  @param request        即将要发送的请求
 *
 *  @return YES ：允许发送这个请求  NO ：不允许发送这个请求，禁止加载这个请求
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // 如果在path中找不到@“baidu”这个字符串
    //    [path rangeOfString:@"baidu"].length == 0;
    //    [path rangeOfString:@"baidu"].location == NSNotFound
    
    // URL格式：协议头://主机名/路径
    // request.URL.path ： 获得的仅仅是主机名（域名）后面的路径
    // request.URL.absoluteString ： 获得的是一个完整的URL字符串
    
    // 1.获得完整的url字符串
    NSString *url = request.URL.absoluteString;
    NSUInteger loc = [url rangeOfString:@"baidu"].location;
    
    // 2.找到baidu字符串，返回NO
    if (loc != NSNotFound) { // 能找到
        return NO; // 禁止加载
    }
    
    // 3.如果没有找到，返回YES
    return YES;
    
//    return loc == NSNotFound ? YES : NO;
//    return loc == NSNotFound;
}
@end
