//
//  XEPhotoPickerToolBar.h
//  XEPhotosPicker
//
//  Created by 小二 on 2019/11/18.
//  Copyright © 2019 小二. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XEPhotoPickerToolBar : UIView

@property (nonatomic,strong) UIButton *preViewBtn;
@property (nonatomic,strong) UIButton *sureBtn;

/**
 当选中勾选图片时，改变toolBar的显示
 
 @param pickedIndex NSInteger
 */
- (void)changePickedIndex:(NSInteger)pickedIndex;

/**
 隐藏显示toolBar
 */
- (void)changeHideState;

@end

NS_ASSUME_NONNULL_END
