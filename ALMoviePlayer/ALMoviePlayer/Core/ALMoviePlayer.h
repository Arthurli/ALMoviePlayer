//
//  ALMoviePlayer.h
//  ALMoviePlayer
//
//  Created by Arthur on 15/4/8.
//  Copyright (c) 2015年 Arthur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALMoviePlayerViewController.h"
#import "ALVideoRangeSlider.h"
#import "ALMovieToolBar.h"

@protocol ALMoviePlayerDelegate <NSObject>

@optional
- (void)didClickButtonWithType:(ALMovieToolBarButtonType)buttonType;

@end


@interface ALMoviePlayer : UIViewController

@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, weak) id<ALMoviePlayerDelegate> delegate;

@property (nonatomic, strong) ALMoviePlayerViewController *controller;
@property (nonatomic, strong) ALVideoRangeSlider *videoSlider;
@property (nonatomic, strong) ALMovieToolBar *toolBar;

@end
