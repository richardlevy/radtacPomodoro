//
//  Pomodoro.h
//  RadtacPomodoro
//
//  Created by Richard Levy on 21/06/2013.
//  Copyright (c) 2013 RML. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SecondViewController.h"

@class Pomodoro;

@protocol PomodoroTimer

// Should be another protocol for the delegate, but we don't need it at the mo
-(void)setDelegate:(Pomodoro *)pomodoro;
-(void)setInterval:(NSNumber *)seconds;
-(void)start;

@end

#define TWENTY_FIVE_MINUTES 1500;

// Pomodoro needs to inform something when it's finished
// Display needs to be updated when the time changes

// Could have a WindTo method which adds to time remaining to set it back to 25 minutes.
// If the display is still watching, then it will show it being reset to 25, which symbolises the winding of the pomodoro

@interface Pomodoro : NSObject {
    // Note that id is a pointer type
    id <PomodoroTimer> pomodoroTimer;
}

@property (nonatomic, strong) NSNumber *timeRemaining;
@property (nonatomic, strong) NSNumber *totalTime;
@property (nonatomic) BOOL active;
@property (nonatomic, weak) id<TimeObserver> timeObserver;

-(id)initWithTimer:(id <PomodoroTimer>)timer;

// Winds the pomodoro to a time
-(void)windTo:(NSNumber *)timeInSeconds;

// Start counting down
-(BOOL)start;

// The timer calls this to indicate that a certain amount of milliseconds has passed.
// Note that we do this because the IOS Timer documentation says that timers may not be exact
-(void)timeHasPassed:(NSNumber *)milliseconds;

-(void)stop;

@end
