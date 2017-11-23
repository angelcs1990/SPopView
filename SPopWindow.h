//
//  SPopWindow.h
//  STabViewDemo
//
//  Created by cs on 16/10/31.
//  Copyright © 2016年 cs. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface SPopWindowConainter : UIWindow

@end






typedef void(^FinishAddBlock)();

@class SPopWindow;

@protocol SPopWindowDelegate <NSObject>

@required
- (UIView *)popSubView;


@optional

- (BOOL)popNeedTapClose;

- (void)popAfterInitView:(UIView *)fatherView;

/**
 *  显示动画效果
 */
- (void)popShowAnimation;

/**
 *  关闭动画效果，
 */
- (void)popCloseAnimationCompletion:(void(^)(BOOL))completion;

@end




@interface SPopWindow : SPopWindowConainter

- (void)layoutSubviews NS_UNAVAILABLE;

/**
 *  是否响应点击其他区域关闭
 */
@property (nonatomic) BOOL tapClose;

/**
 *  显示界面,继承请调用[super show]
 */
- (void)show;

/**
 *  关闭显示界面，继承请调用[super close]
 */
- (void)close;

/**
 *  更新界面显示
 */
- (void)setNeedUpdateUI;
/**
 *  文字高度计算；参考‘A’
 */
- (CGFloat)titleHeightWithFont:(UIFont *)font;

@end

