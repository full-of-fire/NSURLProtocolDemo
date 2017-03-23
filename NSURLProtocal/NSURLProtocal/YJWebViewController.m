//
//  YJWebViewController.m
//  NSURLProtocal
//
//  Created by yj on 17/3/22.
//  Copyright © 2017年 yj. All rights reserved.
//

#import "YJWebViewController.h"

@interface YJWebViewController ()<UIWebViewDelegate>

@property (strong,nonatomic) UIWebView  *webView;

@property (assign,nonatomic) CFAbsoluteTime startTime;
@end

@implementation YJWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor greenColor];
    
    UIWebView *webView = [[UIWebView alloc]  initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.myxianwen.cn/24/shareArticle.action?news_id=12056048&user_id=160953&isNight=0&op_from=0&visit_id=5D40FFA7-2ECD-4B3A-97D8-AEA0646FF950&type=0&version=3.8.2&sn=086B17567BEA1FD1902CABC1BB01FD73224873DF9635AF4BCFDC102DDF61A4326747B0814518118E07E925C9C595DA213459EED1EFD61E63F0812C550C8CE220&app_id=1"]]];
    
//     [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.toutiao.com/a6400340712882290946/"]]];
    
    _webView = webView;

    webView.delegate = self;
    [self.view addSubview:webView];
    
   
    
}



- (void)webViewDidStartLoad:(UIWebView *)webView {

    _startTime =  CFAbsoluteTimeGetCurrent();
    
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {

    CFAbsoluteTime interval = CFAbsoluteTimeGetCurrent() - _startTime;
    
    NSLog(@"-----interval = %f",interval);
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
