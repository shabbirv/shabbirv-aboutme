//
//  RandomFactTextView.h
//  About Me
//
//  Created by Shabbir Vijapura on 4/26/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fact.h"

@class AppsScrollView;

@interface RandomFactTextView : UITextView

- (void)populateFactWithAppId:(NSString *) appId;

@end
