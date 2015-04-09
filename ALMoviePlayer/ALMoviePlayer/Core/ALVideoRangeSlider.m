//
//  ALProgressView.m
//  ALMoviePlayer
//
//  Created by Arthur on 15/4/8.
//  Copyright (c) 2015年 Andrei Solovjev. All rights reserved.
//

#import "ALVideoRangeSlider.h"

@interface ALVideoRangeSlider ()

@property (nonatomic, strong) AVAssetImageGenerator *imageGenerator;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) NSURL *videoUrl;
@property (nonatomic, strong) ALSliderLeft *leftThumb;
@property (nonatomic, strong) ALSliderRight *rightThumb;
@property (nonatomic, strong) ALProgressView *progressThumb;

@property (nonatomic) CGFloat frame_width;
@property (nonatomic) CGFloat picWidth;
@property (nonatomic) Float64 durationSeconds;

@end

@implementation ALVideoRangeSlider


#define SLIDER_BORDERS_SIZE 6.0f
#define BG_VIEW_BORDERS_SIZE 3.0f
#define Default_Pic_Width 44.0
#define Default_thumbWidth_Width 12.0

- (id)initWithFrame:(CGRect)frame videoUrl:(NSURL *)videoUrl{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _frame_width = frame.size.width;
        _picWidth = Default_Pic_Width;
        
        int thumbWidth = Default_thumbWidth_Width;
        
        _bgView = [[UIControl alloc] initWithFrame:CGRectMake(thumbWidth-BG_VIEW_BORDERS_SIZE, 0, frame.size.width-(thumbWidth*2)+BG_VIEW_BORDERS_SIZE*2, frame.size.height)];
        _bgView.layer.borderColor = [UIColor blackColor].CGColor;
        _bgView.layer.borderWidth = BG_VIEW_BORDERS_SIZE;
        _bgView.layer.masksToBounds = YES;
        [self addSubview:_bgView];
        
        _videoUrl = videoUrl;
        
        
        _topBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, SLIDER_BORDERS_SIZE)];
        _topBorder.backgroundColor = [UIColor colorWithRed: 0.996 green: 0.951 blue: 0.502 alpha: 1];
        [self addSubview:_topBorder];
        
        _bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-SLIDER_BORDERS_SIZE, frame.size.width, SLIDER_BORDERS_SIZE)];
        _bottomBorder.backgroundColor = [UIColor colorWithRed: 0.992 green: 0.902 blue: 0.004 alpha: 1];
        [self addSubview:_bottomBorder];
        
        
        _leftThumb = [[ALSliderLeft alloc] initWithFrame:CGRectMake(0, 0, thumbWidth, frame.size.height)];
        _leftThumb.contentMode = UIViewContentModeLeft;
        _leftThumb.userInteractionEnabled = YES;
        _leftThumb.clipsToBounds = YES;
        _leftThumb.backgroundColor = [UIColor clearColor];
        _leftThumb.layer.borderWidth = 0;
        [self addSubview:_leftThumb];
        
        
        _rightThumb = [[ALSliderRight alloc] initWithFrame:CGRectMake(0, 0, thumbWidth, frame.size.height)];
        
        _rightThumb.contentMode = UIViewContentModeRight;
        _rightThumb.userInteractionEnabled = YES;
        _rightThumb.clipsToBounds = YES;
        _rightThumb.backgroundColor = [UIColor clearColor];
        [self addSubview:_rightThumb];
        
        _rightPosition = frame.size.width;
        _leftPosition = 0;
        _currentTime = 0;
        
        _centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _centerView.backgroundColor = [UIColor clearColor];
        [self addSubview:_centerView];
        
        _progressThumb = [[ALProgressView alloc] initWithFrame:CGRectMake(0, 0, 6, frame.size.height)];
        _progressThumb.contentMode = UIViewContentModeRight;
        _progressThumb.userInteractionEnabled = YES;
        _progressThumb.clipsToBounds = YES;
        [self addSubview:_progressThumb];
        
        self.edit = NO;
        [self updateGestureRecognizer];
        
        [self getMovieFrame];
    }
    
    return self;
}

