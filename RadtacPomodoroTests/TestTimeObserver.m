//
//  TestTimeObserver.m
//  RadtacPomodoro
//
//  Created by Richard Levy on 24/06/2013.
//  Copyright (c) 2013 RML. All rights reserved.
//

#import "TestTimeObserver.h"

@implementation TestTimeObserver

@synthesize changedCounter=_changedCounter;
@synthesize finishedCounter=_finishedCounter;

- (id)init
{
    self = [super init];
    if (self) {
        self.changedCounter=0;
        self.finishedCounter=0;
    }
    return self;
}

-(void)timeChanged{
    self.changedCounter++;
}

-(void)finished{
    self.finishedCounter++;
}
@end
