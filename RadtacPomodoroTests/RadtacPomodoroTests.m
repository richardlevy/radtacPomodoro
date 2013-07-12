//
//  RadtacPomodoroTests.m
//  RadtacPomodoroTests
//
//  Created by Richard Levy on 20/06/2013.
//  Copyright (c) 2013 RML. All rights reserved.
//

#import "RadtacPomodoroTests.h"
#import "Pomodoro.h"
#import "TestTimer.h"
#import "SimplePomodoroTimer.h"
#import "TestTimeObserver.h"

@implementation RadtacPomodoroTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testInitialisedPomodoro {
    Pomodoro *pomodoro = [[Pomodoro alloc]initWithTimer:nil];

    STAssertEquals([[pomodoro timeRemaining]intValue], 0, @"Default time remaining should be 0 minutes");
    STAssertFalse([pomodoro active], @"Pomodoro should not start automatically");
}

- (void)testPomodoroTimeCanBeSet {
    Pomodoro *pomodoro = [[Pomodoro alloc]initWithTimer:nil];
    
    [pomodoro windTo:@(1500)];
    STAssertEquals([[pomodoro timeRemaining]intValue], 25*60, @"Default time remaining should be 25 minutes");
}

- (void)testPomodoroIsActiveWhenStarted {
    Pomodoro *pomodoro = [[Pomodoro alloc]initWithTimer:nil];
    
    [pomodoro windTo:@(1500)];

    STAssertFalse([pomodoro active], @"Pomodoro should not start automatically");
    STAssertTrue([pomodoro start], @"Starting the pomodoro with a non 0 time should return true");
    STAssertTrue([pomodoro active], @"Pomodoro should have started");
}

-(void)testThrowsErrorIfNotWound{
    Pomodoro *pomodoro = [[Pomodoro alloc]initWithTimer:nil];

    STAssertFalse([pomodoro start], @"Starting the pomodoro without winding should return false");
    STAssertFalse([pomodoro active], @"Pomodoro should not be active");
}

-(void)testCountsDownWhenActive{
    TestTimer *testTimer = [[TestTimer alloc]init];
    [testTimer setInterval:@(1)];
    
    Pomodoro *pomodoro = [[Pomodoro alloc]initWithTimer:testTimer];

    [pomodoro windTo:@(10)];
    
    [pomodoro start];
    
    // The test timer takes no actual pauses - it lies about the time passed, so have a quick pause here to let
    // it do its thing, then check the pomodoro
    
    [NSThread sleepForTimeInterval:1];
    
    STAssertEquals([[pomodoro timeRemaining]intValue], 0, @"Pomodoro has not counted down");
    STAssertFalse(pomodoro.active, @"Pomodoro should not be active");
}

-(void)testTimeObserverCalled{
    TestTimer *testTimer = [[TestTimer alloc]init];
    [testTimer setInterval:@(1)];
    
    Pomodoro *pomodoro = [[Pomodoro alloc]initWithTimer:testTimer];
    
    TestTimeObserver *testTimeObserver = [[TestTimeObserver alloc]init];
    pomodoro.timeObserver=testTimeObserver;
    
    [pomodoro windTo:@(10)];

    STAssertTrue(testTimeObserver.finishedCounter==0, @"Time observer finish counter should not have been called");
    STAssertEquals(testTimeObserver.changedCounter,1, @"Time observer change counter should have been called once onWind");
    
    [pomodoro start];
  
    STAssertEquals(testTimeObserver.finishedCounter,1, @"Time observer finish counter should have been called once");
    STAssertEquals(testTimeObserver.changedCounter,10, @"Time observer change counter should  have been called 10 times");
}

// Because of the threading issue with times, we can't test this
-(void)canBeCancelled{
    SimplePomodoroTimer *testTimer = [[SimplePomodoroTimer alloc]init];
    [testTimer setInterval:@(1)];
    
    Pomodoro *pomodoro = [[Pomodoro alloc]initWithTimer:testTimer];
    
    [pomodoro windTo:@(5)];
    
    double startTimeRemaining=[[pomodoro timeRemaining]intValue];
    STAssertEquals([[pomodoro timeRemaining]intValue], 5, @"Time remaining before start is wrong");
    
    [pomodoro start];
    
    STAssertTrue (pomodoro.active, @"Pomodoro should be active");
    
    [NSThread sleepForTimeInterval:2];

    double timeRemaining=[[pomodoro timeRemaining]intValue];

    STAssertFalse(startTimeRemaining==timeRemaining, @"Pomodoro isnt counting down");
    
    [pomodoro stop];

    // Reget the time adter stopping, just in case it's changed
    timeRemaining=[[pomodoro timeRemaining]intValue];
    
    [NSThread sleepForTimeInterval:2];

    double stoppedTimeRemaining=[[pomodoro timeRemaining]intValue];

    STAssertTrue(timeRemaining==stoppedTimeRemaining, @"Stopped pomodoro should not have different time");
    
    STAssertFalse (pomodoro.active, @"Pomodoro should not be active");
    
}
@end
