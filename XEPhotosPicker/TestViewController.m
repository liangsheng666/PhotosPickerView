//
//  TestViewController.m
//  XEPhotosPicker
//
//  Created by 小二 on 2019/11/12.
//  Copyright © 2019 小二. All rights reserved.
//

#import "TestViewController.h"
#import "HeadView.h"
#import "XEPhotoPickerManager.h"
#import "XEPhotosPickerMacro.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface TestViewController () <HeadViewDelegate>
@property (nonatomic, strong) HeadView *headView;
@property (nonatomic, strong) XEPhotoPickerManager *pickerManager;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.headView];
    
}

- (void)delectBtnWithHeadView:(HeadView *)headView andButtonIndex:(NSInteger)index {
    __weak typeof(self) weakSelf = self;
    [self.pickerManager deletePhotoWithIndex:index - 100 complete:^(NSMutableArray * _Nonnull imageArray) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.headView refreshHeadView:imageArray];
    }];
}

- (void)addBtnWithHeadView:(HeadView *)headView {
    __weak typeof(self) weakSelf = self;
    [self.pickerManager addPhotoByPicker:^(NSMutableArray * _Nonnull imageArray) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.headView refreshHeadView:imageArray];
    }];
}

- (HeadView *)headView {
    if (!_headView) {
        _headView = [[HeadView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenWidth, kScreenHeight)];
        _headView.delegate = self;
    }
    return _headView;
}

- (XEPhotoPickerManager *)pickerManager {
    if (!_pickerManager) {
        _pickerManager = [[XEPhotoPickerManager alloc] init];
    }
    return _pickerManager;
}

@end
