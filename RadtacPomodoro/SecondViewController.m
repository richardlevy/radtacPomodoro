//
//  SecondViewController.m
//  RadtacPomodoro
//
//  Created by Richard Levy on 20/06/2013.
//  Copyright (c) 2013 RML. All rights reserved.
//

#import "SecondViewController.h"
#import "Pomodoro.h"
#import "SimplePomodoroTimer.h"
#import <AudioToolbox/AudioServices.h>
#import <QuartzCore/QuartzCore.h>

@interface SecondViewController ()

@end


@implementation SecondViewController {
    Pomodoro *workPomodoroTimer;
    Pomodoro *restPomodoroTimer;
    
    SystemSoundID finishedPomodoroSound;
    SystemSoundID finishedRestSound;
    SystemSoundID windSound;
    
    int keyTextCounter;
    int rulesTextCounter;
    BOOL keyAnimationRunning;
    
    UIFont *rulesTitleFont;
    UIFont *rulesMainFont;
    
}

@synthesize roundView = _roundView;
@synthesize timerSeparatorLabel = _timerSeparatorLabel;
@synthesize timerMinutesLabel = _timerMinutesLabel;
@synthesize timerSecondsLabel = _timerSecondsLabel;
@synthesize keyLabel = _keyLabel;
@synthesize timer = _timer;
@synthesize pieClock = _pieClock;
@synthesize sliceColors = _sliceColors;
@synthesize keyTexts = _keyTexts;
@synthesize rulesTexts = _helpTexts;;
@synthesize rulesTextLabel = _rulesTextLabel;
@synthesize timeTypeLabel = _timeTypeLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Create a pomodoro with a 1 second interval timer
    SimplePomodoroTimer *localTimer = [[SimplePomodoroTimer alloc]init];
    localTimer.interval = @(1);
    
    // Need a separate timer because it calls the pomodoro that it's in - so it can't be in 2!
    SimplePomodoroTimer *restTimer = [[SimplePomodoroTimer alloc]init];
    restTimer.interval = @(1);

    workPomodoroTimer = [[Pomodoro alloc]initWithTimer:localTimer];
    // We're interested in changes
    workPomodoroTimer.timeObserver=self;
    
    restPomodoroTimer = [[Pomodoro alloc]initWithTimer:restTimer];
    restPomodoroTimer.timeObserver=self;
    
    [self resetPomodoroToReady];

    NSURL *windAudioFile = [[NSBundle mainBundle] URLForResource:@"bell_style_alarm_clock_wind_up" withExtension:@"caf"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)windAudioFile, &windSound);
    
    // Play the winding sound, because the winding will appear to be triggered the first time this view is loaded
    AudioServicesPlaySystemSound(windSound);

    NSURL *finishedPomodoroAudioFile = [[NSBundle mainBundle] URLForResource:@"alarm_clock_bell_ringing" withExtension:@"caf"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)finishedPomodoroAudioFile, &finishedPomodoroSound);

    NSURL *finishedRestAudioFile = [[NSBundle mainBundle] URLForResource:@"alarm_clock_bell_ringing" withExtension:@"caf"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)finishedRestAudioFile, &finishedRestSound);

    // Begin button background colour images
    UIImage *startStopImage = [[UIImage imageNamed:@"beginButton.png"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(50, 1, 50, 1)];
    UIImage *startStopImageHighlight = [[UIImage imageNamed:@"beginButtonPressed.png"]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    
    // Set the background for any states you plan to use
    [_startStopButton setBackgroundImage:startStopImage forState:UIControlStateNormal];
    
    [_startStopButton setBackgroundImage:startStopImageHighlight forState:UIControlStateHighlighted];
    
    [self.pieClock setDelegate:nil];
    [self.pieClock setDataSource:self];
    [self.pieClock setPieCenter:CGPointMake(140, 145)];
    [self.pieClock setShowPercentage:YES];
    [self.pieClock setLabelColor:[UIColor blackColor]];
    [self.pieClock setPieRadius:140];
    
    [self.roundView.layer setCornerRadius:90];
    
    // Radtac colours -
    // Green/Culture (in place of red) - #72A84F
    // Yellow/Consulting - #f9b022
    // Purpleeee/Delivery) - #9e62ac
    // Light blue/Training - #27bae0
    self.sliceColors =[NSArray arrayWithObjects:
                       UIColorFromRGB(0x72A84F), UIColorFromRGB(0x27bae0), UIColorFromRGB(0xf9b022), UIColorFromRGB(0x9e62ac), nil];
    
    // Ensure these are in the same order as the colours above
    self.keyTexts = [NSArray arrayWithObjects:@"Work time elapsed", @"Work time remaining", @"Rest time elaspsed", @"Rest time remaining", nil];

    self.rulesTexts = [NSArray arrayWithObjects:
                      @"The Pomodoro Technique",
                      @"Choose a task to work on",
                      @"Start the timer",
                      @"Work only on the chosen task",
                      @"When the timer ends, take a short break",
                      @"..or a longer break if its the 4th time", nil];
    
    self->keyTextCounter=0;
    self->rulesTextCounter=0;
    
    // Use a title font in the rules fader
    self->rulesMainFont = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:17];
    self->rulesTitleFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
    self.rulesTextLabel.font = self->rulesTitleFont;
    
    self->keyAnimationRunning=NO;
    
    // Hide the key field if it's not iPhone 5
    if (![self isDeviceIPhone5]){
        self.keyLabel.hidden=YES;
    }
    
    [self startRulesAnimation];
}

