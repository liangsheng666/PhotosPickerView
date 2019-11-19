//
//  XEPhotoPickerManager.h
//  XEPhotosPicker
//
//  Created by 小二 on 2019/11/18.
//  Copyright © 2019 小二. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XEPhotoAssetsManager.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^XEPhotoPickerAlbumAddBlock)(NSMutableArray *imageArray);
typedef void(^XEPhotoPickerAlbumDeletBlock)(NSMutableArray *imageArray);

@interface XEPhotoPickerManager : NSObject

/// 添加图片
/// @param addBlock block回调
- (void)addPhotoByPicker:(XEPhotoPickerAlbumAddBlock)addBlock;

/// 删除图片
/// @param deletBlock block回调
- (void)deletePhotoWithIndex:(NSUInteger)index
                    complete:(XEPhotoPickerAlbumDeletBlock)deletBlock;

@end

NS_ASSUME_NONNULL_END
