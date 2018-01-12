//
//  SPopView.h
//  GameGuess_CN
//
//  Created by cs on 17/5/8.
//  Copyright © 2017年 gaoqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPopViewConainter : UIView

@end

@class SPopView;


@protocol SPopViewDelegate <NSObject>

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




@interface SPopView : SPopViewConainter

@property (nonatomic, getter=isShowing, readonly) BOOL show;

/**
 *  是否响应点击其他区域关闭
 */
@property (nonatomic) BOOL tapClose;

/**
 *  显示界面,继承请调用[super show]
 */
- (void)showInView:(UIView *)view;

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