-(BOOL)isDeviceIPhone5 {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && [[UIScreen mainScreen] bounds].size.height==568);
}

-(void)viewWillAppear:(BOOL)animated{
    [self.pieClock reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    // For shake detection
    [self becomeFirstResponder];
    
    if (![self isDeviceIPhone5]){
        [self moveElementsForIPhone4];
    }
    [self clearBadge];
}

-(void)setFinishedBadge {
    BOOL imActive = self.tabBarController.selectedIndex == 1;
    
    // If we're NOT the active tab
    if (!imActive) {
        UITabBarItem *tbi = (UITabBarItem*)[[[self.tabBarController tabBar] items] objectAtIndex:1];
        [tbi setBadgeValue:@"!"];
    }
}

-(void)clearBadge {
    UITabBarItem *tbi = (UITabBarItem*)[[[self.tabBarController tabBar] items] objectAtIndex:1];
    [tbi setBadgeValue:nil];
}

-(void)moveElementsForIPhone4{
    // Move the pie
    [self moveUIElement:self.pieClock byDelta:CGPointMake(0, -30)];
    // Move the rules label
    [self moveUIElement:self.rulesTextLabel byDelta:CGPointMake(0,-12)];
}

-(void)moveUIElement:(UIView *)element byDelta:(CGPoint) delta{
    CGRect movement = CGRectMake(element.frame.origin.x+delta.x, element.frame.origin.y+delta.y, element.frame.size.width, element.frame.size.height);
    [element setFrame:movement];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)startStopTapped:(id)sender{    
    if (workPomodoroTimer.active){
        [self stopPomodoro];
    } else {
        [self startPomodoro];
        [self startKeyFadingAnimations];
    }
}

-(void)startPomodoro {
    [self resetPomodoroToReady];
    [self.startStopButton setTitle:@"CANCEL" forState:UIControlStateNormal];

    self.timeTypeLabel.text=@"Task time";

    [workPomodoroTimer start];
}

-(void)stopPomodoro {
    [workPomodoroTimer stop];
    [restPomodoroTimer stop];
    [self.startStopButton setTitle:@"RESTART" forState:UIControlStateNormal];
}

-(void)resetPomodoroToReady{
    // If the timer has been started at some point
    if (workPomodoroTimer.totalTime!=workPomodoroTimer.timeRemaining){
        AudioServicesPlaySystemSound(windSound);        
    }
    [restPomodoroTimer windTo:@(5*60)];
    [workPomodoroTimer windTo:@(25*60)];

    // Time type label empty to begin with
    self.timeTypeLabel.text=@"";

    [self.startStopButton setTitle:@"BEGIN" forState:UIControlStateNormal];
}

-(void)updateTimeWithValue:(NSNumber *)timeValue {
    NSString *minutesTimeString = [self formatCountdownStringMinutes:timeValue];
    NSString *secondsTimeString = [self formatCountdownStringSeconds:timeValue];
    [self updateTimeLeftMinutes:minutesTimeString seconds:secondsTimeString];
}

#pragma mark TimeObserverMethods
-(void)timeChanged:(id)sender {
    NSNumber* timeRemaining;
    if (sender==restPomodoroTimer) {
        timeRemaining = restPomodoroTimer.timeRemaining;
    } else {
        // Assume its the rest timer - thats the only other thing that can call this
        timeRemaining = workPomodoroTimer.timeRemaining;
    }
    [self updateTimeWithValue:timeRemaining];
    
    [self.pieClock reloadData];
}

-(void)finished:(id)sender {
    if (sender==workPomodoroTimer){
        AudioServicesPlaySystemSound(finishedPomodoroSound);
        // Update display with initial time
        [self updateTimeWithValue:[restPomodoroTimer timeRemaining]];

        self.timeTypeLabel.text=@"Rest time";

        [restPomodoroTimer start];
    } else {
        AudioServicesPlaySystemSound(finishedRestSound);
        [self.startStopButton setTitle:@"BEGIN" forState:UIControlStateNormal];
        self.timeTypeLabel.text=@"Pomodoro finished";
    }
    [self setFinishedBadge];
    
    [self.pieClock reloadData];
}

#pragma mark time display methods
-(NSString *)formatCountdownStringMinutes:(NSNumber *)timeRemaining {
    double remaining = [timeRemaining intValue];
    int minutes = floor(remaining/60);
    
    return [self formatTimebaseNumber:minutes];
}

-(NSString *)formatCountdownStringSeconds:(NSNumber *)timeRemaining {
    double remaining = [timeRemaining intValue];
    int minutes = floor(remaining/60);
    int seconds = round(remaining-minutes * 60);
    
    return [self formatTimebaseNumber:seconds];
    
}

-(NSString *)formatTimebaseNumber:(int)number{
    
    if (number < 10){
        return [[NSString alloc]initWithFormat:@"0%d", number];
    } else {
        return [[NSString alloc]initWithFormat:@"%d", number];
    }
    
}

-(void)updateTimeLeftMinutes:(NSString *)minutes seconds:(NSString *)seconds{
    self.timerMinutesLabel.text=minutes;
    self.timerSecondsLabel.text=seconds;
}

#pragma mark XYPie delegate methods
- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart{
    // Hard coded at the moment - will include a rest-timer soon
    return 4;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index{
    int value=0;
    
    if (index==0){
        // Time taken
        value = [workPomodoroTimer.totalTime intValue]-[workPomodoroTimer.timeRemaining intValue];
    } else if (index==1){
        // Time remaining
        value = [workPomodoroTimer.timeRemaining intValue];
    } else if (index==2){
        // Rest taken
        value=[restPomodoroTimer.totalTime intValue] - [restPomodoroTimer.timeRemaining intValue];
    } else if (index==3) {
        value=[restPomodoroTimer.timeRemaining intValue];
    }
    // Return as percentage
    return (100.0/([restPomodoroTimer.totalTime intValue] +[workPomodoroTimer.totalTime intValue]))*value;
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index{
    return [self.sliceColors objectAtIndex:index];
}

#pragma mark animation related
-(void)startRulesAnimation{
    self->rulesTextCounter=0;
    [self fadeUpRuleText];
}

-(void)fadeUpRuleText{
    self.rulesTextLabel.text = [self.rulesTexts objectAtIndex:self->rulesTextCounter];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(fadeOutRuleText:finished:context:)];
    [UIView setAnimationDuration:2.0];
    [self.rulesTextLabel setAlpha:1];
    [UIView commitAnimations];
    
}

-(void)fadeOutRuleText:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:2.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(nextRuleTextAnimation:finished:context:)];
    [self.rulesTextLabel setAlpha:0];
    [UIView commitAnimations];
    
}

