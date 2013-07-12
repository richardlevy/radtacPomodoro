//
//  TestTimeObserver.h
//  RadtacPomodoro
//
//  Created by Richard Levy on 24/06/2013.
//  Copyright (c) 2013 RML. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SecondViewController.h"

@interface TestTimeObserver : NSObject <TimeObserver>

@property int changedCounter;
@property int finishedCounter;

-(void)timeChanged;
-(void)finished;

@end
