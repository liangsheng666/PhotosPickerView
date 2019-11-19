//
//  XEPhotoPickerToolBar.m
//  XEPhotosPicker
//
//  Created by 小二 on 2019/11/18.
//  Copyright © 2019 小二. All rights reserved.
//

#import "XEPhotoPickerToolBar.h"
#import "XEPhotosPickerMacro.h"

#define kToolBarHeight 50

@interface XEPhotoPickerToolBar ()

@property (nonatomic,assign) Boolean barHide;

@end

@implementation XEPhotoPickerToolBar

#pragma mark -- life cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, XESCREEN_H - kSafeAreaBottomHeight - kToolBarHeight, XESCREEN_W, kToolBarHeight);
        [self createUI];
    }
    return self;
}

#pragma mark -- private method
- (void)createUI {
    self.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:0.9];
    [self addSubview:self.preViewBtn];
    [self addSubview:self.sureBtn];
}

#pragma mark -- public method
///改变toolBar颜色状态
- (void)changePickedIndex:(NSInteger)pickedIndex {
    if (pickedIndex == 0) {
        [_preViewBtn setTitleColor:[UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1] forState:(UIControlStateNormal)];
        
        _sureBtn.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        [_sureBtn setTitleColor:[UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1] forState:(UIControlStateNormal)];
        [_sureBtn setTitle:@"确定" forState:(UIControlStateNormal)];
    }
    else
    {
        [_preViewBtn setTitleColor:kNavBarColor forState:(UIControlStateNormal)];
        _sureBtn.backgroundColor = kNavBarColor;
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_sureBtn setTitle:[NSString stringWithFormat:@"确定(%lu)",(unsigned long)pickedIndex] forState:(UIControlStateNormal)];
    }
}

///改变toolBar是否显示
- (void)changeHideState {
    self.barHide = !self.barHide;
    if (_barHide) {
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(0, XESCREEN_H, XESCREEN_W, 44);
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(0, XESCREEN_H - 44, XESCREEN_W, 44);
        }];
    }
}

#pragma mark -- getter/setter
- (UIButton *)preViewBtn {
    if (!_preViewBtn) {
        _preViewBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _preViewBtn.frame = CGRectMake(5, 5, XESCREEN_W * (60/320.0), CGRectGetHeight(self.frame) - 10);
        [_preViewBtn setTitleColor:[UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1] forState:(UIControlStateNormal)];
        _preViewBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_preViewBtn setTitle:@"预览" forState:(UIControlStateNormal)];
    }
    return _preViewBtn;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _sureBtn.frame = CGRectMake(XESCREEN_W - (XESCREEN_W * (65/320.0) + 10), 5, XESCREEN_W * (65/320.0), CGRectGetHeight(self.frame) - 10);
        _sureBtn.backgroundColor = kNavBarColor;
        [_sureBtn setTitleColor:[UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1] forState:(UIControlStateNormal)];
        _sureBtn.layer.cornerRadius = 2;
        _sureBtn.layer.masksToBounds = YES;
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_sureBtn setTitle:@"确定" forState:(UIControlStateNormal)];
        
    }
    return _sureBtn;
}


@end
