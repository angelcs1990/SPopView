//
//  SPopWindow.m
//  STabViewDemo
//
//  Created by cs on 16/10/31.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "SPopWindow.h"


#pragma mark - _SPopWindowController

@interface _SPopWindowController : UIViewController

@end

@implementation _SPopWindowController

- (UIStatusBarStyle)preferredStatusBarStyle {   //设置样式
    
    return UIStatusBarStyleLightContent;
    
}

@end



#pragma mark - SPopWindowConainter
@implementation SPopWindowConainter

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.windowLevel = UIWindowLevelNormal + 50;
        self.frame = [[UIScreen mainScreen] bounds];
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.8];
    }
    
    return self;
}

@end




#pragma mark - SPopWindow
@interface SPopWindow ()<UIGestureRecognizerDelegate>

@property (nonatomic, weak) id<SPopWindowDelegate> child;

@property (nonatomic, strong) UIWindow *keepAlive;

@property (nonatomic, weak) UIView *viewContainerRef;

@end

@implementation SPopWindow

#pragma mark - 生命周期(SPopWindow)
//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        
//        if ([self conformsToProtocol:@protocol(SPopWindowDelegate)]) {
//            self.child = (id<SPopWindowDelegate>)self;
//        } else {
//            NSAssert(0, @"请实现SPopWindowDelegate协议");
//        }
//
//        _SPopWindowController *vc = [_SPopWindowController new];
//        self.rootViewController = vc;
//        self.tapClose = NO;
//        
////        [self popViewSetupUI];
//    }
//    
//    return self;
//}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        if ([self conformsToProtocol:@protocol(SPopWindowDelegate)]) {
            self.child = (id<SPopWindowDelegate>)self;
        } else {
            NSAssert(0, @"请实现SPopWindowDelegate协议");
        }
        
        _SPopWindowController *vc = [_SPopWindowController new];
        self.rootViewController = vc;
        self.tapClose = NO;
    }
    
    return self;
}

#pragma mark - 公共方法(SPopWindow)
- (void)show
{
    if (self.keepAlive) {
        return;
    }
    self.keepAlive = self;
    [self makeKeyAndVisible];
    
    if ([self.child respondsToSelector:@selector(popShowAnimation)]) {
        [self.child popShowAnimation];
    }
}

- (void)close
{
    if ([self.child respondsToSelector:@selector(popCloseAnimationCompletion:)]) {
        [self.child popCloseAnimationCompletion:^(BOOL finished) {
            [self setHidden:YES];
            self.keepAlive = nil;
        }];
        
    } else {
        [self setHidden:YES];
        self.keepAlive = nil;
    }
    
    
}

- (void)setNeedUpdateUI
{
    if (self.child && [self.child respondsToSelector:@selector(popSubView)]) {
        UIView *subView = [self.child popSubView];
        if (subView != nil) {
            if (self.viewContainerRef == nil || self.viewContainerRef != subView) {
                [self.rootViewController.view addSubview:subView];
                
                self.viewContainerRef = subView;
                
                if ([self.child respondsToSelector:@selector(popAfterInitView:)]) {
                    [self.child popAfterInitView:self.rootViewController.view];
                }
                
                
                [self SPopWindow_addTapGesture];
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

#pragma mark - 私有方法(SPopWindow)
- (void)SPopWindow_addTapGesture
{
    BOOL needTapClose = YES;
    if (self.child && [self.child respondsToSelector:@selector(popNeedTapClose)]) {
        needTapClose = [self.child popNeedTapClose];
    }
    
    if (needTapClose) {
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SPopWindow_handleSingleTap:)];
        [self addGestureRecognizer:singleTap];
        singleTap.delegate = self;
    }
}

#pragma mark - 事件方法(SPopWindow)
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if(CGRectContainsPoint(self.viewContainerRef.frame, [touch locationInView:self]))
    {
        return NO;
    }
    
    return YES;
}

- (void)SPopWindow_handleSingleTap:(UITapGestureRecognizer *)sender
{
    if (self.tapClose) {
        [self close];
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.rootViewController.view setNeedsLayout];
    [self.rootViewController.view layoutIfNeeded];
}

@end





