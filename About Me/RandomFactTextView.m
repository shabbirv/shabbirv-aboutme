//
//  RandomFactTextView.m
//  About Me
//
//  Created by Shabbir Vijapura on 4/26/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import "RandomFactTextView.h"
#import "AppsScrollView.h"

@implementation RandomFactTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textColor = [UIColor whiteColor];
        self.font = [UIFont fontWithName:@"AvenirNext-Medium" size:14];
        self.editable = NO;
        self.backgroundColor = [UIColor clearColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)awakeFromNib {
    self.editable = NO;
}

- (void)populateFactWithAppId:(NSString *)appId {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    Fact *fact = [Fact getRandomFactWithAppId:appId];
    if (!fact) return;
    self.text = fact.factText;
    
    //Calculate how long it takes a normal person to read the text
    NSArray * words = [fact.factText componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	double duration = MAX(((double)[words count]*60.0/200.0),1);
    [self performSelector:@selector(populateFactWithAppId:) withObject:appId afterDelay:duration + 4.0];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
