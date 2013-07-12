//
//  TestTimer.m
//  RadtacPomodoro
//
//  Created by Richard Levy on 21/06/2013.
//  Copyright (c) 2013 RML. All rights reserved.
//

#import "TestTimer.h"

@implementation TestTimer

// Note that this creates two set methods for these, satisfying the needs of the PomodoroTimer protocol
@synthesize delegate = _delegate;
@synthesize interval = _interval;

-(void)start {
    // Just pretend that the interval has gone passed, converted to ms
   [self.delegate timeHasPassed:@([self.interval intValue]*1000)];
}

@end
