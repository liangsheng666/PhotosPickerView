//
//  XEPhotoAssetsManager.h
//  XEPhotosPicker
//
//  Created by 小二 on 2019/11/12.
//  Copyright © 2019 小二. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ImageBlock)(UIImage *image);
typedef void(^AlbumBlock)(NSArray *albumArray);
typedef void(^FetchResultBlock)(NSMutableArray *assetsArr);
typedef void(^ImageArrayBlock)(NSMutableArray *imageArr);

@interface XEPhotoAssetsManager : NSObject

#pragma mark -- method
/**
 单例
 
 @return 本类对象
 */
+ (instancetype)sharedManager;

/**
 获取对应相册中的图片资源
 
 @param asset 相册对应的资源
 @param targetSize 图片大小
 @param imageBlock 回调图片
 */
- (void)requestImageWithPHAsset:(PHAsset *)asset targetSize:(CGSize)targetSize imageResult:(ImageBlock)imageBlock;

/**
 获取相册
 
 @param type 获取的相册类型
 @param albumBlock 回调相册数组
 */
- (void)requestAlbumsWithType:(PHAssetCollectionType)type albumResult:(AlbumBlock)albumBlock;


/**
 获取所有图片资源
 
 @param type 获取的图片来源
 @param resultBlock 返回所有图片资源
 */
- (void)requestAllAssetsWithMediaType:(PHAssetMediaType)type fetchResult:(FetchResultBlock)resultBlock;

/**
 通过所有图片资源获取图片
 
 @param assets 所有图片资源
 @param targetSize 图片大小
 @param imageArrBlock 返回图片数组
 */
- (void)requestImageWithFetchResult:(PHFetchResult *)assets targetSize:(CGSize)targetSize imageResult:(ImageArrayBlock)imageArrBlock;

/**
 获取最新的一张图片
 
 @param imageBloc 图片的回调
 */
- (void)fetchTheFirstAsset:(ImageBlock)imageBloc;

/**
 清除缓存
 */
- (void)clearImageCaches;


@end

NS_ASSUME_NONNULL_END
