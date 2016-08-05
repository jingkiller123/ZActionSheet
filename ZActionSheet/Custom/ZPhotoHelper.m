//
//  ZPhotoHelper.m
//  ZActionSheet
//
//  Created by zhuangjing on 16/8/5.
//  Copyright © 2016年 zhuangjing. All rights reserved.
//

#import "ZPhotoHelper.h"
#import "ZActionSheetHelper.h"
#import "ZCameraPhotoView.h"

@interface ZPhotoHelper ()

@property (nonatomic) ZActionSheetHelper *containerHelper;

@end

@implementation ZPhotoHelper

+ (instancetype)defaultPhotoHelper {

    return [ZPhotoHelper new];
}

#pragma mark - life
- (instancetype)init {

    self = [super init];
    if (self) {
        
        ZCameraPhotoView *customView = [ZCameraPhotoView createCameraPhotoView];
        customView.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight(customView.frame));
        
        self.containerHelper = [ZActionSheetHelper actionSheetWithCustomView:customView];
        
        /**
         *  关联事件
         */
        [customView.cancelBtn addTarget:self action:@selector(toggleCancelBtn) forControlEvents:UIControlEventTouchUpInside];
        [customView.cameraBtn addTarget:self action:@selector(toggleCameraBtn) forControlEvents:UIControlEventTouchUpInside];
        [customView.photoBtn addTarget:self action:@selector(togglePhotoBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

#pragma mark - public
- (void)show {
    
    [_containerHelper show];
}

#pragma mark - private
- (void)dismiss {

    [_containerHelper dismiss];
}

- (void)toggleCancelBtn {

    [self dismiss];
}

- (void)toggleCameraBtn {

    if (self.CameraBlock) {
        self.CameraBlock();
    }
    [self dismiss];
}

- (void)togglePhotoBtn {

    if (self.PhotoBlock) {
        self.PhotoBlock();
    }
    
    [self dismiss];
}
@end
