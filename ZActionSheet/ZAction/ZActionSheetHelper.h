//
//  ZActionSheetHelper.h
//  ZActionSheet
//
//  Created by zhuangjing on 16/8/4.
//  Copyright © 2016年 zhuangjing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Masonry.h>

/**
 *  弹出视图通用容器
 */
@interface ZActionSheetHelper : NSObject

@property (nonatomic, assign) BOOL forbidOutsideDismiss;
@property (nonatomic, copy) void (^selectActionSheetBlock)(NSInteger index);

+ (instancetype)actionSheetWithItems:(NSArray <NSString *> *)items title:(NSString *)title;
- (void)show;
- (void)dismiss;

//自定义界面
+ (instancetype)actionSheetWithCustomView:(UIView *)customView;
+ (instancetype)actionSheetWithCustomView:(UIView *)customView title:(NSString *)title;
+ (instancetype)actionSheetWithCustomView:(UIView *)customView title:(NSString *)title cancel:(BOOL)cancel;

@end
