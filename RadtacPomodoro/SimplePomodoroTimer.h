//
//  SimplePomodoroTimer.h
//  RadtacPomodoro
//
//  Created by Richard Levy on 24/06/2013.
//  Copyright (c) 2013 RML. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pomodoro.h"

@interface SimplePomodoroTimer : NSObject <PomodoroTimer> {
    NSTimer *timer;
    double startTime;
}

@property (nonatomic, weak) Pomodoro *delegate;
@property (nonatomic, strong) NSNumber *interval;

@end
