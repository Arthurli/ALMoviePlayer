//
//  ALProgressView.m
//  ALMoviePlayer
//
//  Created by Arthur on 15/4/8.
//  Copyright (c) 2015年 Andrei Solovjev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import "ALSliderLeft.h"
#import "ALSliderRight.h"
#import "ALProgressView.h"


@protocol ALVideoRangeSliderDelegate;

@interface ALVideoRangeSlider : UIView

@property (nonatomic, weak) id <ALVideoRangeSliderDelegate> delegate;

@property (nonatomic) float leftPosition;
@property (nonatomic) float rightPosition;
@property (nonatomic) float currentTime;

@property (nonatomic, assign) NSInteger maxGap;
@property (nonatomic, assign) NSInteger minGap;

@property (nonatomic, strong) UIColor *rangeSliderDefaultColor;
@property (nonatomic, strong) UIColor *rangeSliderHightlightColor;
@property (nonatomic, strong) UIColor *progressviewDefaultColor;
@property (nonatomic, strong) UIColor *progressviewHightlightColor;

@property (nonatomic, assign) BOOL edit;
@property (nonatomic, assign) BOOL hideRangeSlider;

- (id)initWithFrame:(CGRect)frame videoUrl:(NSURL *)videoUrl;
- (void)setBeganTime:(float)beganTime;
- (void)setEndTime:(float)endTime;
- (void)setFrameWidth:(float)width;
- (void)setNowCurrentTime:(float)currentTime;
- (void)setupPosition;

@end


@protocol ALVideoRangeSliderDelegate <NSObject>

@optional

- (void)currentTimeArriveStartOrEnd:(BOOL)isEnd;

- (void)videoRange:(ALVideoRangeSlider *)videoRange didChangeLeftPosition:(float)leftPosition rightPosition:(float)rightPosition;

- (void)videoRange:(ALVideoRangeSlider *)videoRange didGestureStateEndedLeftPosition:(float)leftPosition rightPosition:(float)rightPosition;

- (void)videoRange:(ALVideoRangeSlider *)videoRange didChangeCurrentTime:(float)currentTime;

@end




