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

        if (self.highlight) {
            self.backgroundColor = self.highlightColor;
        } else {
            self.backgroundColor = self.defaultColdor;
        }
        
        self.layer.cornerRadius = self.frame.size.width/2;
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    
}

@end