-(void)nextRuleTextAnimation:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
        self->rulesTextCounter++;
        if (self->rulesTextCounter >= self.rulesTexts.count){
            self->rulesTextCounter=0;
            // First element is the title, so switch the font to the title font
            self.rulesTextLabel.font = self->rulesTitleFont;
        } else {
            // Non title font
            self.rulesTextLabel.font = self->rulesMainFont;
        }
        [self fadeUpRuleText];
}

-(void)startKeyFadingAnimations{
    if (!self->keyAnimationRunning) {
        self->keyTextCounter=0;
        
        self->keyAnimationRunning=YES;
        [self fadeUpKeyText];
    }
}

-(void)fadeUpKeyText{
    self.keyLabel.text = [self.keyTexts objectAtIndex:self->keyTextCounter];
    self.keyLabel.backgroundColor=[self.sliceColors objectAtIndex:self->keyTextCounter];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(fadeOutKeyText:finished:context:)];
    [UIView setAnimationDuration:2.5];
    [self.keyLabel setAlpha:1];
    [UIView commitAnimations];
}

//This delegate is called after the completion of Animation.
-(void)fadeOutKeyText:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:2.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(nextKeyTextAnimation:finished:context:)];
    [self.keyLabel setAlpha:0];
    [UIView commitAnimations];    
}

-(void)nextKeyTextAnimation:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    // Check if the clock is still running - only move to next if running
    if (self->workPomodoroTimer.active || self->restPomodoroTimer.active){
        self->keyTextCounter++;
        if (self->keyTextCounter >= self.keyTexts.count){
            self->keyTextCounter=0;
        }
        [self fadeUpKeyText];
    } else {
        self->keyAnimationRunning=NO;
    }
}

#pragma mark Shake It!
-(BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    // If shake detected
    if (motion == UIEventSubtypeMotionShake) {
        // And not active
        if (!self->workPomodoroTimer.active && !self->workPomodoroTimer.active){
            [self resetPomodoroToReady];
        }
    }
}

@end
