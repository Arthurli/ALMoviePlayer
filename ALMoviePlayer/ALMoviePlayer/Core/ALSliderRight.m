//
//  ALProgressView.m
//  ALMoviePlayer
//
//  Created by Arthur on 15/4/8.
//  Copyright (c) 2015年 Andrei Solovjev. All rights reserved.
//

#import "ALSliderRight.h"

@implementation ALSliderRight

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
    
    UIColor* color = [UIColor yellowColor];
    UIColor* color2 = [UIColor whiteColor];
    if (self.highlight) {
        color = self.highlightColor;
    } else {
        color = self.defaultColdor;
    }
    
    //// Gradient Declarations
    NSArray* gradientColors = [NSArray arrayWithObjects:
                                (id)color.CGColor, nil];
    CGFloat gradientLocations[] = {1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
    
    //// Frames
    CGRect bubbleFrame = self.bounds;
    
    
    //// Rounded Rectangle Drawing
    CGRect roundedRectangleRect = CGRectMake(CGRectGetMinX(bubbleFrame), CGRectGetMinY(bubbleFrame), CGRectGetWidth(bubbleFrame), CGRectGetHeight(bubbleFrame));
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: roundedRectangleRect byRoundingCorners: UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii: CGSizeMake(5, 5)];
    [roundedRectanglePath closePath];
    CGContextSaveGState(context);
    [roundedRectanglePath addClip];
    CGContextDrawLinearGradient(context, gradient,
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
    
    [color2 setFill];
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
    
    [color2 setFill];
    [bezierPath fill];
    
    
    //// Cleanup
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}


@end
