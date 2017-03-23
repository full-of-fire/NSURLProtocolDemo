//
//  ViewController.m
//  NSURLProtocal
//
//  Created by yj on 17/3/22.
//  Copyright © 2017年 yj. All rights reserved.
//

#import "ViewController.h"
#import "YJWebViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    
    YJWebViewController *test = [YJWebViewController new];
    
    [self presentViewController:test animated:YES completion:nil];
}


@end
