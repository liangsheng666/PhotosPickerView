//
//  XEPhotoPickerCell.m
//  XEPhotosPicker
//
//  Created by 小二 on 2019/11/18.
//  Copyright © 2019 小二. All rights reserved.
//

#import "XEPhotoPickerCell.h"
#import "XEPhotosPickerMacro.h"
#import "XEPhotoAssetsManager.h"

@interface XEPhotoPickerCell()
///选择按钮
@property (nonatomic,strong) UIButton *pickBtn;
///加载进度的动画界面
//@property (nonatomic,strong) LSCircleLoadingView *circleLoadingView;
///加载进度
@property (nonatomic,assign) CGFloat curProgress;

@end

@implementation XEPhotoPickerCell

#pragma mark -- life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = kNavBarColor.CGColor;
        [self createUI];
    }
    return self;
}

#pragma mark -- public method
- (void)modelChangePickedIndex:(NSInteger)pickedIndex {
    if (pickedIndex != 0) {
        self.model.photoPickedIndex = pickedIndex;
        self.model.isPicked = YES;
        [self.pickBtn setTitle:[NSString stringWithFormat:@"%ld",(long)pickedIndex] forState:(UIControlStateNormal)];
        self.pickBtn.backgroundColor = kNavBarColor;
        [self showOscillatoryAnimationWithLayer:self.pickBtn.layer];
    }
    else {
        self.model.photoPickedIndex = 0;
        self.model.isPicked = NO;
        [self.pickBtn setTitle:@"" forState:(UIControlStateNormal)];
        self.pickBtn.backgroundColor = [UIColor colorWithRed:148/255.0 green:148/255.0 blue:148/255.0 alpha:0.6];
    }
}

#pragma mark -- private method
- (void)createUI {
//    [self.contentView addSubview:self.circleLoadingView];
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.pickBtn];
    
    _isDownloaded = NO;
    _curProgress = 0.0f;
}

- (void)showOscillatoryAnimationWithLayer:(CALayer *)layer {
    NSNumber *animationScale1 = @(1.15);
    NSNumber *animationScale2 = @(0.85);
    NSNumber *animationScale3 = @(1.0);
    
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        [layer setValue:animationScale1 forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
            [layer setValue:animationScale2 forKeyPath:@"transform.scale"];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                [layer setValue:animationScale3 forKeyPath:@"transform.scale"];
            } completion:nil];
        }];
    }];
}

#pragma mark -- event response
- (void)pickBtnAction:(UIButton *)sender {
    self.model.isPicked = !self.model.isPicked;
    self.pickBtnBlock(self.model);
}

#pragma mark -- getter/setter
//- (LSCircleLoadingView *)circleLoadingView {
//    if (!_circleLoadingView) {
//
//    }
//    return _circleLoadingView;
//}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kCellImage_W, kCellImage_W)];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgView;
}

- (UIButton *)pickBtn {
    if (!_pickBtn) {
        _pickBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _pickBtn.frame = CGRectMake(CGRectGetMaxX(self.imgView.frame) - CGRectGetWidth(self.imgView.frame) * 0.35,CGRectGetWidth(self.imgView.frame) * 0.05, CGRectGetWidth(self.imgView.frame) * 0.3, CGRectGetWidth(self.imgView.frame) * 0.3);
        
        _pickBtn.layer.cornerRadius = CGRectGetWidth(_pickBtn.frame) * 0.5;
        _pickBtn.layer.masksToBounds = YES;
        _pickBtn.layer.borderWidth = 1;
        _pickBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        
        _pickBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _pickBtn.backgroundColor = [UIColor colorWithRed:148/255.0 green:148/255.0 blue:148/255.0 alpha:0.6];
        
        [_pickBtn addTarget:self action:@selector(pickBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _pickBtn;
}

- (void)setModel:(XEPhotoModel *)model {
    _model = model;
    
    if (model.photoPickedIndex != 0) {
        
        [self.pickBtn setTitle:[NSString stringWithFormat:@"%ld",(long)model.photoPickedIndex] forState:(UIControlStateNormal)];
        self.pickBtn.backgroundColor = kNavBarColor;
    }
    else {
        
        [self.pickBtn setTitle:@"" forState:(UIControlStateNormal)];
        self.pickBtn.backgroundColor = [UIColor colorWithRed:148/255.0 green:148/255.0 blue:148/255.0 alpha:0.6];
    }
    
    //    [self _downloadSmallImg];
    switch (_model.photoModelType) {
        case PhotoModelTypeAblum: {
//            self.circleLoadingView.hidden = YES;
            
            break;
        }
        case PhotoModelTypeNetwork: {
//            [self _startDownloadBigImg];
            break;
        }
        default:
            break;
    }
}

@end
