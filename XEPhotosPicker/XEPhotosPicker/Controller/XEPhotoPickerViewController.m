//
//  XEPhotoPickerViewController.m
//  XEPhotosPicker
//
//  Created by 小二 on 2019/11/18.
//  Copyright © 2019 小二. All rights reserved.
//

#import "XEPhotoPickerViewController.h"

#import "XEPhotoPickerCell.h"
#import "XEPhotoPickerToolBar.h"

#import "XEPhotoModel.h"
#import "XEPhotosPickerMacro.h"
#import "XEPhotoAssetsManager.h"
#import "XEPhotoPickerManager.h"

static NSString * const kPhotoPickerCellID = @"PhotoPickerCellID";

@interface XEPhotoPickerViewController ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) XEPhotoPickerToolBar *toolBar;
@property (nonatomic,strong) NSMutableArray<__kindof XEPhotoModel *> *photoArray;
@property (nonatomic,strong) NSMutableArray *pickedArray;

@end

@implementation XEPhotoPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self initData];
}

#pragma mark -- private method
- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.title.length == 0) {
        self.title = @"所有照片";
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarBtnAction:)];
    
    [self.view addSubview:self.toolBar];
    [self.view addSubview:self.collectionView];
}

- (void)initData {
    switch (_pickerPhotoViewType) {
        case PickerPhotoViewTypeAlbum:
            [self loadAlbumPhotos];
            break;
        case PickerPhotoViewTypeNetwork:
            
            break;
        default:
            break;
    }
}

- (void)loadAlbumPhotos {
    [[XEPhotoAssetsManager sharedManager] requestAllAssetsWithMediaType:PHAssetMediaTypeImage fetchResult:^(NSMutableArray *assetsArr) {
        for (PHAsset *asset in assetsArr) {
            XEPhotoModel *model = [[XEPhotoModel alloc] init];
            model.photoModelType = PhotoModelTypeAblum;
            model.asset = asset;
            model.photoAlbumIndex = self.photoArray.count;
            model.photoPickedIndex = 0;
            model.isPicked = NO;
            [self.photoArray addObject:model];
        }
    }];
    
    if (self.oldPickedAssetArr.count > 0) {
        [self.toolBar changePickedIndex:self.oldPickedAssetArr.count];
    }
    
    [self.collectionView reloadData];
}

- (Boolean)changeCell:(XEPhotoPickerCell *)changedCell WithModel:(XEPhotoModel *)changedModel {
    //限制图片数量
    if (self.pickedArray.count >= PICK_PHOTO_MAX_SIZE) {
        Boolean Picked = NO;//是被选择的
        for (XEPhotoModel *tempModel in self.pickedArray) {
            if (tempModel.photoAlbumIndex == changedModel.photoAlbumIndex) {
                Picked = YES;
            }
        }
        
        if (!Picked) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"最多只能选择%i张图片", PICK_PHOTO_MAX_SIZE] message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                
            [alert addAction:cancelAction];
                
            [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
            return NO;
        }
    }
    
    //选中
    if (changedModel.isPicked) {
        //改变cell的index
        [changedCell modelChangePickedIndex:self.pickedArray.count + 1];
        //把选中的照片对应的model加入pickerArray
        [self.pickedArray addObject:changedModel];
    }
    //取消选中
    else {
        [self.pickedArray removeObject:changedModel];
        // 更新剩下选择的图片
        for (int i = 0; i < self.pickedArray.count; i++) {
            XEPhotoModel *otherPickedModel = self.pickedArray[i];
            
            //判断只要比取消选中的图片的index大的都要-1
            if (otherPickedModel.photoPickedIndex > changedModel.photoPickedIndex) {
                otherPickedModel.photoPickedIndex -= 1;
                NSIndexPath *indexP =[NSIndexPath indexPathForItem:otherPickedModel.photoAlbumIndex inSection:0];
                XEPhotoPickerCell *otherCell = (XEPhotoPickerCell *)[self.collectionView cellForItemAtIndexPath:indexP];
                //更新index有改变的图片
                [otherCell modelChangePickedIndex:otherPickedModel.photoPickedIndex];
            }
        }
        // 更新 取消选择的图片
        [changedCell modelChangePickedIndex:0];
    }
    // 更改工具栏状态信息
    [self.toolBar changePickedIndex:self.pickedArray.count];
    return YES;
}

