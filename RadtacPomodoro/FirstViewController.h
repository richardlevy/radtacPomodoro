//
//  FirstViewController.h
//  RadtacPomodoro
//
//  Created by Richard Levy on 20/06/2013.
//  Copyright (c) 2013 RML. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) UIImageView *loadingImageView;
@property (nonatomic, strong) UILabel *loadingLabel;

@end
