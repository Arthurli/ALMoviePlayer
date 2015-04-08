//
//  ALMovieToolBar.m
//  ALMoviePlayer
//
//  Created by Arthur on 15/4/8.
//  Copyright (c) 2015年 Arthur. All rights reserved.
//

#import "ALMovieToolBar.h"

@interface ALMovieToolBar()

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *centerButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIView *bgView;
@end

@implementation ALMovieToolBar

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

- (void)setBackGroundView:(UIView *)backgroundView
{
    if (_bgView) {
        [_bgView removeFromSuperview];
    }
    
    _bgView = backgroundView;
    
    if (_bgView) {
        [self insertSubview:_bgView atIndex:0];
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setupAllButton];
}

- (void)setCenterButtonType:(ALMovieToolBarButtonType)buttonType
{
    [self cleanButton:_centerButton];
    _centerButton = [self getButtonWithType:buttonType];
    [self setOrigin:CGPointMake(self.frame.size.width/2 - _centerButton.frame.size.width/2, 10) view:_centerButton];
    [self addSubview:_centerButton];
}

- (void)setLeftButtonType:(ALMovieToolBarButtonType)buttonType
{
    [self cleanButton:_leftButton];
    _leftButton = [self getButtonWithType:buttonType];
    [self setOrigin:CGPointMake(20, 10) view:_leftButton];
    [self addSubview:_leftButton];
}

- (void)setRightButtonType:(ALMovieToolBarButtonType)buttonType
{
    [self cleanButton:_rightButton];
    _rightButton = [self getButtonWithType:buttonType];
    [self setOrigin:CGPointMake(self.frame.size.width - 20 - _rightButton.frame.size.width, 10) view:_rightButton];
     [self addSubview:_rightButton];
}

- (void)setupAllButton
{
    [self setOrigin:CGPointMake(20, 10) view:_leftButton];
    [self setOrigin:CGPointMake(self.frame.size.width/2 - _centerButton.frame.size.width/2, 10) view:_centerButton];
    [self setOrigin:CGPointMake(self.frame.size.width - 20 - _rightButton.frame.size.width, 10) view:_rightButton];
}

- (void)setOrigin:(CGPoint)point view:(UIView *)view
{
    if (view) {
        CGRect frame = view.frame;
        frame.origin = point;
        view.frame = frame;
    }
}

- (void)cleanButton:(UIButton *)btn
{
    if (btn) {
        [btn removeFromSuperview];
        btn = nil;
    }
}

- (UIButton *)getButtonWithType:(ALMovieToolBarButtonType)buttonType
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 25, 25);
    button.tag = buttonType;
    [button addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
    switch (buttonType) {
            case ALMovieToolBarButtonTypeDelete:
            button.backgroundColor = [UIColor redColor];
            break;
            case ALMovieToolBarButtonTypePlay:
            button.backgroundColor = [UIColor yellowColor];
            break;
            case ALMovieToolBarButtonTypePause:
            button.backgroundColor = [UIColor greenColor];
            break;
            default:
            break;
    }
    
    return button;
}

- (void)didClickButton:(UIButton *)btn
{
    if ([_delegate respondsToSelector:@selector(didClickToolbarButtonWithType:)]) {
        [_delegate didClickToolbarButtonWithType:btn.tag];
    }
}

@end