- (void)setHideRangeSlider:(BOOL)hideRangeSlider
{
    _hideRangeSlider = hideRangeSlider;
    _leftThumb.hidden = hideRangeSlider;
    _rightThumb.hidden = hideRangeSlider;
    _centerView.hidden = hideRangeSlider;
    _topBorder.hidden = hideRangeSlider;
    _bottomBorder.hidden = hideRangeSlider;
}

- (void)setFrame:(CGRect)frame
{
    float oldBegan = self.leftPosition;
    float oldEnd = self.rightPosition;
    float oldCurrent = self.currentTime;
    
    [super setFrame:frame];
    _frame_width = frame.size.width;
    int thumbWidth = Default_thumbWidth_Width;
    _bgView.frame = CGRectMake(thumbWidth-BG_VIEW_BORDERS_SIZE, 0, frame.size.width-(thumbWidth*2)+BG_VIEW_BORDERS_SIZE*2, frame.size.height);
    _topBorder.frame = CGRectMake(0, 0, frame.size.width, SLIDER_BORDERS_SIZE);
    _bottomBorder.frame = CGRectMake(0, frame.size.height-SLIDER_BORDERS_SIZE, frame.size.width, SLIDER_BORDERS_SIZE);
    [self getMovieFrame];
    
    [self setBeganTime:oldBegan];
    [self setEndTime:oldEnd];
    [self setNowCurrentTime:oldCurrent];

}


- (void)setEdit:(BOOL)edit
{
    if (_edit != edit) {
        _edit = edit;
        _progressThumb.highlight = edit;
        _leftThumb.highlight = edit;
        _rightThumb.highlight = edit;
        [self updateGestureRecognizer];
    }
}

- (void)updateGestureRecognizer
{
    [self removeAllGestureRecognizer:@[_centerView, _leftThumb, _rightThumb, _progressThumb]];
    
    if (_edit) {
        
        UIPanGestureRecognizer *leftPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftPan:)];
        [_leftThumb addGestureRecognizer:leftPan];
        
        UIPanGestureRecognizer *rightPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightPan:)];
        [_rightThumb addGestureRecognizer:rightPan];
        
        UIPanGestureRecognizer *centerPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleCenterPan:)];
        [_centerView addGestureRecognizer:centerPan];
        
        _progressThumb.hidden = YES;
        
    } else {
        
        UILongPressGestureRecognizer *leftPan = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPan:)];
        leftPan.minimumPressDuration = 2;
        [_leftThumb addGestureRecognizer:leftPan];
        
        UILongPressGestureRecognizer *rightPan = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPan:)];
        rightPan.minimumPressDuration = 2;
        [_rightThumb addGestureRecognizer:rightPan];
        
        UIPanGestureRecognizer *progressPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleProgressPan:)];
        [_progressThumb addGestureRecognizer:progressPan];
        
        _progressThumb.hidden = NO;
    }

}

- (void)removeAllGestureRecognizer:(NSArray *)views
{
    for (UIView *view in views) {
        NSArray * gestureRecognizers = [view.gestureRecognizers copy];
        
        for (UIGestureRecognizer *gestureRecognizer in gestureRecognizers) {
            [view removeGestureRecognizer:gestureRecognizer];
        }
    }
}

-(void)setMaxGap:(NSInteger)maxGap{
    _leftPosition = 0;
    _rightPosition = _frame_width*maxGap/_durationSeconds;
    _maxGap = maxGap;
}

-(void)setMinGap:(NSInteger)minGap{
    _leftPosition = 0;
    _rightPosition = _frame_width*minGap/_durationSeconds;
    _minGap = minGap;
}


- (void)delegateNotification
{
    if ([_delegate respondsToSelector:@selector(videoRange:didChangeLeftPosition:rightPosition:)]){
        [_delegate videoRange:self didChangeLeftPosition:self.leftPosition rightPosition:self.rightPosition];
    }
    
    if (_currentTime < _leftPosition || _currentTime > _rightPosition) {
        if (_currentTime < _leftPosition) {
            _currentTime = _leftPosition;
        } else if (_currentTime > _rightPosition) {
            _currentTime = _rightPosition;
        }
        
        [self delegateCurrentChange];
    }
    
}


- (void)delegateCurrentChange
{
    if ([_delegate respondsToSelector:@selector(videoRange:didChangeCurrentTime:)]){
        [_delegate videoRange:self didChangeCurrentTime:self.currentTime];
    }
}

