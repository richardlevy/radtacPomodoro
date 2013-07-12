//
//  FirstViewController.m
//  RadtacPomodoro
//
//  Created by Richard Levy on 20/06/2013.
//  Copyright (c) 2013 RML. All rights reserved.
//

#import "FirstViewController.h"

#define LOADING_LABEL_TEXT @"Loading..."
#define ERROR_LABEL_TEXT @"There was a problem loading\nTap to retry"
#define INITIAL_WEB_URL @"http://radtac.co.uk/iosAppHome"

@interface FirstViewController ()

@end

@implementation FirstViewController {
    BOOL loadingStartPage;
}

@synthesize webView = _webView;
@synthesize loadingImageView = _loadingImageView;
@synthesize loadingLabel = _loadingLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.webView.delegate = self;
    [self reloadHome];
}

-(void)viewDidAppear:(BOOL)animated {
    int xPos = self.webView.frame.size.height /2;
    int ySize = self.webView.frame.size.width;
    
    // Create outside of storyboard, just for kicks!
    // This is a centered bar
    self.loadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,xPos-50,ySize,100)];
    self.loadingLabel.text=LOADING_LABEL_TEXT;
    self.loadingLabel.alpha=0.5;
    self.loadingLabel.backgroundColor=[UIColor purpleColor];
    self.loadingLabel.textColor=[UIColor whiteColor];
    self.loadingLabel.textAlignment=NSTextAlignmentCenter;
    // Allows multi-lines
    self.loadingLabel.numberOfLines = 0;
    
    // Add a tap detector to the label, but don't enable it.
    // This will be enabled if there's a problem loading.  Tap to retry
    self.loadingLabel.userInteractionEnabled = NO;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadHome)];
    [self.loadingLabel addGestureRecognizer:tapGesture];
}

#pragma mark webview delegate methods

- (void) webViewDidStartLoad:(UIWebView *)webView {
    // Only want to show this initially
    if (self->loadingStartPage){
        [self.view addSubview:self.loadingLabel];
    }
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    self.loadingLabel.userInteractionEnabled = NO;
    [self.loadingLabel removeFromSuperview];
    if (self->loadingStartPage){
        // Loading start page successful
        self->loadingStartPage=NO;
        // No need to display 'loading' treatment anymore
    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    self.loadingLabel.text=ERROR_LABEL_TEXT;
    self.loadingLabel.userInteractionEnabled = YES;
    [self.view addSubview:self.loadingLabel];
}

#pragma mark tap delegate

-(void)reloadHome{
    self->loadingStartPage=true;
    
    NSURL *url = [[NSURL alloc] initWithString:INITIAL_WEB_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}
@end
