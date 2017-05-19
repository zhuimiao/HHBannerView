//
//  HHViewController.m
//  HHBannerView
//
//  Created by zhuimiao on 05/19/2017.
//  Copyright (c) 2017 zhuimiao. All rights reserved.
//

#define SCREENW [UIScreen mainScreen].bounds.size.width
#define kImgW 640.0
#define KimgH 260.0

#import "HHViewController.h"
#import "HHBannerView.h"


@interface HHViewController ()

@end

@implementation HHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 解决复杂视图中，图片留白问题
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self configBanner];
	
}

- (void)configBanner
{
    HHBannerView *banner = [[HHBannerView alloc]initWithFrame:CGRectMake(0, 0,SCREENW , KimgH/kImgW * SCREENW)];
    [self.view addSubview:banner];
    banner.bannerList = @[
                          @"https://yrs.yintai.com/rs/img/AppCMS/images/80cc1024-cd42-4646-8632-d38c33a4bb30.jpg",
                          @"https://yrs.yintai.com/rs/img/AppCMS/images/a06bf1fa-a31d-4a74-962e-63e4e6c3136d.jpg",
                          @"https://yrs.yintai.com/rs/img/AppCMS/images/fab18e4e-7496-416a-8135-08210cc2b7ab.jpg",
                          @"https://yrs.yintai.com/rs/img/AppCMS/images/17f5a397-47c5-4258-95a4-73457a07940d.jpg",
                          @"https://yrs.yintai.com/rs/img/AppCMS/images/1351ffda-ca21-4e2b-ab1d-4781599c5ce8.jpg"
                          ];
    banner.clickIndex = ^(NSInteger index) {
        NSLog(@"点击了索引：%ld",(long)index);
    };
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
