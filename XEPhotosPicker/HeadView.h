//
//  HeadView.h
//  XEPhotosPicker
//
//  Created by 小二 on 2019/11/12.
//  Copyright © 2019 小二. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HeadView;
@protocol HeadViewDelegate <NSObject>

- (void)delectBtnWithHeadView:(HeadView *)headView andButtonIndex:(NSInteger)index;

- (void)addBtnWithHeadView:(HeadView *)headView;

@end

@interface HeadView : UIView

@property (nonatomic,weak) id<HeadViewDelegate>delegate;

- (void)refreshHeadView:(NSMutableArray *)imageArray;

@end

NS_ASSUME_NONNULL_END