- (void)delegateEndPanGesture
{
    if ([_delegate respondsToSelector:@selector(videoRange:didGestureStateEndedLeftPosition:rightPosition:)]){
        [_delegate videoRange:self didGestureStateEndedLeftPosition:self.leftPosition rightPosition:self.rightPosition];
        
    }
}


#pragma mark - Gestures

- (void)handleProgressPan:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        
        CGFloat inset = _leftThumb.frame.size.width;
        
        CGPoint translation = [gesture translationInView:self];
        
        _currentTime += translation.x *_frame_width /(_frame_width-4*inset-_progressThumb.frame.size.width);
        if (_currentTime < _leftPosition) {
            _currentTime = _leftPosition;
        } else if (_currentTime > _rightPosition) {
            _currentTime = _rightPosition;
        }
        
        [gesture setTranslation:CGPointZero inView:self];
        
        [self setNeedsLayout];
        
        [self delegateCurrentChange];
    }
}

- (void)handleLeftPan:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [gesture translationInView:self];
        
        _leftPosition += translation.x;
        if (_leftPosition < 0) {
            _leftPosition = 0;
        }
        
        if (
            (_rightPosition-_leftPosition <= _leftThumb.frame.size.width+_rightThumb.frame.size.width) ||
            ((self.maxGap > 0) && (self.rightPosition-self.leftPosition > self.maxGap)) ||
            ((self.minGap > 0) && (self.rightPosition-self.leftPosition < self.minGap))
            ){
            _leftPosition -= translation.x;
        }
        
        [gesture setTranslation:CGPointZero inView:self];
        
        [self setNeedsLayout];
        
        [self delegateNotification];
        
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded){
        [self delegateEndPanGesture];
    }
}


- (void)handleRightPan:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        
        
        CGPoint translation = [gesture translationInView:self];
        _rightPosition += translation.x;
        if (_rightPosition < 0) {
            _rightPosition = 0;
        }
        
        if (_rightPosition > _frame_width){
            _rightPosition = _frame_width;
        }
        
        if (_rightPosition-_leftPosition <= 0){
            _rightPosition -= translation.x;
        }
        
        if ((_rightPosition-_leftPosition <= _leftThumb.frame.size.width+_rightThumb.frame.size.width) ||
            ((self.maxGap > 0) && (self.rightPosition-self.leftPosition > self.maxGap)) ||
            ((self.minGap > 0) && (self.rightPosition-self.leftPosition < self.minGap))){
            _rightPosition -= translation.x;
        }
        
        
        [gesture setTranslation:CGPointZero inView:self];
        
        [self setNeedsLayout];
        
        [self delegateNotification];
        
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded){
        [self delegateEndPanGesture];
    }
}


- (void)handleCenterPan:(UIPanGestureRecognizer *)gesture
{
    
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [gesture translationInView:self];
        
        _leftPosition += translation.x;
        _rightPosition += translation.x;
        
        if (_rightPosition > _frame_width || _leftPosition < 0){
            _leftPosition -= translation.x;
            _rightPosition -= translation.x;
        }
        
        
        [gesture setTranslation:CGPointZero inView:self];
        
        [self setNeedsLayout];
        
        [self delegateNotification];
        
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded){
        [self delegateEndPanGesture];
    }
    
}

- (void)handleLongPan:(UIPanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.edit = YES;
    }
}


- (void)layoutSubviews
{
    [self layoutWithAnimation:NO];
}

