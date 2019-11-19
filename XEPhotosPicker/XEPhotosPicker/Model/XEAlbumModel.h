//
//  XEAlbumModel.h
//  XEPhotosPicker
//
//  Created by 小二 on 2019/11/12.
//  Copyright © 2019 小二. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface XEAlbumModel : NSObject

@property (nonatomic, strong) PHFetchResult *assetResult;
@property (nonatomic, strong) NSString *title;

@end

NS_ASSUME_NONNULL_END
