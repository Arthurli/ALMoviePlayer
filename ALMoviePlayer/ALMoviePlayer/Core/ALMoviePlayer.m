//
//  ALMoviePlayer.m
//  ALMoviePlayer
//
//  Created by Arthur on 15/4/8.
//  Copyright (c) 2015年 Arthur. All rights reserved.
//

#import "ALMoviePlayer.h"

@interface ALMoviePlayer ()<ALMovieToolBarDelegate, ALVideoRangeSliderDelegate>

@property (strong, nonatomic) AVAssetExportSession *exportSession;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, assign) BOOL floatBar;

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation ALMoviePlayer

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addNotification];
}


- (void)viewWillAppear:(BOOL)animated
{
    [self setupWithSize:self.view.frame.size];
    [self setupNavBarTitle];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setFilePath:(NSString *)filePath
{
    if (![_filePath isEqualToString:filePath]) {
        _filePath = filePath;
        NSURL *fileUrl = [NSURL fileURLWithPath:_filePath];
        AVAsset *myAsset = [[AVURLAsset alloc] initWithURL:fileUrl
                                                   options:nil];
        int durationSeconds = (int)CMTimeGetSeconds([myAsset duration]);
        NSString *timeStr;
        if (durationSeconds/(60*60) > 0) {
            int hour = durationSeconds/(60*60);
            int  minute = durationSeconds%(60*60)/60;
            int  second = durationSeconds%(60*60)%60;
            timeStr = [NSString stringWithFormat:@"%d:%@:%@",hour,minute<10?[NSString stringWithFormat:@"0%d",minute]:[NSString stringWithFormat:@"%d",minute],second<10?[NSString stringWithFormat:@"0%d",second]:[NSString stringWithFormat:@"%d",second]];
        } else {
            int minute = durationSeconds/60;
            int  second = durationSeconds%60;
            timeStr = [NSString stringWithFormat:@"%@:%@",minute<10?[NSString stringWithFormat:@"0%d",minute]:[NSString stringWithFormat:@"%d",minute],second<10?[NSString stringWithFormat:@"0%d",second]:[NSString stringWithFormat:@"%d",second]];
        }
        
        self.titleLabel.text = self.title;
        self.timeLabel.text = timeStr;
        
        [self UISetup];
        [self setupWithSize:self.view.frame.size];
        
    }
}

- (void)setupNavBarTitle
{
    if (self.navigationController) {
        
        float navbarHeight = self.navigationController.navigationBar.frame.size.height;
        
        self.titleView.frame = CGRectMake(0, 0, 200, navbarHeight);
        self.titleLabel.frame = CGRectMake(0, 0, 200, navbarHeight*3/5);
        self.timeLabel.frame = CGRectMake(0, navbarHeight*3/5, 200, navbarHeight*2/5);
        
        self.navigationItem.titleView = self.titleView;
    }
}

- (void)UISetup
{
    NSURL *url = [NSURL fileURLWithPath:_filePath];
    
    ALVideoRangeSlider *slide = [[ALVideoRangeSlider alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) videoUrl:url];
    slide.delegate = self;
    slide.hideRangeSlider = YES;
    [self.view addSubview:slide];
    [_videoSlider removeFromSuperview];
    _videoSlider = slide;
    
    ALMovieToolBar *toolBar = [[ALMovieToolBar alloc] init];
    [toolBar setRightButtonType:ALMovieToolBarButtonTypeDelete];
    [toolBar setCenterButtonType:ALMovieToolBarButtonTypePlay];
    toolBar.delegate = self;
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
    [self.view insertSubview:theMovie.view atIndex:0];
    [_controller.view removeFromSuperview];
    _controller = theMovie;
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button addTarget:self action:@selector(clickPlayButton:) forControlEvents:UIControlEventTouchUpInside];
    [_button setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    _button.frame = CGRectMake(0, 0, _controller.view.frame.size.width, _controller.view.frame.size.height);
    [_controller.view addSubview:_button];
    
    NSTimer *time = [NSTimer timerWithTimeInterval:.5 target:self selector:@selector(updateMovieProgress) userInfo:nil repeats:YES];
    [[NSRunLoop  currentRunLoop] addTimer:time forMode:NSDefaultRunLoopMode];
    [time fire];
    [_timer invalidate];
    _timer = time;
    
}

- (void)setupWithSize:(CGSize)size
{
    float offsetY = 0;
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    if (self.navigationController && (self.edgesForExtendedLayout&UIRectEdgeTop) != 0) {
        offsetY = self.navigationController.navigationBar.frame.size.height + self.navigationController.navigationBar.frame.origin.y;
    } else if (self.navigationController == nil) {
        offsetY = statusBarFrame.size.height;
    }
    
    _videoSlider.frame = CGRectMake(0, offsetY, size.width, 44);
    _toolBar.frame = CGRectMake(0, size.height-44, size.width, 44);
    
    if (_floatBar) {
        _controller.view.frame = CGRectMake(0, 0, size.width, size.height);
    } else {
        _controller.view.frame = CGRectMake(0, _videoSlider.frame.size.height + offsetY, size.width, size.height - _videoSlider.frame.size.height - _toolBar.frame.size.height - offsetY);
    }
    _button.frame = CGRectMake(0, 0, _controller.view.frame.size.width, _controller.view.frame.size.height);
}


- (UIView *)titleView
{
    if (_titleView == nil) {
        _titleView = [[UIView alloc] init];
    }
    
    return _titleView;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont systemFontOfSize:14]];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.titleView addSubview:_titleLabel];
    }
    
    return _titleLabel;
}

