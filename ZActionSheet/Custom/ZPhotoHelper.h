//
//  ZPhotoHelper.h
//  ZActionSheet
//
//  Created by zhuangjing on 16/8/5.
//  Copyright © 2016年 zhuangjing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZCameraHelper.h"
/**
 *  自定义（相机、相册）选择功能界面
 */

@interface ZPhotoHelper : NSObject

@property (nonatomic, copy) void (^CameraBlock)();
@property (nonatomic, copy) void (^PhotoBlock)();

+ (instancetype)defaultPhotoHelper;
- (void)show;

@end
