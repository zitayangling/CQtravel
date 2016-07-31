//
//  WDGuideManager.m
//  WDGuide
//
//  Created by bing.hao on 16/3/10.
//  Copyright © 2016年 wangda. All rights reserved.
//

#import "WDGuideManager.h"

#define kScreenSize      [[UIScreen mainScreen] bounds]
#define kScreenWidth                ([[UIScreen mainScreen] bounds].size.width)
#define kScreenHeight               ([[UIScreen mainScreen] bounds].size.height)

static NSString *identifier = @"Cell";

@interface WDGuideViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIButton *registButton;

@property (nonatomic, strong) UIButton *loginButton;

@end

@implementation WDGuideViewCell

- (instancetype)init {
    self = [super init];
    if (self) {
        [self myInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self myInit];
    }
    return self;
}

- (void)myInit {
    
    self.layer.masksToBounds = YES;
    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = kScreenSize;
    self.imageView.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2);
    
    CGFloat margin = 15;
    CGFloat buttonWidth = (kScreenWidth-5*margin)/2;
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button1.hidden = YES;
    [button1 setFrame:CGRectMake(0, 0, buttonWidth, 44)];
    [button1 setTitle:@"注册" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button1.layer setCornerRadius:5];
    [button1.layer setBorderColor:[UIColor grayColor].CGColor];
    [button1.layer setBorderWidth:1.0f];
    [button1 setBackgroundColor:[UIColor whiteColor]];
    self.registButton = button1;
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button2.hidden = YES;
    [button2 setFrame:CGRectMake(0, 0, buttonWidth, 44)];
    [button2 setTitle:@"登陆" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button2.layer setCornerRadius:5];
    [button2.layer setBorderColor:[UIColor grayColor].CGColor];
    [button2.layer setBorderWidth:1.0f];
    [button2 setBackgroundColor:[UIColor whiteColor]];
    self.loginButton = button2;
    
    
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.registButton];
    [self.contentView addSubview:self.loginButton];
    
    [self.registButton setCenter:CGPointMake(kScreenWidth / 4, kScreenHeight - 100)];
    [self.loginButton setCenter:CGPointMake(kScreenWidth*3 / 4, kScreenHeight - 100)];
    
}

@end

@interface WDGuideManager ()<UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UICollectionView *view;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation WDGuideManager

+ (instancetype)shared {
    static id __staticObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __staticObject = [WDGuideManager new];
    });
    return __staticObject;
}

- (UICollectionView *)view {
    if (_view == nil) {
        
        CGRect screen = [UIScreen mainScreen].bounds;
        
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.itemSize = screen.size;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _view = [[UICollectionView alloc] initWithFrame:screen collectionViewLayout:layout];
        _view.bounces = NO;
        _view.backgroundColor = [UIColor whiteColor];
        _view.showsHorizontalScrollIndicator = NO;
        _view.showsVerticalScrollIndicator = NO;
        _view.pagingEnabled = YES;
        _view.dataSource = self;
        _view.delegate = self;
        
        [_view registerClass:[WDGuideViewCell class] forCellWithReuseIdentifier:identifier];
    }
    return _view;
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.frame = CGRectMake(0, 0, kScreenWidth, 44.0f);
        _pageControl.center = CGPointMake(kScreenWidth / 2, kScreenHeight - 60);
        _pageControl.backgroundColor = [UIColor clearColor];
    }
    return _pageControl;
}

- (void)showGuideViewWithImages:(NSArray *)images {
    
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    NSString *version = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    //根据版本号来区分是否要显示引导图
//    BOOL show = [ud boolForKey:[NSString stringWithFormat:@"Guide_%@", version]];
//    show = YES;
//    if (!show && self.window == nil) {

        self.images = images;
        self.pageControl.numberOfPages = images.count;
        self.window = [[[UIApplication sharedApplication] delegate] window];
        UINavigationController *vc = (UINavigationController  *)self.window.rootViewController;
        [vc.view addSubview:self.view];
        [vc.view addSubview:self.pageControl];
        
//        [ud setBool:YES forKey:[NSString stringWithFormat:@"Guide_%@", version]];
//        [ud synchronize];
//    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.images count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WDGuideViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImage *img = [self.images objectAtIndex:indexPath.row];
    CGSize size = [self adapterSizeImageSize:img.size compareSize:kScreenSize.size];
    
    //自适应图片位置,图片可以是任意尺寸,会自动缩放.
    cell.imageView.frame = CGRectMake(0, 0, size.width, size.height);
    cell.imageView.image = img;
    cell.imageView.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2);

    if (indexPath.row == self.images.count - 1) {
        [cell.registButton setHidden:NO];
        [cell.loginButton setHidden:NO];
        [cell.registButton addTarget:self action:@selector(registerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.loginButton addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    } else {
        [cell.registButton setHidden:YES];
        [cell.loginButton setHidden:YES];
    }

    return cell;
}

- (void)registerBtnClick:(UIButton *)btn
{
    [self.view removeFromSuperview];
    [self.pageControl removeFromSuperview];
    [self setView:nil];
    [self setPageControl:nil];
    if ([self.delegate respondsToSelector:@selector(wdguideRegisterBtnClick:)]) {
        [self.delegate wdguideRegisterBtnClick:btn];
    }
}

- (void)loginBtnClick:(UIButton *)btn
{
    [self.view removeFromSuperview];
    [self.pageControl removeFromSuperview];
    [self setView:nil];
    [self setPageControl:nil];
    if ([self.delegate respondsToSelector:@selector(wdguideLoginBtnClick:)]) {
        [self.delegate wdguideLoginBtnClick:btn];
    }
}

- (CGSize)adapterSizeImageSize:(CGSize)is compareSize:(CGSize)cs
{
    CGFloat w = cs.width;
    CGFloat h = cs.width / is.width * is.height;
    
    if (h < cs.height) {
        w = cs.height / h * w;
        h = cs.height;
    }
    return CGSizeMake(w, h);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    self.pageControl.currentPage = (scrollView.contentOffset.x / kScreenWidth);
}

- (void)nextButtonHandler:(id)sender {

    [self.view removeFromSuperview];
    [self setWindow:nil];
    [self setView:nil];
}

@end