//
//  ALView.m
//  ALMoviePlayer
//
//  Created by Arthur on 15/4/8.
//  Copyright (c) 2015年 Andrei Solovjev. All rights reserved.
//

#import "ALView.h"

@implementation ALView

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _defaultColdor = [UIColor blackColor];
        _highlightColor = [UIColor yellowColor];
        _highlight = NO;
    }
    
    return self;
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
    if (!CGColorEqualToColor(defaultColdor.CGColor, _defaultColdor.CGColor)) {
        _defaultColdor = defaultColdor;
        if (!_highlight) {
            [self setNeedsDisplay];
        }
    }
}

- (void)setHighlightColor:(UIColor *)highlightColor
{
    if (!CGColorEqualToColor(highlightColor.CGColor, _highlightColor.CGColor)) {
        _highlightColor = highlightColor;
        if (_highlight) {
            [self setNeedsDisplay];
        }
    }
}


@end
