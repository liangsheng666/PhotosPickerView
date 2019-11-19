//
//  XEPhotosPickerMacro.h
//  XEPhotosPicker
//
//  Created by 小二 on 2019/11/12.
//  Copyright © 2019 小二. All rights reserved.
//

#ifndef XEPhotosPickerMacro_h
#define XEPhotosPickerMacro_h

#define XESCREEN_W CGRectGetWidth([UIScreen mainScreen].bounds)
#define XESCREEN_H CGRectGetHeight([UIScreen mainScreen].bounds)

#define UIColorFromHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kNavBarColor [UIColor colorWithRed:0/255.0 green:149/255.0 blue:135/255.0 alpha:1]

#define kIs_iPhoneX ([[UIApplication sharedApplication] statusBarFrame].size.height == 44 ? YES : NO)   //适配刘海机型
#define kStatusBarAndNavigationBarHeight (kIs_iPhoneX ? 88.f : 64.f)
#define kSafeAreaBottomHeight  (kIs_iPhoneX ? 34.0 : 0.0)

#define kMarginX 15

#define kCellImage_W (CGRectGetWidth([UIScreen mainScreen].bounds) - 15.0) / 4.0

#define PICK_PHOTO_MAX_SIZE 9

#define PickAssetNotification @"pickAssetNotification"

#endif /* XEPhotosPickerMacro_h */
