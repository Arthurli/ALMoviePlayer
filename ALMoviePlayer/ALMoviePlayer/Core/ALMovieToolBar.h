//
//  ALMovieToolBar.h
//  ALMoviePlayer
//
//  Created by Arthur on 15/4/8.
//  Copyright (c) 2015年 Arthur. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ALMovieToolBarButtonType) {
    ALMovieToolBarButtonTypeDelete,
    ALMovieToolBarButtonTypePause,
    ALMovieToolBarButtonTypePlay
};

@protocol ALMovieToolBarDelegate<NSObject>

- (void)didClickToolbarButtonWithType:(ALMovieToolBarButtonType)buttonType;

@end

@interface ALMovieToolBar : UIView

@property (nonatomic, weak) id<ALMovieToolBarDelegate>delegate;

- (void)setBackGroundView:(UIView *)backgroundView;
- (void)setCenterButtonType:(ALMovieToolBarButtonType)buttonType;
- (void)setLeftButtonType:(ALMovieToolBarButtonType)buttonType;
- (void)setRightButtonType:(ALMovieToolBarButtonType)buttonType;

- (void)setupAllButton;

@end