- (UILabel *)timeLabel
{
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        [_timeLabel setFont:[UIFont systemFontOfSize:10]];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        [self.titleView addSubview:_timeLabel];
    }
    
    return _timeLabel;
}

- (void)clickPlayButton:(UIButton *)button
{
    button.hidden = YES;
    [_controller.moviePlayer play];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         [self setupWithSize:size];
         [self setupNavBarTitle];

     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}


#pragma mark timer and notification

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieStateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
}

- (void)movieStateChange:(NSNotification *)noti
{
    if (noti.object == _controller.moviePlayer) {
        
        if (_controller.moviePlayer.playbackState == MPMoviePlaybackStatePlaying) {
            _button.hidden = YES;
            [_toolBar setCenterButtonType:ALMovieToolBarButtonTypePause];
        } else if (_controller.moviePlayer.playbackState == MPMoviePlaybackStatePaused) {
            _button.hidden = NO;
            [_videoSlider setNowCurrentTime:_controller.moviePlayer.currentPlaybackTime];
            [_toolBar setCenterButtonType:ALMovieToolBarButtonTypePlay];
        } else if (_controller.moviePlayer.playbackState == MPMoviePlaybackStateStopped){
            _button.hidden = NO;
            [_videoSlider setNowCurrentTime:_controller.moviePlayer.currentPlaybackTime];
            [_videoSlider setupPosition];
            [_toolBar setCenterButtonType:ALMovieToolBarButtonTypePlay];
        }
    }
}

- (void)updateMovieProgress{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([_controller.moviePlayer playbackState] != MPMoviePlaybackStatePaused &&
            [_controller.moviePlayer playbackState] != MPMoviePlaybackStateStopped) {
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
            break;
        case ALMovieToolBarButtonTypePause:
            [_controller.moviePlayer pause];
            break;
            
        default:
            break;
    }
    
    if ([_delegate respondsToSelector:@selector(didClickButtonWithType:)]) {
        [_delegate didClickButtonWithType:buttonType];
    }
}

#pragma mark - ALVideoRangeSliderDelegate

- (void)currentTimeArriveStartOrEnd:(BOOL)isEnd
{
    if (isEnd) {
        if (_controller.moviePlayer.playbackState == MPMoviePlaybackStatePlaying) {
            [_controller.moviePlayer pause];
        }
    }
}

- (void)videoRange:(ALVideoRangeSlider *)videoRange didChangeLeftPosition:(float)leftPosition rightPosition:(float)rightPosition
{
 
}

- (void)videoRange:(ALVideoRangeSlider *)videoRange didChangeCurrentTime:(float)currentTime
{
    if (_controller.moviePlayer.playbackState == MPMoviePlaybackStatePlaying) {
        [_controller.moviePlayer pause];
    }
    [_controller.moviePlayer setCurrentPlaybackTime:currentTime];
}

- (void)videoRange:(ALVideoRangeSlider *)videoRange didGestureStateEndedLeftPosition:(float)leftPosition rightPosition:(float)rightPosition
{
}

@end
