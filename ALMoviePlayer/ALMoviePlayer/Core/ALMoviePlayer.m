//
//  ALMoviePlayer.m
//  ALMoviePlayer
//
//  Created by Arthur on 15/4/8.
//  Copyright (c) 2015年 Arthur. All rights reserved.
//

#import "ALMoviePlayer.h"
#import "ALMoviePlayerViewController.h"
#import "ALVideoRangeSlider.h"
#import "ALMovieToolBar.h"

@interface ALMoviePlayer ()<ALMovieToolBarDelegate, ALVideoRangeSliderDelegate>

@property (strong, nonatomic) AVAssetExportSession *exportSession;
@property (nonatomic, strong) ALMoviePlayerViewController *controller;
@property (nonatomic, strong) ALVideoRangeSlider *videoSlider;
@property (nonatomic, strong) ALMovieToolBar *toolBar;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ALMoviePlayer

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setFilePath:(NSString *)filePath
{
    if (![_filePath isEqualToString:filePath]) {
        _filePath = filePath;
        [self UISetup];
    }
}

- (void)UISetup
{
    NSURL *url = [NSURL fileURLWithPath:_filePath];
    
    ALVideoRangeSlider *slide = [[ALVideoRangeSlider alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) videoUrl:url];
    slide.delegate = self;
    [self.view addSubview:slide];
    [_videoSlider removeFromSuperview];
    _videoSlider = slide;
    
    ALMovieToolBar *toolBar = [[ALMovieToolBar alloc] init];
    [toolBar setRightButtonType:ALMovieToolBarButtonTypeDelete];
    [toolBar setCenterButtonType:ALMovieToolBarButtonTypePlay];
    toolBar.delegate = self;
    toolBar.backgroundColor = [UIColor grayColor];
    toolBar.frame = CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44);
    [self.view addSubview:toolBar];
    [_toolBar removeFromSuperview];
    _toolBar = toolBar;
    
    ALMoviePlayerViewController *theMovie = [[ALMoviePlayerViewController alloc] initWithContentURL:url];
    theMovie.moviePlayer.shouldAutoplay = NO;
    theMovie.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    theMovie.moviePlayer.controlStyle = MPMovieControlStyleNone;
    theMovie.moviePlayer.backgroundView.backgroundColor = [UIColor whiteColor];
    theMovie.view.backgroundColor = [UIColor whiteColor];
    theMovie.view.frame = CGRectMake(0, _videoSlider.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _videoSlider.frame.size.height - _toolBar.frame.size.height);
    [self.view addSubview:theMovie.view];
    [_controller.view removeFromSuperview];
    _controller = theMovie;
    
    NSTimer *time = [NSTimer timerWithTimeInterval:.5 target:self selector:@selector(updateMovieProgress) userInfo:nil repeats:YES];
    [[NSRunLoop  currentRunLoop] addTimer:time forMode:NSDefaultRunLoopMode];
    [time fire];
    [_timer invalidate];
    _timer = time;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    _videoSlider.frame = CGRectMake(0, 0, size.width, 44);
    _toolBar.frame = CGRectMake(0, size.height-44, size.width, 44);
    _controller.view.frame = CGRectMake(0, _videoSlider.frame.size.height, size.width, size.height - _videoSlider.frame.size.height - _toolBar.frame.size.height);
}

#pragma mark timer and notification

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieStop:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

- (void)movieStop:(NSNotification *)noti
{
    if (noti.object == _controller.moviePlayer) {
        [_videoSlider setNowCurrentTime:_controller.moviePlayer.currentPlaybackTime];
        [_videoSlider setupPosition];
        [_toolBar setCenterButtonType:ALMovieToolBarButtonTypePlay];
    }
}

- (void)updateMovieProgress{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([_controller.moviePlayer playbackState] == MPMoviePlaybackStatePlaying) {
            [_videoSlider setNowCurrentTime:_controller.moviePlayer.currentPlaybackTime];
        }
    });
}

#pragma mark - ALMovieToolBarDelegate

- (void)didClickToolbarButtonWithType:(ALMovieToolBarButtonType)buttonType
{
    switch (buttonType) {
        case ALMovieToolBarButtonTypePlay:
            [_controller.moviePlayer play];
            [_toolBar setCenterButtonType:ALMovieToolBarButtonTypePause];
            break;
        case ALMovieToolBarButtonTypePause:
            [_controller.moviePlayer pause];
            [_toolBar setCenterButtonType:ALMovieToolBarButtonTypePlay];
            break;
            
        default:
            break;
    }
}

#pragma mark - ALVideoRangeSliderDelegate

- (void)videoRange:(ALVideoRangeSlider *)videoRange didChangeLeftPosition:(float)leftPosition rightPosition:(float)rightPosition
{
 
}

- (void)videoRange:(ALVideoRangeSlider *)videoRange didChangeCurrentTime:(float)currentTime
{
    if (_controller.moviePlayer.playbackState == MPMoviePlaybackStatePlaying) {
        [_controller.moviePlayer pause];
        [_toolBar setCenterButtonType:ALMovieToolBarButtonTypePlay];
    }
    [_controller.moviePlayer setCurrentPlaybackTime:currentTime];
}

- (void)videoRange:(ALVideoRangeSlider *)videoRange didGestureStateEndedLeftPosition:(float)leftPosition rightPosition:(float)rightPosition
{
}

@end
