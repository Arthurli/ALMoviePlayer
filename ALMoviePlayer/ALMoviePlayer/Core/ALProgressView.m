//
//  ALProgressView.m
//  ALMoviePlayer
//
//  Created by Arthur on 15/4/8.
//  Copyright (c) 2015年 Andrei Solovjev. All rights reserved.
//

#import "ALProgressView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ALProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.defaultColdor = [UIColor whiteColor];
        self.highlightColor = [UIColor grayColor];

        self.layer.cornerRadius = self.frame.size.width/2;
        
    }
    return self;
}

@end
