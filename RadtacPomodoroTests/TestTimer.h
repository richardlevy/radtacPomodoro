//
//  TestTimer.h
//  RadtacPomodoro
//
//  Created by Richard Levy on 21/06/2013.
//  Copyright (c) 2013 RML. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pomodoro.h"

@interface TestTimer : NSObject <PomodoroTimer>

// Note that this creates two set methods for these, satisfying the needs of the PomodoroTimer protocol
@property Pomodoro *delegate;
@property NSNumber *interval;

-(void)start;

@end
