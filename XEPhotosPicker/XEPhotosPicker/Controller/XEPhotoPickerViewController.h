//
//  XEPhotoPickerViewController.h
//  XEPhotosPicker
//
//  Created by 小二 on 2019/11/18.
//  Copyright © 2019 小二. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, PickerPhotoViewType) {
    PickerPhotoViewTypeAlbum = 0,
    PickerPhotoViewTypeNetwork
};

typedef void(^XEPhotoPickerVCBlock)(NSMutableArray *imageArray);

@interface XEPhotoPickerViewController : UIViewController

@property (nonatomic,copy) XEPhotoPickerVCBlock photoPickerVCBlock;

/**
 数据源类型
 */
@property (assign, nonatomic) PickerPhotoViewType pickerPhotoViewType;

/**
 图片资源
 */
@property (nonatomic, strong) PHFetchResult *assetResult;


/**
 已经选择过的图片资源数组
 */
@property (nonatomic,strong) NSMutableArray *oldPickedAssetArr;


@end

NS_ASSUME_NONNULL_END
