//
//  SimplePomodoroTimer.m
//  RadtacPomodoro
//
//  Created by Richard Levy on 24/06/2013.
//  Copyright (c) 2013 RML. All rights reserved.
//

#import "SimplePomodoroTimer.h"

@implementation SimplePomodoroTimer 

@synthesize delegate = _delegate;
@synthesize interval = _interval;

- (id)init
{
    self = [super init];
    if (self) {
        self->startTime=0;
        self->timer=nil;
    }
    return self;
}

-(void)start{
    // Record the start time in milliseconds
    self->startTime = [[NSDate date] timeIntervalSince1970];
    self->timer = [NSTimer scheduledTimerWithTimeInterval:[self.interval intValue] target:self selector:@selector(trigger) userInfo:nil repeats:NO];
    
}

-(void)trigger {
    // Call the pomodoro object, indicating how much actual time has passed
    double now = [[NSDate date] timeIntervalSince1970];
    
    [self.delegate timeHasPassed:@(now - self->startTime)];
    
}
@end
