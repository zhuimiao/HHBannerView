
//  Created by boitx on 2017/5/18.
//  Copyright © 2017年 boitx. All rights reserved.
//

#define bannerMaxCount 100


#import <UIKit/UIKit.h>

@interface HHBannerCell : UICollectionViewCell

@property (nonatomic,strong)UIImageView *imgV;

@end


@interface HHBannerView : UIView

@property(nonatomic,copy)NSArray *bannerList;

@property(nonatomic,copy) void(^clickIndex)(NSInteger index);


@end
