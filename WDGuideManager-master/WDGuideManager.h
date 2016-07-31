//
//  WDGuideManager.h
//  WDGuide
//
//  Created by bing.hao on 16/3/10.
//  Copyright © 2016年 wangda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol  WDGuideManagerDelegate <NSObject>

- (void)wdguideRegisterBtnClick:(UIButton *)btn;

- (void)wdguideLoginBtnClick:(UIButton *)btn;

@end


@interface WDGuideManager : NSObject

@property (weak , nonatomic)id <WDGuideManagerDelegate> delegate;

+ (instancetype)shared;

- (void)showGuideViewWithImages:(NSArray *)images;

@end