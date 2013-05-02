//
//  WebViewController.h
//  About Me
//
//  Created by Shabbir Vijapura on 4/30/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate> {
    IBOutlet UIWebView *theWebView;
}

@property (nonatomic, assign) NSURL *url;

@end
