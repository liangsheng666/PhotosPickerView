//
//  XEPhotoAssetsManager.m
//  XEPhotosPicker
//
//  Created by 小二 on 2019/11/12.
//  Copyright © 2019 小二. All rights reserved.
//

#import "XEPhotoAssetsManager.h"
#import "XEAlbumModel.h"

#define kImageCachesPath [NSTemporaryDirectory() stringByAppendingString:@"TempImages"]

#define kImage_W (CGRectGetWidth([UIScreen mainScreen].bounds) - 15.0) / 4.0

@implementation XEPhotoAssetsManager

+ (instancetype)sharedManager {
    static XEPhotoAssetsManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[XEPhotoAssetsManager alloc] init];
        }
    });
    return manager;
}

/**
 获取相册（再通过相册获取图片）
 
 @param type 相册类型
 @param albumBlock 返回相册资源
 */
- (void)requestAlbumsWithType:(PHAssetCollectionType)type albumResult:(AlbumBlock)albumBlock {
    //列出所有智能相册
    /**
     type:SmartAlbum (经由相机得来的相册)
     PHAssertCollectionSubtypeAlbumRegular:用户在Photos中创建的相册，也就是所谓的逻辑相册
     */
    PHFetchResult *assetCollectionResult = [PHAssetCollection fetchAssetCollectionsWithType:type subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    NSMutableArray *albumArray = [NSMutableArray array];
    //这时smartAlbums中保存的应该是各个智能相册对应的PHAssetCollection（这里的智能相册是指系统中有的相册，比如收藏夹，相机相册等）
    for (NSInteger i = 0; i < assetCollectionResult.count; i++) {
        //获取一个智能相册（PHAssetCollection）
        PHCollection *collection = assetCollectionResult[i];
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            //从每一个智能相册中获取到的PHResult中包含的才是正真的资源PHAsset
            PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
            
            //相册中的图片数量为0就不展示
            if (assetResult.count != 0) {
                XEAlbumModel *model = [[XEAlbumModel alloc] init];
                model.title = collection.localizedTitle;
                model.assetResult = assetResult;
                [albumArray addObject:model];
            }
        }
    }
    albumBlock(albumArray);
}


/**
 获取资源对应的图片
 
 @param asset 图片资源
 @param targetSize 图片大小
 @param imageBlock 返回图片
 */
- (void)requestImageWithPHAsset:(PHAsset *)asset targetSize:(CGSize)targetSize imageResult:(ImageBlock)imageBlock {
    //使用PHImageManager从PHAsset中请求图片
    PHImageManager *imageManager = [[PHImageManager alloc] init];
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.synchronous = YES;
    
    [imageManager requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (result) {
            imageBlock(result);
        }
    }];
}

/**
 获取所有图片资源
 
 @param type 获取的图片来源
 @param resultBlock 返回图片
 */
- (void)requestAllAssetsWithMediaType:(PHAssetMediaType)type fetchResult:(FetchResultBlock)resultBlock {
    // 获取所有资源的集合，并按资源的创建时间排序
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    
    //获取相机胶卷所有图片
    PHFetchResult *assets = [PHAsset fetchAssetsWithMediaType:type options:nil];
    
    NSMutableArray *assetsArr = [[NSMutableArray alloc] init];
    [assets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[PHAsset class]]) {
            [assetsArr insertObject:obj atIndex:0];
        }
    }];
    
    PHCachingImageManager *cachingImage = [[PHCachingImageManager alloc] init];
    [cachingImage startCachingImagesForAssets:assetsArr
                                   targetSize:PHImageManagerMaximumSize
                                  contentMode:PHImageContentModeAspectFit
                                      options:nil];
    
    resultBlock(assetsArr);
}

/**
 通过所有图片资源获取图片
 
 @param assets 所有图片资源
 @param targetSize 图片大小
 @param imageArrBlock 返回图片数组
 */
- (void)requestImageWithFetchResult:(PHFetchResult *)assets targetSize:(CGSize)targetSize imageResult:(ImageArrayBlock)imageArrBlock {
    
    PHImageManager *imageManager = [[PHImageManager alloc] init];
    PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
    
    
    //设置显示模式
    /*
     PHImageRequestOptionsResizeModeNone    //选了这个就不会管传如的size了 ，要自己控制图片的大小，建议还是选Fast
     PHImageRequestOptionsResizeModeFast    //根据传入的size，迅速加载大小相匹配(略大于或略小于)的图像
     PHImageRequestOptionsResizeModeExact    //精确的加载与传入size相匹配的图像
     */
    
    requestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    
    //    option.synchronous = NO;
    //    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    //    CGFloat scale = [UIScreen mainScreen].scale;
    //    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    NSMutableArray *arr = [NSMutableArray array];
    for (PHAsset *asset in assets) {
        [imageManager requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if (result) {
                //                [arr addObject:result];
                [arr insertObject:result atIndex:0];
            }
        }];
    }
    imageArrBlock(arr);
}

- (void)fetchTheFirstAsset:(ImageBlock)imageBlock {
    //获取所有资源的集合，并按资源的创建时间排序
    // 获取所有资源的集合，并按资源的创建时间排序
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *assetResult = [PHAsset fetchAssetsWithOptions:options];
    
    //使用PHImageManager从PHAsset中请求图片
    PHImageManager *imageManager = [[PHImageManager alloc] init];
    PHImageRequestOptions *imageOptions = [[PHImageRequestOptions alloc] init];
    imageOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    imageOptions.synchronous = YES;
    
    [imageManager requestImageForAsset:[assetResult lastObject] targetSize:CGSizeMake(kImage_W, kImage_W) contentMode:PHImageContentModeAspectFill options:imageOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (result) {
            imageBlock(result);
        }
    }];
}

///清理缓存
- (void)clearImageCaches {
    NSString *path = kImageCachesPath;
    NSLog(@"ImageCachesPath:%@",path);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        [fileManager removeItemAtPath:path error:nil];
    }
}

@end