#pragma mark --UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XEPhotoPickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotoPickerCellID forIndexPath:indexPath];
    
    XEPhotoModel *model = self.photoArray[indexPath.row];
    
    if (!model.image) {
        [[XEPhotoAssetsManager sharedManager] requestImageWithPHAsset:model.asset targetSize:CGSizeMake(kCellImage_W, kCellImage_W) imageResult:^(UIImage *image) {
            model.image = image;
        }];
    }
    
     //上个页面传过来的，已经选过得图片
     for (NSInteger j = 0; j < self.oldPickedAssetArr.count; j++) {
         UIImage *pickedImage = self.oldPickedAssetArr[j];
         NSData *data = UIImagePNGRepresentation(model.image);
         NSData *pickData = UIImagePNGRepresentation(pickedImage);
         if ([data isEqual:pickData]) {
             model.isPicked = YES;
             model.photoPickedIndex = j+1;
             [self.pickedArray addObject:model];
         }
     }
    
    [cell setModel:model];
    cell.imgView.image = model.image;
    
    __weak typeof(cell) weakCell = cell;
    cell.pickBtnBlock = ^(XEPhotoModel *curPickModel) {
        [self changeCell:weakCell WithModel:curPickModel];
    };
    
    return  cell;
}
#pragma end mark

#pragma mark --UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kCellImage_W, kCellImage_W);
}


#pragma mark -- event response
///toolBar的预览按钮
- (void)previewPhotoAction:(UIButton *)sender {
    NSLog(@"程序员还在努力开发中....");
}

///toolBar的确定按钮
- (void)sureBtnAction:(UIButton *)sender {
    switch (_pickerPhotoViewType) {
        case PickerPhotoViewTypeAlbum: {
            NSMutableArray *imageArray = [NSMutableArray array];
            
            //如果是选过二次点进来选择，上面我是在cell中遍历oldPickedAssetArr数组，再加入pickArray中的这时候model.photoPickedIndex顺序被打乱，意味着图片顺序被打乱，所以在这里用选择排序，把数组中的图片按照model.photoPickedIndex的顺序排列一遍再回调就没问题了。
            if (self.oldPickedAssetArr.count > 0) {
                for (int  i =0; i < [self.pickedArray count]-1; i++) {
                    for (int j = i+1; j < [self.pickedArray count]; j++) {
                        XEPhotoModel *beforeModel = self.pickedArray[i];
                        XEPhotoModel *nextModel = self.pickedArray[j];
                        if (beforeModel.photoPickedIndex > nextModel.photoPickedIndex) {
                            //交换
                            [self.pickedArray exchangeObjectAtIndex:i withObjectAtIndex:j];
                        }
                    }
                }
            }
            
            for (XEPhotoModel *model in self.pickedArray) {
                [imageArray addObject:model.image];
            }
            !self.photoPickerVCBlock?: self.photoPickerVCBlock(imageArray);
            break;
        }
        case PickerPhotoViewTypeNetwork: {
            break;
        }
        default:
           break;
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

///取消按钮
- (void)rightBarBtnAction:(UIButton *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - getter/setter
- (XEPhotoPickerToolBar *)toolBar {
    if (!_toolBar) {
        _toolBar = [[XEPhotoPickerToolBar alloc] init];
        [_toolBar.preViewBtn addTarget:self action:@selector(previewPhotoAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [_toolBar.sureBtn addTarget:self action:@selector(sureBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _toolBar;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 5.0f;
        layout.minimumInteritemSpacing = 0.0f;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, XESCREEN_W, XESCREEN_H - kSafeAreaBottomHeight - self.toolBar.frame.size.height) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[XEPhotoPickerCell class] forCellWithReuseIdentifier:kPhotoPickerCellID];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.pagingEnabled = NO;
    }
    return _collectionView;
}

- (NSMutableArray *)photoArray {
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}

- (NSMutableArray *)pickedArray {
    if (!_pickedArray) {
        _pickedArray = [NSMutableArray array];
    }
    return _pickedArray;
}

@end
