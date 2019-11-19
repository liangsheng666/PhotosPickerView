//
//  XEPhotoModel.m
//  XEPhotosPicker
//
//  Created by 小二 on 2019/11/18.
//  Copyright © 2019 小二. All rights reserved.
//

#import "XEPhotoModel.h"

@implementation XEPhotoModel

- (id)copyWithZone:(NSZone *)zone {
    XEPhotoModel *modelCopy = [[self class] allocWithZone:zone];
    
    switch (self.photoModelType) {
        case PhotoModelTypeAblum:
            modelCopy.photoImage = self.photoImage;
            modelCopy.photoPickedIndex = self.photoPickedIndex;
            modelCopy.photoAlbumIndex = self.photoAlbumIndex;
            modelCopy.asset = self.asset;
            break;
            
        case PhotoModelTypeNetwork:
            modelCopy.photoImage = self.photoImage;
            modelCopy.photoPickedIndex = self.photoPickedIndex;
            modelCopy.photoAlbumIndex = self.photoAlbumIndex;
            modelCopy.bigUrlStr = self.bigUrlStr;
            modelCopy.smallUrlStr = self.smallUrlStr;
            break;
        default:
            break;
    }
    return modelCopy;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"photoImage :%@",self.photoImage];
}

@end
    
