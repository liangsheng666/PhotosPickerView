//
//  HeadView.m
//  XEPhotosPicker
//
//  Created by 小二 on 2019/11/12.
//  Copyright © 2019 小二. All rights reserved.
//

#import "HeadView.h"

#define kPadding 10
#define kTextViewHeight 100
#define kPictureHW (CGRectGetWidth([UIScreen mainScreen].bounds) - 5*kPadding)/4
#define kMaxImageCount 9
#define kDeleImageWH 25 // 删除按钮的宽高
#define kImageTag 2000

@interface HeadView ()<UITextViewDelegate>

@property (nonatomic,strong) UITextView *reportTextView;
@property (nonatomic,strong) UILabel *reportLb;
@property (nonatomic,strong) UIButton *addPictureBtn;

@end

@implementation HeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

//大图特别耗内存，不能把大图存在数组里，存类型或者小图
- (void)createUI {
    [self addSubview:self.reportTextView];
    [self addSubview:self.reportLb];
    [self addSubview:self.addPictureBtn];
}

- (void)refreshHeadView:(NSMutableArray *)imageArray {
    for (UIView *view in self.subviews) {
        if ([view isMemberOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    for (NSInteger i = 0; i < imageArray.count; i++) {
        UIImageView *pictureImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kPadding + (i%4)*(kPictureHW+kPadding), CGRectGetMaxY(_reportTextView.frame) + kPadding +(i/4)*(kPictureHW+kPadding), kPictureHW, kPictureHW)];
        //用作放大图片
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
        [pictureImageView addGestureRecognizer:tap];
        
        //添加删除按钮
        UIButton *dele = [UIButton buttonWithType:UIButtonTypeCustom];
        dele.frame = CGRectMake(kPictureHW - kDeleImageWH + 5, -10, kDeleImageWH, kDeleImageWH);
        [dele setImage:[UIImage imageNamed:@"deletePhoto"] forState:UIControlStateNormal];
        [dele addTarget:self action:@selector(deleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        dele.tag = 100+i;
        [pictureImageView addSubview:dele];
        
        pictureImageView.tag = kImageTag + i;
        pictureImageView.userInteractionEnabled = YES;
        pictureImageView.image = imageArray[i];
        [self addSubview:pictureImageView];
    }
    
    if (imageArray.count < kMaxImageCount) {
        self.addPictureBtn.frame = CGRectMake(kPadding + (imageArray.count%4)*(kPictureHW+kPadding), CGRectGetMaxY(_reportTextView.frame) + kPadding +(imageArray.count/4)*(kPictureHW+kPadding), kPictureHW, kPictureHW);
    }
    
    NSInteger headViewHeight = 120 + (10 + kPictureHW)*(imageArray.count/4 + 1);
    self.frame = CGRectMake(0, 88, CGRectGetWidth([UIScreen mainScreen].bounds), headViewHeight);
}

//点击放大图片
- (void)tapImageView:(UITapGestureRecognizer *)tag {
    NSLog(@"点击了图片");
}

- (void)deleBtnAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(delectBtnWithHeadView:andButtonIndex:)]) {
        [self.delegate delectBtnWithHeadView:self andButtonIndex:sender.tag];
    }
}

- (void)addBtnAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(addBtnWithHeadView:)]) {
        [self.delegate addBtnWithHeadView:self];
    }
}

- (UITextView *)reportTextView {
    if (!_reportTextView) {
        _reportTextView = [[UITextView alloc]initWithFrame:CGRectMake(kPadding, kPadding, CGRectGetWidth([UIScreen mainScreen].bounds) - 2*kPadding, kTextViewHeight)];
        _reportTextView.text = _reportTextView.text;  //防止用户已经输入了文字状态
        _reportTextView.returnKeyType = UIReturnKeyDone;
        _reportTextView.font = [UIFont systemFontOfSize:15];
        _reportTextView.delegate = self;
    }
    return _reportTextView;
}

- (UILabel *)reportLb {
    if (!_reportLb) {
        _reportLb = [[UILabel alloc]initWithFrame:CGRectMake(kPadding+5, 2 * kPadding, CGRectGetWidth([UIScreen mainScreen].bounds), 10)];
        _reportLb.text = @"这一刻的想法...";
        _reportLb.hidden = [self.reportTextView.text length];
        _reportLb.font = [UIFont systemFontOfSize:15];
        _reportLb.textColor = [UIColor colorWithRed:152/255.0 green:152/255.0 blue:152/255.0 alpha:1];
    }
    return _reportLb;
}

- (UIButton *)addPictureBtn {
    if (!_addPictureBtn) {
        _addPictureBtn = [[UIButton alloc]initWithFrame:CGRectMake(kPadding, CGRectGetMaxY(self.reportTextView.frame) + kPadding, kPictureHW, kPictureHW)];
        [_addPictureBtn setBackgroundImage:[UIImage imageNamed:@"addPictures"] forState:UIControlStateNormal];
        [_addPictureBtn addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addPictureBtn;
}

@end
