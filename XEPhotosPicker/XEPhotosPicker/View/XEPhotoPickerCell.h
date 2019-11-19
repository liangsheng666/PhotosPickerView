//
//  XEPhotoPickerCell.h
//  XEPhotosPicker
//
//  Created by 小二 on 2019/11/18.
//  Copyright © 2019 小二. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XEPhotoModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^PickBtnBlock)(XEPhotoModel *curPickModel);
typedef void(^ModelChangeBlock)(XEPhotoModel *modifiedModel);

@interface XEPhotoPickerCell : UICollectionViewCell
@property (nonatomic,strong) XEPhotoModel *model;
@property (nonatomic,copy) PickBtnBlock pickBtnBlock;
@property (nonatomic,assign) Boolean isDownloaded;
///加载图片视图
@property (nonatomic,strong) UIImageView *imgView;

- (void)modelChangePickedIndex:(NSInteger)pickedIndex;

@end

NS_ASSUME_NONNULL_END
