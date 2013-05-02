//
//  ViewController.h
//  About Me
//
//  Created by Shabbir Vijapura on 4/26/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "UIImage+BlurredImage.h"

@class AboutMeView;
@class AvatarView;
@class AppsScrollView;

@interface ViewController : UIViewController <AboutMeEngineDelegate, UITableViewDataSource, UITableViewDelegate, SKStoreProductViewControllerDelegate> {
    IBOutlet UIImageView *backgroundImageView;
    IBOutlet AboutMeView *aboutView;
    AppsScrollView *appScroll;
}

- (void)didTapIconView:(AvatarView *) iconView;
- (void)aboutMePageChangedTo:(int) page;
@end
