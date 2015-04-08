//
//  ALProgressView.m
//  ALMoviePlayer
//
//  Created by Arthur on 15/4/8.
//  Copyright (c) 2015年 Andrei Solovjev. All rights reserved.
//

#import "ALProgressView.h"

@implementation ALProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* color5 = [UIColor colorWithRed: 0.992 green: 0.902 blue: 0.004 alpha: 1];
    UIColor* gradientColor2 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    UIColor* color6 = [UIColor colorWithRed: 0.196 green: 0.161 blue: 0.047 alpha: 1];
    
    //// Gradient Declarations
    NSArray* gradient3Colors = [NSArray arrayWithObjects:
                                (id)gradientColor2.CGColor,
                                (id)[UIColor colorWithRed: 0.996 green: 0.951 blue: 0.502 alpha: 1].CGColor,
                                (id)color5.CGColor, nil];
    CGFloat gradient3Locations[] = {0, 0, 0.49};
    CGGradientRef gradient3 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradient3Colors, gradient3Locations);
    
    //// Frames
    CGRect bubbleFrame = self.bounds;
    
    
    //// Rounded Rectangle Drawing
    CGRect roundedRectangleRect = CGRectMake(CGRectGetMinX(bubbleFrame), CGRectGetMinY(bubbleFrame), CGRectGetWidth(bubbleFrame), CGRectGetHeight(bubbleFrame));
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: roundedRectangleRect byRoundingCorners: UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii: CGSizeMake(5, 5)];
    [roundedRectanglePath closePath];
    CGContextSaveGState(context);
    [roundedRectanglePath addClip];
    CGContextDrawLinearGradient(context, gradient3,
                                CGPointMake(CGRectGetMidX(roundedRectangleRect), CGRectGetMinY(roundedRectangleRect)),
                                CGPointMake(CGRectGetMidX(roundedRectangleRect), CGRectGetMaxY(roundedRectangleRect)),
                                0);
    CGContextRestoreGState(context);
    [[UIColor clearColor] setStroke];
    roundedRectanglePath.lineWidth = 0.5;
    [roundedRectanglePath stroke];
    
    
    //// Bezier 3 Drawing
    UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
    [bezier3Path moveToPoint: CGPointMake(CGRectGetMinX(bubbleFrame) + 0.42806 * CGRectGetWidth(bubbleFrame), CGRectGetMinY(bubbleFrame) + 0.22486 * CGRectGetHeight(bubbleFrame))];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(bubbleFrame) + 0.42806 * CGRectGetWidth(bubbleFrame), CGRectGetMinY(bubbleFrame) + 0.74629 * CGRectGetHeight(bubbleFrame)) controlPoint1: CGPointMake(CGRectGetMinX(bubbleFrame) + 0.42806 * CGRectGetWidth(bubbleFrame), CGRectGetMinY(bubbleFrame) + 0.69415 * CGRectGetHeight(bubbleFrame)) controlPoint2: CGPointMake(CGRectGetMinX(bubbleFrame) + 0.42806 * CGRectGetWidth(bubbleFrame), CGRectGetMinY(bubbleFrame) + 0.69415 * CGRectGetHeight(bubbleFrame))];
    [bezier3Path addLineToPoint: CGPointMake(CGRectGetMinX(bubbleFrame) + 0.35577 * CGRectGetWidth(bubbleFrame), CGRectGetMinY(bubbleFrame) + 0.74629 * CGRectGetHeight(bubbleFrame))];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(bubbleFrame) + 0.35577 * CGRectGetWidth(bubbleFrame), CGRectGetMinY(bubbleFrame) + 0.22486 * CGRectGetHeight(bubbleFrame)) controlPoint1: CGPointMake(CGRectGetMinX(bubbleFrame) + 0.35577 * CGRectGetWidth(bubbleFrame), CGRectGetMinY(bubbleFrame) + 0.69415 * CGRectGetHeight(bubbleFrame)) controlPoint2: CGPointMake(CGRectGetMinX(bubbleFrame) + 0.35577 * CGRectGetWidth(bubbleFrame), CGRectGetMinY(bubbleFrame) + 0.69415 * CGRectGetHeight(bubbleFrame))];
    [bezier3Path addLineToPoint: CGPointMake(CGRectGetMinX(bubbleFrame) + 0.42806 * CGRectGetWidth(bubbleFrame), CGRectGetMinY(bubbleFrame) + 0.22486 * CGRectGetHeight(bubbleFrame))];
    [bezier3Path closePath];
    bezier3Path.miterLimit = 19;
    
    [color6 setFill];
    [bezier3Path fill];
    
    
    //// Bezier Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(bubbleFrame) + 0.66944 * CGRectGetWidth(bubbleFrame), CGRectGetMinY(bubbleFrame) + 0.22486 * CGRectGetHeight(bubbleFrame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(bubbleFrame) + 0.66944 * CGRectGetWidth(bubbleFrame), CGRectGetMinY(bubbleFrame) + 0.74629 * CGRectGetHeight(bubbleFrame)) controlPoint1: CGPointMake(CGRectGetMinX(bubbleFrame) + 0.66944 * CGRectGetWidth(bubbleFrame), CGRectGetMinY(bubbleFrame) + 0.69415 * CGRectGetHeight(bubbleFrame)) controlPoint2: CGPointMake(CGRectGetMinX(bubbleFrame) + 0.66944 * CGRectGetWidth(bubbleFrame), CGRectGetMinY(bubbleFrame) + 0.69415 * CGRectGetHeight(bubbleFrame))];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(bubbleFrame) + 0.59715 * CGRectGetWidth(bubbleFrame), CGRectGetMinY(bubbleFrame) + 0.74629 * CGRectGetHeight(bubbleFrame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(bubbleFrame) + 0.59715 * CGRectGetWidth(bubbleFrame), CGRectGetMinY(bubbleFrame) + 0.22486 * CGRectGetHeight(bubbleFrame)) controlPoint1: CGPointMake(CGRectGetMinX(bubbleFrame) + 0.59715 * CGRectGetWidth(bubbleFrame), CGRectGetMinY(bubbleFrame) + 0.69415 * CGRectGetHeight(bubbleFrame)) controlPoint2: CGPointMake(CGRectGetMinX(bubbleFrame) + 0.59715 * CGRectGetWidth(bubbleFrame), CGRectGetMinY(bubbleFrame) + 0.69415 * CGRectGetHeight(bubbleFrame))];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(bubbleFrame) + 0.66944 * CGRectGetWidth(bubbleFrame), CGRectGetMinY(bubbleFrame) + 0.22486 * CGRectGetHeight(bubbleFrame))];
    [bezierPath closePath];
    bezierPath.miterLimit = 19;
    
    [color6 setFill];
    [bezierPath fill];
    
    
    //// Cleanup
    CGGradientRelease(gradient3);
    CGColorSpaceRelease(colorSpace);
}


@end
