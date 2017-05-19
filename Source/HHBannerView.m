
//  Created by boitx on 2017/5/18.
//  Copyright © 2017年 boitx. All rights reserved.
//

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define kPageControlSelctColor RGBCOLOR(227,125,168)
#define kPageControlNormalColor RGBCOLOR(203,203,203)

#import "HHBannerView.h"
#import "UIImageView+WebCache.h"

@implementation HHBannerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.imgV = [[UIImageView alloc]initWithFrame:self.bounds];
        self.imgV.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.imgV];
    }
    return self;
}


@end

@interface HHBannerView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView *bannerCollectView;
@property (nonatomic,strong) UICollectionViewFlowLayout *layout;
@property (nonatomic,strong) NSTimer * timer;
@property (nonatomic,strong) UIPageControl *pageControl;

@end

@implementation HHBannerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.bannerCollectView];
        [self addSubview:self.pageControl];
        self.pageControl.center = CGPointMake(self.frame.size.width/2.0, self.pageControl.center.y);
        CGFloat y = self.frame.size.height - self.pageControl.frame.size.height - 5;
        self.pageControl.frame = CGRectMake(self.pageControl.frame.origin.x, y, self.pageControl.frame.size.width, self.pageControl.frame.size.height);
    }
    return self;
}

- (void)setBannerList:(NSArray *)bannerList
{
    if (_bannerList != bannerList) {
        _bannerList = bannerList;
        self.pageControl.numberOfPages = _bannerList.count;
        [self.bannerCollectView reloadData];
        [self scrollToCenter];
        [self removeTimer];
        [self addTimer];
    }
}

- (UICollectionViewFlowLayout *)layout
{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc]init];
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout.itemSize = self.frame.size;
        _layout.minimumLineSpacing  = 0;
        _layout.minimumInteritemSpacing = 0;
    }
    return _layout;
}

- (UICollectionView *)bannerCollectView
{
    if (!_bannerCollectView) {
        _bannerCollectView = [[UICollectionView alloc]initWithFrame:self.frame collectionViewLayout:self.layout];
        _bannerCollectView.delegate = self;
        _bannerCollectView.dataSource = self;
        _bannerCollectView.pagingEnabled = YES;
        _bannerCollectView.backgroundColor = [UIColor blueColor];
        _bannerCollectView.showsHorizontalScrollIndicator = NO;
        _bannerCollectView.showsVerticalScrollIndicator = NO;
        [_bannerCollectView registerClass:[HHBannerCell class] forCellWithReuseIdentifier:@"HHBannerCell"];
    }
    return _bannerCollectView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.numberOfPages = self.bannerList.count;
        _pageControl.backgroundColor = [UIColor redColor];
        _pageControl.pageIndicatorTintColor = kPageControlNormalColor;
        _pageControl.currentPageIndicatorTintColor = kPageControlSelctColor;
    }
    return _pageControl;
}

#pragma mark - 添加定时器
- (void)addTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}

#pragma mark - 移除定时器
- (void)removeTimer
{
    // 停止定时器
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - 定时器方法
- (void)timerAction:(NSTimer *)timer
{
    NSIndexPath *currentIndexPath = [[self.bannerCollectView indexPathsForVisibleItems] lastObject];
    if (currentIndexPath.row == self.bannerList.count - 1) {
        NSInteger section;
        if (currentIndexPath.section == bannerMaxCount - 1) {
            section = bannerMaxCount/2;
        }else
        {
            section = currentIndexPath.section + 1;
        }
        currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:section ];
    }else
    {
        currentIndexPath = [NSIndexPath indexPathForRow:currentIndexPath.row + 1 inSection:currentIndexPath.section ];
    }
    
    self.pageControl.currentPage = currentIndexPath.row;
    
    [self.bannerCollectView scrollToItemAtIndexPath:currentIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    
}




- (void)scrollToCenter
{
    [self.bannerCollectView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:bannerMaxCount/2] atScrollPosition:0 animated:NO];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return bannerMaxCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.bannerList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HHBannerCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HHBannerCell" forIndexPath:indexPath];
    [cell.imgV sd_setImageWithURL:[NSURL URLWithString:self.bannerList[indexPath.row]]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.clickIndex) {
        self.clickIndex(indexPath.row);
    }
}

#pragma mark  - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    int page = (int)((scrollView.contentOffset.x  + scrollView.bounds.size.width * 0.5)/ scrollView.bounds.size.width ) % self.bannerList.count;
    self.pageControl.currentPage = page;
}

@end
