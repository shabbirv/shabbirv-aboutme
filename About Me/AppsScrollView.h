//
//  AppsScrollView.h
//  About Me
//
//  Created by Shabbir Vijapura on 4/26/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AvatarView.h"
#import "RandomFactTextView.h"
#import "WebViewController.h"
#import <MessageUI/MessageUI.h>

@interface AppsScrollView : UIView <UIScrollViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate> {
    int currentPage;
    UIScrollView *scroll;
    UIPageControl *pageControl;
    UILabel *nameLabel;
    RandomFactTextView *rTextView;
}

@property (nonatomic, weak) id appScrollDelegate;
@property (nonatomic, assign) NSArray *appIds;
@property (nonatomic, assign) BOOL buttonsShown;

- (void)scrollToPage:(int) page;
- (void)meAction;

@end
