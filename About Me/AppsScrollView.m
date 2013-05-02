//
//  AppsScrollView.m
//  About Me
//
//  Created by Shabbir Vijapura on 4/26/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import "AppsScrollView.h"

#define ICON_H_W 120
#define TAG_BUFFER 100

@implementation AppsScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //Init
        self.clipsToBounds = NO;

        scroll = [[UIScrollView alloc] initWithFrame:self.bounds];
        scroll.delegate = self;
        scroll.showsHorizontalScrollIndicator = NO;
        scroll.pagingEnabled = TRUE;
        [self addSubview:scroll];
        
        //Add Page Control to bottom of the page
        pageControl = [[UIPageControl alloc] init];
        pageControl.frame = CGRectMake(0, self.frame.size.height - 20, 320, 20);
        [pageControl addTarget:self action:@selector(tappedDot:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:pageControl];
        
        //Name of app underneath icon
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 130, 320, 21)];
        nameLabel.text = @"Shabbir Vijapura";
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font = [UIFont fontWithName:@"AvenirNext-Bold" size:14];
        [nameLabel setMinimumScaleFactor:0.7f];
        [nameLabel setAdjustsFontSizeToFitWidth:YES];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.shadowColor = [UIColor blackColor];
        nameLabel.shadowOffset = CGSizeMake(0, 1);
        [self addSubview:nameLabel];
        
        rTextView = [[RandomFactTextView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 100, 320, 150)];
        rTextView.text = @"22 year old that has spent over 4 amazing years developing for iOS";
        [self addSubview:rTextView];
        
        //Add First Icon which is my own avatar
        int xPos = (self.frame.size.width - ICON_H_W)/2;
        AvatarView *iconView = [[AvatarView alloc] initWithFrame:CGRectMake(xPos, 70, ICON_H_W, ICON_H_W)];
        iconView.image = [UIImage imageNamed:@"avatar"];
        iconView.tag = TAG_BUFFER;
        [iconView addTarget:self action:@selector(meAction) forControlEvents:UIControlEventTouchUpInside];
        [scroll addSubview:iconView];
        
        //Start heartbeat motion
        [self zoomInOutViewAtPage:0];
    }
    return self;
}

- (void)setAppIds:(NSArray *)appIds {
    _appIds = appIds;
    
    //Set page control number of pages add one for my avatar
    pageControl.numberOfPages = appIds.count + 1;
    
    //Initial X-position
    int xPos = (self.frame.size.width - ICON_H_W)/2;
    int pageNumber = 0;
    
    //Create an app icon view for each app id
    for (NSString *appId in appIds) {
        //Make sure icon is in the middle of the next page
        xPos+=(((self.frame.size.width - ICON_H_W)/2) * 2) + ICON_H_W;
        pageNumber++;
        
        AvatarView *iconView = [[AvatarView alloc] initWithFrame:CGRectMake(xPos, 70, ICON_H_W, ICON_H_W)];
        iconView.showsTouchWhenHighlighted = YES;
        iconView.tag = pageNumber + TAG_BUFFER;
        iconView.appId = appId;
        [scroll addSubview:iconView];
        iconView.delegate = _appScrollDelegate;
    }
    
    xPos+=(((self.frame.size.width - ICON_H_W)/2) * 2) + 20;
    scroll.contentSize = CGSizeMake(xPos, 50);
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //Calculate page number
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    //if the page hasn't changed return
    if (page == currentPage) return;
    
    currentPage = page;
    pageControl.currentPage = page;
    
    if (page == 0) { //We are on my avatar
        nameLabel.text = @"Shabbir Vijapura";
        rTextView.text = @"22 year old that has spent over 4 amazing years developing for iOS";
        
        //Stop any random fact from being populated
        [NSObject cancelPreviousPerformRequestsWithTarget:rTextView];
    } else {
        App *app = ((AvatarView *)[self viewWithTag:page + TAG_BUFFER]).app;
        [rTextView populateFactWithAppId:app.appId];
        nameLabel.text = app.name;
        
        //Dismiss buttons if they are shown
        if (_buttonsShown)
            [self meAction];
    }
}

- (void)tappedDot:(id) sender {
    [self scrollToPage:pageControl.currentPage];
}

//Scrolls to page controls current page
- (void)scrollToPage:(int) page {
    CGRect frame = scroll.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scroll scrollRectToVisible:frame animated:YES];
}

//Makes a heartbeat like animation for the app icon
-(void)zoomInOutViewAtPage:(int) page {
    AvatarView *avatarView = ((AvatarView *)[self viewWithTag:page + TAG_BUFFER]);
    
    [UIView animateWithDuration:0.9
                          delay:0.0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations: ^{
                         avatarView.transform = CGAffineTransformMakeScale(0.92, 0.92);
                     }
                     completion: ^(BOOL finished){
                         [UIView animateWithDuration:0.9
                                               delay:0.0
                                             options:UIViewAnimationOptionAllowUserInteraction
                                          animations: ^{
                                              avatarView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                          }
                                          completion: ^(BOOL finished){
                                              [self zoomInOutViewAtPage:currentPage];
                                          }];
                     }];
    
}

