//
//  ZActionSheetHelper.m
//  ZActionSheet
//
//  Created by zhuangjing on 16/8/4.
//  Copyright © 2016年 zhuangjing. All rights reserved.
//

#import "ZActionSheetHelper.h"

#define zKeyWindow                          [UIApplication sharedApplication].keyWindow

#define zScreenBounds                       [UIScreen mainScreen].bounds
#define zScreenWidth                        [UIScreen mainScreen].bounds.size.width
#define zScreenHeight                       [UIScreen mainScreen].bounds.size.height

#define zCellHeight                         44.
#define zPadding                            15.

#define Color_Contarner_z                   [UIColor colorWithRed:240/255. green:240/255. blue:240/255. alpha:1]
#define Color_Cancel_Title_Normal_z         [UIColor colorWithRed:128/255. green:128/255. blue:128/255. alpha:1]
#define Color_Cancel_Title_Heghlighted_z    [UIColor colorWithRed:59/255. green:189/255. blue:121/255. alpha:1]

#define Font_Title_z                        [UIFont systemFontOfSize:13]
#define Font_Button_z                       [UIFont systemFontOfSize:15]

#define ItemTagBase                         100

@interface ZActionSheetHelper () {

    UITapGestureRecognizer *tapDismiss;
    UIView *_topView;
}

@property (nonatomic) UIView *bgView;
@property (nonatomic) UIView *containerView;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIButton *dismissBtn;

@end


@implementation ZActionSheetHelper

#pragma mark - life
- (instancetype)init {

    self = [super init];
    if (self) {
        
        if (!_bgView) {
            self.bgView = [[UIView alloc] initWithFrame:zScreenBounds];
            _bgView.backgroundColor = [UIColor clearColor];
            _bgView.hidden = YES;
            
            tapDismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        }
    }
    return self;
}

#pragma mark - 初始化方式
+ (instancetype)actionSheetWithItems:(NSArray <NSString *> *)items title:(NSString *)title {
    
    ZActionSheetHelper *helper = [ZActionSheetHelper new];
    
    NSAssert(items.count != 0, @"传入的数组不能为空!");
    
    CGFloat titleH = 0.;
    if (title.length != 0) {
        titleH = [ZActionSheetHelper calculateHeightWithContent:title font:Font_Title_z];
    }
    
    NSInteger paddingCount = items.count;
    
    if (titleH > 0) {
        paddingCount += 3;
    }
    else {
        
        paddingCount += 2;
    }
    
    CGFloat containerH = paddingCount * zPadding + (items.count + 1) * zCellHeight + titleH;
    
    //容器
    if (!helper.containerView) {
        
        helper.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, zScreenHeight, zScreenWidth, containerH)];;
        [helper.bgView addSubview:helper.containerView];
        helper.containerView.backgroundColor = Color_Contarner_z;
    }
    
    //标题
    if (titleH > 0 && !helper.titleLabel) {
        
        helper.titleLabel = [UILabel new];
        [helper.containerView addSubview:helper.titleLabel];
        [helper setTitleDefaultCategoriesWithTitle:title height:titleH];
    }
    
    CGFloat Top_Item = zPadding * 2 + titleH;
    CGFloat buttonW = CGRectGetWidth(helper.bgView.frame) - zPadding * 2;
    
    for (NSInteger i = 0; i < items.count; i++) {
        
        NSString *temp = items[i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(zPadding, Top_Item, buttonW, zCellHeight);
        [helper.containerView addSubview:button];
        button.tag = ItemTagBase + i;
        [button addTarget:helper action:@selector(toggleItemsBtn:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:temp forState:UIControlStateNormal];
        
        [helper setDefaultCategoriesWithButton:button];
        
        Top_Item += CGRectGetHeight(button.frame) + zPadding;
    }
    
    //取消
    if (!helper.dismissBtn) {
        
        helper.dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        helper.dismissBtn.frame = CGRectMake(zPadding, Top_Item, buttonW, zCellHeight);
        [helper.containerView addSubview:helper.dismissBtn];
        [helper.dismissBtn addTarget:helper action:@selector(toggleDissmissBtn:) forControlEvents:UIControlEventTouchUpInside];
        [helper.dismissBtn setTitle:@"取消" forState:UIControlStateNormal];
        
        [helper setDefaultCategoriesWithButton:helper.dismissBtn];
    }
    
    helper.forbidOutsideDismiss = NO;
    
    return helper;
}

#pragma mark - actions
- (void)toggleItemsBtn:(UIButton *)btn {

    if (self.selectActionSheetBlock) {
        self.selectActionSheetBlock(btn.tag - ItemTagBase);
    }
    
    [self dismiss];
}

- (void)toggleDissmissBtn:(UIButton *)btn {
    
    [self dismiss];
}


#pragma mark - public
- (void)show {
    
    if (!self.bgView.superview) {
        [zKeyWindow addSubview:self.bgView];
    }
    
    //animate to show
    CGPoint endCenter = self.containerView.center;
    endCenter.y -= CGRectGetHeight(self.containerView.frame);
    
    [UIView animateWithDuration:0.25 delay:0. options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bgView.hidden = NO;
        self.bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        self.containerView.center = endCenter;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss {

    //animate to dismiss
    CGPoint endCenter = self.containerView.center;
    endCenter.y += CGRectGetHeight(self.containerView.frame);
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.containerView.center = endCenter;
        self.bgView.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        
        if (finished) {

            [self.bgView removeFromSuperview];
        }
    }];
}

- (void)setForbidOutsideDismiss:(BOOL)forbidOutsideDismiss {

    _forbidOutsideDismiss = forbidOutsideDismiss;
    
    if (_forbidOutsideDismiss) {
        [_topView removeGestureRecognizer:tapDismiss];
    }
    else {
    
        if (!tapDismiss.view) {
            
            if (!_topView) {
                _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bgView.frame), CGRectGetHeight(self.bgView.frame) - CGRectGetHeight(self.containerView.frame))];
                _topView.backgroundColor = [UIColor clearColor];
                [_bgView addSubview:_topView];
            }
            
            [_topView addGestureRecognizer:tapDismiss];
        }
    }
}

