//
//  SecondViewController.h
//  RadtacPomodoro
//
//  Created by Richard Levy on 20/06/2013.
//  Copyright (c) 2013 RML. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClockView.h"
#import "XYPieChart.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@protocol TimeObserver
-(void)timeChanged:(id)sender;
-(void)finished:(id)sender;
@end

@interface SecondViewController : UIViewController <TimeObserver, XYPieChartDataSource>{
    NSTimer *timer;
}

@property NSTimer *timer;

// Linked in the story board
@property (nonatomic, strong) IBOutlet UIView *roundView;
@property (nonatomic, strong) IBOutlet UILabel *timerSeparatorLabel;
@property (nonatomic, strong) IBOutlet UILabel *timerMinutesLabel;
@property (nonatomic, strong) IBOutlet UILabel *timerSecondsLabel;
@property (nonatomic, strong) IBOutlet UILabel *keyLabel;
@property (nonatomic, strong) IBOutlet UILabel *rulesTextLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeTypeLabel;
@property (nonatomic, strong) IBOutlet UIButton *startStopButton;
@property (nonatomic, strong) IBOutlet XYPieChart *pieClock;

@property (nonatomic, strong) NSArray *sliceColors;
@property (nonatomic, strong) NSArray *keyTexts;
@property (nonatomic, strong) NSArray *rulesTexts;

// Linked in the story board
-(IBAction)startStopTapped:(id)sender;

-(void)timeChanged;

@end