//Animate buttons around avatar photo
- (void)meAction {
    AvatarView *avatarView = ((AvatarView *)[self viewWithTag:TAG_BUFFER]);
    
    //Frame for buttons
    int buttonWidthHeight = 50;
    int xPos = ((avatarView.frame.origin.x + avatarView.frame.size.width)/2) + 25;
    int yPos =  ((avatarView.frame.origin.y + avatarView.frame.size.height)/2) + 10;
    int animateDistance = 110;
    
    //Add Twitter Button
    UIButton *twitterButton = (UIButton *)[scroll viewWithTag:2001];
    if (!twitterButton) {
        twitterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        twitterButton.tag = 2001;
        [twitterButton addTarget:self action:@selector(twitterAction) forControlEvents:UIControlEventTouchUpInside];
        twitterButton.frame = CGRectMake(xPos, yPos, buttonWidthHeight, buttonWidthHeight);
        [twitterButton setBackgroundImage:[UIImage imageNamed:@"twitter"] forState:UIControlStateNormal];
        [scroll insertSubview:twitterButton belowSubview:avatarView];
    }
    
    
    //Add LinkedIn Button
    UIButton *linkedInButton = (UIButton *)[scroll viewWithTag:2002];
    if (!linkedInButton) {
        linkedInButton = [UIButton buttonWithType:UIButtonTypeCustom];
        linkedInButton.tag = 2002;
        [linkedInButton addTarget:self action:@selector(linkedInAction) forControlEvents:UIControlEventTouchUpInside];
        [linkedInButton setBackgroundImage:[UIImage imageNamed:@"linkedin"] forState:UIControlStateNormal];
        linkedInButton.frame = CGRectMake(xPos, yPos, buttonWidthHeight, buttonWidthHeight);
        [scroll insertSubview:linkedInButton belowSubview:avatarView];
    }
    
    //Add Email button
    UIButton *emailButton = (UIButton *)[scroll viewWithTag:2003];
    if (!emailButton) {
        emailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        emailButton.tag = 2003;
        [emailButton addTarget:self action:@selector(mailAction) forControlEvents:UIControlEventTouchUpInside];
        [emailButton setBackgroundImage:[UIImage imageNamed:@"mail"] forState:UIControlStateNormal];
        emailButton.frame = CGRectMake(xPos, yPos, buttonWidthHeight, buttonWidthHeight);
        [scroll insertSubview:emailButton belowSubview:avatarView];
    }
    
    //Animate back and forth for buttons
    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    CGRect rect = twitterButton.frame;
    rect.origin.x = xPos + ((_buttonsShown) ? (0) : (-animateDistance));
    twitterButton.frame = rect;
    rect = linkedInButton.frame;
    rect.origin.x = xPos + ((_buttonsShown) ? (0) : (+animateDistance));
    linkedInButton.frame = rect;
    rect = emailButton.frame;
    rect.origin.y = yPos + ((_buttonsShown) ? (0) : (-100));
    emailButton.frame = rect;
    [UIView commitAnimations];
    
    _buttonsShown = !_buttonsShown;
    
}

#pragma mark Social Buttons

- (void)twitterAction {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Follow Me", @"View Tweets", nil];
    sheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [sheet showInView:self];
}

- (void)linkedInAction {
    WebViewController *web = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    [((ViewController *) _appScrollDelegate).navigationController pushViewController:web animated:YES];
    web.url = [NSURL URLWithString:@"http://linkedin.com/in/shabbirv"];
    [self meAction];
}

- (void)mailAction {
    MFMailComposeViewController *mf = [[MFMailComposeViewController alloc] init];
    [mf setToRecipients:@[@"shabbirv@gmail.com"]];
    [mf setSubject:@"RE: Your WWDC App Submission"];
    [mf setMailComposeDelegate:self];
    [((ViewController *) _appScrollDelegate) presentViewController:mf animated:YES completion:nil];
    [self meAction];
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.firstOtherButtonIndex) {
        [[Utilities sharedUtilities] follow:@"shabzcohelp"];
        [self meAction];
    }
    if (buttonIndex == actionSheet.firstOtherButtonIndex + 1) {
        WebViewController *web = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        [((ViewController *) _appScrollDelegate).navigationController pushViewController:web animated:YES];
        web.url = [NSURL URLWithString:@"http://twitter.com/shabzcohelp"];
        [self meAction];
    }
}

#pragma mark MFMailComposeDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
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
