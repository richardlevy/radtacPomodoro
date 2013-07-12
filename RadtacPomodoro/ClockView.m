//
//  ClockView.m
//  RadtacPomodoro
//
//  Created by Richard Levy on 02/07/2013.
//  Copyright (c) 2013 RML. All rights reserved.
//

#import "ClockView.h"

@implementation ClockView

@synthesize maxTime = _maxTime;
@synthesize currentTime = _currentTime;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(ctx, rect);
    CGContextSetFillColor(ctx, CGColorGetComponents([[UIColor blueColor] CGColor]));
    CGContextFillPath(ctx);
}

@end