- (void)layoutWithAnimation:(BOOL)animation
{
    void (^block)() = ^(){
        CGFloat inset = _leftThumb.frame.size.width / 2;
        
        _progressThumb.center = CGPointMake(inset*2 +_progressThumb.frame.size.width/2 + _currentTime /_frame_width*(_frame_width-4*inset-_progressThumb.frame.size.width), _progressThumb.frame.size.height/2);
        
        _leftThumb.center = CGPointMake(_leftPosition+inset, _leftThumb.frame.size.height/2);
        
        _rightThumb.center = CGPointMake(_rightPosition-inset, _rightThumb.frame.size.height/2);
        
        _topBorder.frame = CGRectMake(_leftThumb.frame.origin.x + _leftThumb.frame.size.width, 0, _rightThumb.frame.origin.x - _leftThumb.frame.origin.x - _leftThumb.frame.size.width/2, SLIDER_BORDERS_SIZE);
        
        _bottomBorder.frame = CGRectMake(_leftThumb.frame.origin.x + _leftThumb.frame.size.width, _bgView.frame.size.height-SLIDER_BORDERS_SIZE, _rightThumb.frame.origin.x - _leftThumb.frame.origin.x - _leftThumb.frame.size.width/2, SLIDER_BORDERS_SIZE);
        
        
        _centerView.frame = CGRectMake(_leftThumb.frame.origin.x + _leftThumb.frame.size.width, _centerView.frame.origin.y, _rightThumb.frame.origin.x - _leftThumb.frame.origin.x - _leftThumb.frame.size.width, _centerView.frame.size.height);
    
    };
    
    if (animation) {
        [UIView animateWithDuration:.4 animations:^{
            block();
        }];
    } else {
        block();
    }
    
}


#pragma mark - Video

-(void)getMovieFrame{
    
    AVAsset *myAsset = [[AVURLAsset alloc] initWithURL:_videoUrl options:nil];
    self.imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:myAsset];
    
    if ([self isRetina]){
        self.imageGenerator.maximumSize = CGSizeMake(_bgView.frame.size.width*2, _bgView.frame.size.height*2);
    } else {
        self.imageGenerator.maximumSize = CGSizeMake(_bgView.frame.size.width, _bgView.frame.size.height);
    }
    
    int picWidth = _picWidth;
    
    // First image
    NSError *error;
    CMTime actualTime;
    CGImageRef halfWayImage = [self.imageGenerator copyCGImageAtTime:kCMTimeZero actualTime:&actualTime error:&error];
    if (halfWayImage != NULL) {
        UIImage *videoScreen;
        if ([self isRetina]){
            videoScreen = [[UIImage alloc] initWithCGImage:halfWayImage scale:2.0 orientation:UIImageOrientationUp];
        } else {
            videoScreen = [[UIImage alloc] initWithCGImage:halfWayImage];
        }
        UIImageView *tmp = [[UIImageView alloc] initWithImage:videoScreen];
        CGRect rect=tmp.frame;
        rect.size.width=picWidth;
        tmp.frame=rect;
        [_bgView addSubview:tmp];
        picWidth = tmp.frame.size.width;
        CGImageRelease(halfWayImage);
    }
    
    
    _durationSeconds = CMTimeGetSeconds([myAsset duration]);
    
    int picsCnt = ceil(_bgView.frame.size.width / picWidth);
    
    NSMutableArray *allTimes = [[NSMutableArray alloc] init];
    
    int time4Pic = 0;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        // Bug iOS7 - generateCGImagesAsynchronouslyForTimes
        int prefreWidth=0;
        for (int i=1, ii=1; i<picsCnt; i++){
            time4Pic = i*picWidth;
            
            CMTime timeFrame = CMTimeMakeWithSeconds(_durationSeconds*time4Pic/_bgView.frame.size.width, 600);
            
            [allTimes addObject:[NSValue valueWithCMTime:timeFrame]];
            
            
            CGImageRef halfWayImage = [self.imageGenerator copyCGImageAtTime:timeFrame actualTime:&actualTime error:&error];
            
            UIImage *videoScreen;
            if ([self isRetina]){
                videoScreen = [[UIImage alloc] initWithCGImage:halfWayImage scale:2.0 orientation:UIImageOrientationUp];
            } else {
                videoScreen = [[UIImage alloc] initWithCGImage:halfWayImage];
            }
            
            
            
            UIImageView *tmp = [[UIImageView alloc] initWithImage:videoScreen];
            
            
            
            CGRect currentFrame = tmp.frame;
            currentFrame.origin.x = ii*picWidth;

            currentFrame.size.width=picWidth;
            prefreWidth+=currentFrame.size.width;
            
            if( i == picsCnt-1){
                currentFrame.size.width-=6;
            }
            tmp.frame = currentFrame;
            int all = (ii+1)*tmp.frame.size.width;

            if (all > _bgView.frame.size.width){
                int delta = all - _bgView.frame.size.width;
                currentFrame.size.width -= delta;
            }

            ii++;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_bgView addSubview:tmp];
            });
            
            
            
            
            CGImageRelease(halfWayImage);
            
        }
        
        
        return;
    }
    
    for (int i=1; i<picsCnt; i++){
        time4Pic = i*picWidth;
        
        CMTime timeFrame = CMTimeMakeWithSeconds(_durationSeconds*time4Pic/_bgView.frame.size.width, 600);
        
        [allTimes addObject:[NSValue valueWithCMTime:timeFrame]];
    }
    
    NSArray *times = allTimes;
    
    __block int i = 1;
    
    [self.imageGenerator generateCGImagesAsynchronouslyForTimes:times
                                              completionHandler:^(CMTime requestedTime, CGImageRef image, CMTime actualTime,
                                                                  AVAssetImageGeneratorResult result, NSError *error) {
                                                  
                                                  if (result == AVAssetImageGeneratorSucceeded) {
                                                      
                                                      
                                                      UIImage *videoScreen;
                                                      if ([self isRetina]){
                                                          videoScreen = [[UIImage alloc] initWithCGImage:image scale:2.0 orientation:UIImageOrientationUp];
                                                      } else {
                                                          videoScreen = [[UIImage alloc] initWithCGImage:image];
                                                      }
                                                      
                                                      
                                                      UIImageView *tmp = [[UIImageView alloc] initWithImage:videoScreen];
                                                      
                                                      int all = (i+1)*tmp.frame.size.width;
                                                      
                                                      
                                                      CGRect currentFrame = tmp.frame;
                                                      currentFrame.origin.x = i*currentFrame.size.width;
                                                      if (all > _bgView.frame.size.width){
                                                          int delta = all - _bgView.frame.size.width;
                                                          currentFrame.size.width -= delta;
                                                      }
                                                      tmp.frame = currentFrame;
                                                      i++;
                                                      
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          [_bgView addSubview:tmp];
                                                      });
                                                      
                                                  }
                                                  
                                                  if (result == AVAssetImageGeneratorFailed) {
                                                      NSLog(@"Failed with error: %@", [error localizedDescription]);
                                                  }
                                                  if (result == AVAssetImageGeneratorCancelled) {
                                                      NSLog(@"Canceled");
                                                  }
                                              }];
}

