//
//  XEPhotoPickerManager.m
//  XEPhotosPicker
//
//  Created by 小二 on 2019/11/18.
//  Copyright © 2019 小二. All rights reserved.
//

#import "XEPhotoPickerManager.h"
#import "XEPhotoPickerViewController.h"

@interface XEPhotoPickerManager()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) NSMutableArray *imagePickerArray;
@property (nonatomic, copy) XEPhotoPickerAlbumAddBlock addBlock;

@end

@implementation XEPhotoPickerManager

/// 添加图片
/// @param addBlock block回调
- (void)addPhotoByPicker:(XEPhotoPickerAlbumAddBlock)addBlock {
    self.addBlock = addBlock;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
       
       //取消
       UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
           
       }];
       
       //从相册选择
       UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           [self showPhotoPickerWithOldPickedAssetsArr:self.imagePickerArray];
       }];

       //拍照
       UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
           
           if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
               sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
           }
           
           UIImagePickerController *picker = [[UIImagePickerController alloc]init];
           picker.delegate = self;
           picker.allowsEditing = YES;
           picker.sourceType = sourceType;
           [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:picker animated:YES completion:nil];
           
       }];
       
       [alertController addAction:cancelAction];
       [alertController addAction:cameraAction];
       [alertController addAction:photoAction];
       [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alertController animated:YES completion:nil];
}

/// 删除图片
/// @param deletBlock block回调
- (void)deletePhotoWithIndex:(NSUInteger)index
                    complete:(nonnull XEPhotoPickerAlbumDeletBlock)deletBlock {
    [self.imagePickerArray removeObjectAtIndex:index];
    !deletBlock?: deletBlock(self.imagePickerArray);
}

#pragma mark --- 实现UIImagePickerControllerDelegate协议 ---
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    //保存拍的照片到相册中
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(!error){
        NSLog(@"-=-=-=save success");
        //保存好以后获取相册的第一张照片就是拍照的
        [[XEPhotoAssetsManager sharedManager] fetchTheFirstAsset:^(UIImage *image) {
            [self.imagePickerArray addObject:image];
            !self.addBlock?: self.addBlock(self.imagePickerArray);
        }];
    }else{
        NSLog(@"-=-=-=save failed");
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)showPhotoPickerWithOldPickedAssetsArr:(NSMutableArray *)oldPickedAssetArr {

    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                    
                case PHAuthorizationStatusNotDetermined:
                {
                    NSLog(@"用户还没有做出选择");
                    break;
                }
                case PHAuthorizationStatusAuthorized:
                {
                    NSLog(@"用户允许当前应用访问相册");
                    XEPhotoPickerViewController *pickerVC = [[XEPhotoPickerViewController alloc] init];
                    pickerVC.pickerPhotoViewType = PickerPhotoViewTypeAlbum;
                    pickerVC.oldPickedAssetArr = oldPickedAssetArr;
                    __weak typeof(self) weakSelf = self;
                    pickerVC.photoPickerVCBlock = ^(NSMutableArray * _Nonnull imageArray) {
                        __strong typeof(self) strongSelf = weakSelf;
                        [strongSelf.imagePickerArray removeAllObjects];
                        [strongSelf.imagePickerArray addObjectsFromArray:imageArray];
                        !strongSelf.addBlock?: strongSelf.addBlock(imageArray);
                    };
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:pickerVC];
                    nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
                    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:nav animated:YES completion:nil];
                    
                    break;
                }
                case PHAuthorizationStatusDenied:
                {
                    NSLog(@"用户拒绝当前应用访问相册,我们需要提醒用户打开访问开关");
                    break;
                }
                case PHAuthorizationStatusRestricted:
                {
                    NSLog(@"家长控制,不允许访问");
                    break;
                }
                default:
                {
                    NSLog(@"default");
                    break;
                }
            }
        });
    }];
}

- (NSMutableArray *)imagePickerArray {
    if (!_imagePickerArray) {
        _imagePickerArray = [[NSMutableArray alloc] init];
    }
    return _imagePickerArray;
}

@end
