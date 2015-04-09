//
//  ViewController.m
//  ALMoviePlayer
//
//  Created by Arthur on 15/4/8.
//  Copyright (c) 2015年 Arthur. All rights reserved.
//

#import "ViewController.h"
#import "ALMoviePlayer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *filePath = [mainBundle pathForResource: @"thaiPhuketKaronBeach" ofType: @"MOV"];
    ALMoviePlayer *moviePlayer = [[ALMoviePlayer alloc] init];
    moviePlayer.title = @"thaiPhuketKaronBeach.mov";
    UIViewController *a = [[UIViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:a];
    [self presentViewController:nav animated:YES completion:^{
        [a.navigationController pushViewController:moviePlayer animated:YES];
        moviePlayer.filePath = filePath;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