/**
 *  自定义弹出视图
 *
 *  @param customView 自定义UI
 *  @param title      标题
 *  @param cancel     是否使用默认取消
 *
 *  @return 实例
 */
+ (instancetype)actionSheetWithCustomView:(UIView *)customView title:(NSString *)title cancel:(BOOL)cancel {

    ZActionSheetHelper *helper = [ZActionSheetHelper new];
    
    NSAssert(customView != nil, @"自定义视图不能缺省！");
    
    //容器
    if (!helper.containerView) {
        helper.containerView = [UIView new];
        [helper.bgView addSubview:helper.containerView];
    }
    
    //标题
    CGFloat titleH = 0.;
    if (title.length != 0) {
        titleH = [ZActionSheetHelper calculateHeightWithContent:title font:Font_Title_z];
        
        if (!helper.titleLabel) {
            helper.titleLabel = [UILabel new];
            [helper.containerView addSubview:helper.titleLabel];
        }
    }

    
    CGFloat cancelH = 0.;
    
    //取消
    if (cancel) {
        
        cancelH = zCellHeight;
        
        if (!helper.dismissBtn) {
            helper.dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [helper setDefaultCategoriesWithButton:helper.dismissBtn];
            [helper.containerView addSubview:helper.dismissBtn];
            [helper.dismissBtn addTarget:helper action:@selector(toggleDissmissBtn:) forControlEvents:UIControlEventTouchUpInside];
            [helper.dismissBtn setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
    
    CGFloat fRate = CGRectGetWidth(customView.frame)/zScreenWidth;

    //等比缩放
    customView.frame = CGRectMake(0, 0, zScreenWidth, CGRectGetHeight(customView.frame) * fRate);
    
    
    CGFloat containerH = 0.;
    if (titleH > 0) {
        
        [helper setTitleDefaultCategoriesWithTitle:title height:titleH];
        
        customView.frame = CGRectMake(0, zPadding * 2 + titleH, CGRectGetWidth(customView.frame), CGRectGetHeight(customView.frame));
        
        if (cancelH > 0) {
            
            containerH = zPadding * 4 + CGRectGetHeight(customView.frame) + titleH + zCellHeight;
            
            helper.containerView.frame = CGRectMake(0, zScreenHeight, zScreenWidth, containerH);
        }
        else {
        
            containerH = zPadding * 2 + CGRectGetHeight(customView.frame) + titleH;
            
            helper.containerView.frame = CGRectMake(0, zScreenHeight, zScreenWidth, containerH);
        }
        
    }
    else {
    
        if (cancelH > 0) {
            
            helper.dismissBtn.frame = CGRectMake(zPadding, CGRectGetMaxY(customView.frame) + zPadding, zScreenWidth - 2 * zPadding, zCellHeight);
            
            containerH = zPadding * 2 + CGRectGetHeight(customView.frame) + zCellHeight;
            
            helper.containerView.frame = CGRectMake(0, zScreenHeight, zScreenWidth, containerH);
        }
        else {
            
            containerH = CGRectGetHeight(customView.frame);
            
            helper.containerView.frame = CGRectMake(0, zScreenHeight, zScreenWidth, containerH);
        }
    }
    
    [helper.containerView addSubview:customView];
    
    helper.forbidOutsideDismiss = NO;
    return helper;
}

+ (instancetype)actionSheetWithCustomView:(UIView *)customView title:(NSString *)title {

    ZActionSheetHelper *helper = [ZActionSheetHelper actionSheetWithCustomView:customView title:title cancel:NO];
    
    return helper;
}

+ (instancetype)actionSheetWithCustomView:(UIView *)customView {

    ZActionSheetHelper *helper = [ZActionSheetHelper actionSheetWithCustomView:customView title:nil cancel:NO];
    
    return helper;
}


#pragma mark - private
+ (CGFloat)calculateHeightWithContent:(NSString *)content font:(UIFont *)font {

    NSDictionary *attributes = @{ NSFontAttributeName : font };
    
    return  [content boundingRectWithSize:CGSizeMake(1000, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
}

- (void)setDefaultCategoriesWithButton:(UIButton *)button {

    button.backgroundColor = [UIColor whiteColor];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 2.;
    button.titleLabel.font = Font_Button_z;
    
    [button setTitleColor:Color_Cancel_Title_Normal_z forState:UIControlStateNormal];
    [button setTitleColor:Color_Cancel_Title_Heghlighted_z forState:UIControlStateHighlighted];
}

- (void)setTitleDefaultCategoriesWithTitle:(NSString *)title height:(CGFloat)titleH {

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(self.containerView).offset(zPadding);
        make.right.equalTo(self.containerView).offset(-zPadding);
        make.height.mas_equalTo(titleH);
    }];
    
    self.titleLabel.font = Font_Title_z;
    self.titleLabel.textColor = Color_Cancel_Title_Normal_z;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = title;
}

@end
