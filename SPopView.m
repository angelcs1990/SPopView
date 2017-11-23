//
//  SPopView.m
//  GameGuess_CN
//
//  Created by cs on 17/5/8.
//  Copyright © 2017年 gaoqi. All rights reserved.
//

#import "SPopView.h"

@implementation SPopViewConainter

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = [[UIScreen mainScreen] bounds];
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.8];
    }
    
    return self;
}

@end



@interface SPopView ()<UIGestureRecognizerDelegate>

@property (nonatomic, weak) id<SPopViewDelegate> child;

@property (nonatomic, strong) UIView *keepAlive;

@property (nonatomic, weak) UIView *viewContainerRef;

@end

@implementation SPopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        if ([self conformsToProtocol:@protocol(SPopViewDelegate)]) {
            self.child = (id<SPopViewDelegate>)self;
        } else {
            NSAssert(0, @"请实现SPopViewDelegate协议");
        }
        
        self.tapClose = NO;
        //        self.hidden = YES;
    }
    
    return self;
}

#pragma mark - 公共方法(SPopView)
- (void)showInView:(UIView *)view
{
    if (self.keepAlive) {
        return;
    }
    self.keepAlive = view;
    
    [view addSubview:self];
    
    self.hidden = NO;
    
    
    if ([self.child respondsToSelector:@selector(popShowAnimation)]) {
        [self.child popShowAnimation];
    }
}

- (void)close
{
    if ([self.child respondsToSelector:@selector(popCloseAnimationCompletion:)]) {
        [self.child popCloseAnimationCompletion:^(BOOL finished) {
            [self setHidden:YES];
            [self removeFromSuperview];
            self.keepAlive = nil;
        }];
        
    } else {
        [self setHidden:YES];
        [self removeFromSuperview];
        self.keepAlive = nil;
    }
    
    
}

- (void)setNeedUpdateUI
{
    if (self.child && [self.child respondsToSelector:@selector(popSubView)]) {
        UIView *subView = [self.child popSubView];
        if (subView != nil) {
            if (self.viewContainerRef == nil || self.viewContainerRef != subView) {
                //                [self.rootViewController.view addSubview:subView];
                
                [self addSubview:subView];
                self.viewContainerRef = subView;
                
                if ([self.child respondsToSelector:@selector(popAfterInitView:)]) {
                    [self.child popAfterInitView:self];
                }
                
                
                [self SPopView_addTapGesture];
            }
        }
    }
}

- (CGFloat)titleHeightWithFont:(UIFont *)font
{
    int width = self.frame.size.width;
    
    NSDictionary *dict = @{NSFontAttributeName:font};
    CGSize msgSize = [@"A" boundingRectWithSize:CGSizeMake(width, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
    
    return msgSize.height;
}

#pragma mark - 私有方法(SPopView)
- (void)SPopView_addTapGesture
{
    BOOL needTapClose = YES;
    if (self.child && [self.child respondsToSelector:@selector(popNeedTapClose)]) {
        needTapClose = [self.child popNeedTapClose];
    }
    
    if (needTapClose) {
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SPopView_handleSingleTap:)];
        [self addGestureRecognizer:singleTap];
        singleTap.delegate = self;
    }
}

#pragma mark - 事件方法(SPopView)
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if(CGRectContainsPoint(self.viewContainerRef.frame, [touch locationInView:self]))
    {
        return NO;
    }
    
    return YES;
}

- (void)SPopView_handleSingleTap:(UITapGestureRecognizer *)sender
{
    if (self.tapClose) {
        [self close];
    }
    
}

#pragma mark - 
- (BOOL)isShowing
{
    return !(self.keepAlive == nil);
}
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    [self.rootViewController.view setNeedsLayout];
//    [self.rootViewController.view layoutIfNeeded];
//}



@end

