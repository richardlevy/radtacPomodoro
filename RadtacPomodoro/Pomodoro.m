//
//  Pomodoro.m
//  RadtacPomodoro
//
//  Created by Richard Levy on 21/06/2013.
//  Copyright (c) 2013 RML. All rights reserved.
//

#import "Pomodoro.h"

@implementation Pomodoro {
    BOOL isCancelled;
    
}

@synthesize totalTime = _totalTime;
@synthesize timeRemaining = _timeRemaining;
@synthesize active = _active;
@synthesize timeObserver = _timeObserver;

-(id)initWithTimer:(__autoreleasing id<PomodoroTimer>)timer {
    if ((self=[super init])!=nil){
        self.timeRemaining = @(0);
        self.active = NO;
        [timer setDelegate:self];
        pomodoroTimer = timer;
        self->isCancelled=NO;
    }
    return self;
    
}

-(void)windTo:(NSNumber *)timeInSeconds{
    self.totalTime=timeInSeconds;
    self.timeRemaining=timeInSeconds;
    // Call observer to indicate it should display the timer
    [self.timeObserver timeChanged:self];
 
}

- (int)isWound {
    return [self.timeRemaining intValue]>0;
}

-(BOOL)start {
    // Only start a wound pomodoro
    // Written like this because we'll be adding in the timer
    if ([self isWound]){
        self->isCancelled=NO;
        self.active=YES;
        [self->pomodoroTimer start];
    } else {
        self.active=NO;
    }
    return self.active;
    
}

-(void) stop{
    self->isCancelled=YES;
    self.active=NO;
}

-(void)timeHasPassed:(NSNumber *)milliseconds{
    
    // If the cancel flag is set, this may be the timer firing that was already in motion, so we'll ignore.
    if (!self->isCancelled){
        double newTimeRemaining = [self calculateNewTimeRemaining:[milliseconds intValue]];
        self.timeRemaining = @(newTimeRemaining);
        
        if (newTimeRemaining > 0){
            [self->pomodoroTimer start];
            if (self.timeObserver){
                [self.timeObserver timeChanged:self];
            }
        } else {
            // Finished
            self.active=NO;
            if (self.timeObserver){
                [self.timeObserver finished:self];
            }
        }
    }
    
}

-(double)calculateNewTimeRemaining:(double)elapsedMilliseconds{
    
    double currentTimeRemaining = [self.timeRemaining intValue];
    double elapsed = elapsedMilliseconds/1000;

    return currentTimeRemaining - elapsed;
    
}

@end
