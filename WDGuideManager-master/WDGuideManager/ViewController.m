//
//  ViewController.m
//  WDGuideManager
//
//  Created by fank on 16/4/13.
//  Copyright © 2016年 fank. All rights reserved.
//

#import "ViewController.h"
#import "WDGuideManager.h"

@interface ViewController () <NSFileManagerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSMutableArray *paths = [NSMutableArray new];
    
    [paths addObject:[UIImage imageNamed:@"guide_1"]];
    [paths addObject:[UIImage imageNamed:@"guide_2"]];
    [paths addObject:[UIImage imageNamed:@"guide_3"]];
    [paths addObject:[UIImage imageNamed:@"guide_4"]];
    
    [[WDGuideManager shared] showGuideViewWithImages:paths];
    [WDGuideManager shared].delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WDGuideManagerDelegate
- (void)wdguideRegisterBtnClick:(UIButton *)btn
{
    NSLog(@"点击了引导注册按钮");
}

- (void)wdguideLoginBtnClick:(UIButton *)btn
{
    NSLog(@"点击了引导登陆按钮");
}

@end
