//
//  ZCameraHelper.h
//  Utilities
//
//  Created by apple on 16/3/28.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  访问系统相册，照相机
 *
 *  @param target  目标响应者
 *  @param canEdit 编辑权限
 *
 *  @return 设备权限状态值
 */
BOOL	PresentPhotoCamera		(id target, BOOL canEdit);
BOOL	PresentVideoCamera		(id target, BOOL canEdit);
BOOL	PresentMultiCamera		(id target, BOOL canEdit);

BOOL	PresentPhotoLibrary		(id target, BOOL canEdit);
BOOL	PresentVideoLibrary		(id target, BOOL canEdit);