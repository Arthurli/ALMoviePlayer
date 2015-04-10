//
//  ALView.m
//  ALMoviePlayer
//
//  Created by Arthur on 15/4/8.
//  Copyright (c) 2015年 Andrei Solovjev. All rights reserved.
//

#import "ALView.h"

@implementation ALView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setup];
    }
    
    return self;
}


- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    _defaultColdor = [UIColor blackColor];
    _highlightColor = [UIColor yellowColor];
    _highlight = NO;
}

- (void)setHighlight:(BOOL)highlight
{
    if (_highlight != highlight) {
        _highlight = highlight;
        [self setNeedsDisplay];
    }
}

- (void)setDefaultColdor:(UIColor *)defaultColdor
{
    _defaultColdor = defaultColdor;
    if (!_highlight) {
        [self setNeedsDisplay];
    }
}

- (void)setHighlightColor:(UIColor *)highlightColor
{
    _highlightColor = highlightColor;
    if (_highlight) {
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    if (self.highlight) {
        self.backgroundColor = self.highlightColor;
    } else {
        self.backgroundColor = self.defaultColdor;
    }
    [self.backgroundColor setFill];
    CGContextFillRect(UIGraphicsGetCurrentContext(), rect);
}


@end
