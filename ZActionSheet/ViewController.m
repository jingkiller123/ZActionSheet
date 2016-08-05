//
//  ViewController.m
//  ZActionSheet
//
//  Created by zhuangjing on 16/8/4.
//  Copyright © 2016年 zhuangjing. All rights reserved.
//

#import "ViewController.h"
#import "ZActionSheetHelper.h"

//自定义
#import "ZPhotoHelper.h"

@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>  {

    ZActionSheetHelper *helper;
}

@property (weak, nonatomic) IBOutlet UIButton *showActionSheetBtn;

@property (nonatomic) ZPhotoHelper *customHelper;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)toggleShowASBtn:(id)sender {
    
//    [self originalTest];
    
    [self customTest];
}

- (void)originalTest {
    
    if (!helper) {
        helper = [ZActionSheetHelper actionSheetWithItems:@[@"Google地图", @"百度地图", @"高德地图", @"腾讯地图", @"手机自带地图"] title:@"请选择导航地图"];
    }
    
    [helper show];
    
    helper.selectActionSheetBlock = ^(NSInteger index) {
        
        NSLog(@"反馈回来的索引值 %@", [NSNumber numberWithInteger:index]);
    };
}

- (void)customTest {

    if (!_customHelper) {
        self.customHelper = [ZPhotoHelper defaultPhotoHelper];
    }
    
    [_customHelper show];
    
    
    /**
     *  以下属于具体自定义事件的测试
     */
    __weak ViewController *weakSelf = self;
    _customHelper.CameraBlock = ^{
        
        if (!PresentPhotoCamera(weakSelf, YES)) {
            NSLog(@"模拟器不支持相机");
        }
    };
    
    _customHelper.PhotoBlock = ^{
        
        PresentPhotoLibrary(weakSelf, YES);
    };
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    //    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        
        
    }
    else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        
    }
    else if (picker.sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum) {
        
    }
    else {
        
        NSLog(@"异常");
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// 当用户取消时，调用该方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