#pragma mark - Properties

- (float)leftPosition
{
    return _leftPosition * _durationSeconds / _frame_width;
}

- (float)rightPosition
{
    return _rightPosition * _durationSeconds / _frame_width;
}

- (float)currentTime
{
    return  _currentTime * _durationSeconds / _frame_width;
}

- (void)setBeganTime:(float)beganTime
{
    float newValue = beganTime * _frame_width / _durationSeconds;
    if (newValue != _leftPosition) {
        _leftPosition = newValue;
        [self setNeedsLayout];
    }
}

- (void)setEndTime:(float)endTime
{
    float newValue = endTime * _frame_width / _durationSeconds;
    if (newValue != _rightPosition) {
        _rightPosition = newValue;
        [self setNeedsLayout];
    }
}

- (void)setNowCurrentTime:(float)currentTime
{
    float newValue = currentTime * _frame_width / _durationSeconds;
    if (newValue != _currentTime) {
        _currentTime = newValue;
        [self setNeedsLayout];
    }
}

- (void)setupPosition
{
    _currentTime = 0;
    _leftPosition = 0;
    _rightPosition = _frame_width;
    [self layoutWithAnimation:NO];
}

- (void)setFrameWidth:(float)width
{
    _picWidth = width;
    [self getMovieFrame];
}

#pragma mark - Helpers

- (NSString *)timeToStr:(CGFloat)time
{
    NSInteger min = floor(time / 60);
    NSInteger sec = floor(time - min * 60);
    NSString *minStr = [NSString stringWithFormat:min >= 10 ? @"%li" : @"0%li", (long)min];
    NSString *secStr = [NSString stringWithFormat:sec >= 10 ? @"%li" : @"0%li", (long)sec];
    return [NSString stringWithFormat:@"%@:%@", minStr, secStr];
}


-(BOOL)isRetina{
    return ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            
            ([UIScreen mainScreen].scale == 2.0));
}


@end
