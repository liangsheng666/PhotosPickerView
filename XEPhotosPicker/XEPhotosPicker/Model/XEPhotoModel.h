//
//  XEPhotoModel.h
//  XEPhotosPicker
//
//  Created by 小二 on 2019/11/18.
//  Copyright © 2019 小二. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PhotoModelType) {
    PhotoModelTypeAblum,   //本地相册图片
    PhotoModelTypeNetwork  //网络加载图片
};

@interface XEPhotoModel : NSObject<NSCopying>

#pragma mark -- public
/** 公用的属性*/

///图片来源
@property (nonatomic,assign) PhotoModelType  photoModelType;
///图片
@property (nonatomic,strong) UIImage *photoImage;
///选中的次序，起始值为1，0表示没有图片选中
@property (nonatomic,assign) NSInteger photoPickedIndex;
///在相册中次序，起始值为0
@property (nonatomic,assign) NSInteger photoAlbumIndex;
///是否选中
@property (nonatomic,assign) Boolean isPicked;
///是否可以选择
@property (nonatomic,assign) Boolean canPicked;

#pragma mark -- Network
/** 从网络上获取图片需要额外的几个属性*/
///大图
@property (nonatomic,copy) NSString *bigUrlStr;
///小图
@property (nonatomic,copy) NSString *smallUrlStr;

#pragma mark -- Ablum
/** 从相册获取图片资源需要额外的属性*/
///图片资源
@property (nonatomic,strong)  PHAsset *asset;

@property (nonatomic,strong)  UIImage *image;


@end

NS_ASSUME_NONNULL_END
