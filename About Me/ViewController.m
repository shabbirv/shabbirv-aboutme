//
//  ViewController.m
//  About Me
//
//  Created by Shabbir Vijapura on 4/26/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import "ViewController.h"
#import "AboutMeView.h"
#import "AppsScrollView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    
    //Create a scroll view with lazy loaded app icons
    appScroll = [[AppsScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 330)];
    appScroll.appScrollDelegate = self;
    [self.view addSubview:appScroll];
    
    //Start loading appIds
    [self performSelector:@selector(loadAppIds) withObject:nil afterDelay:0.4];
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillDisappear:YES];
}

//Shows In-app App Store View of a particular app
- (void)didTapIconView:(AvatarView *)iconView {
    
    //Disable Buttons until SKStoreProductViewController is presented
    AppsScrollView *scroll = (AppsScrollView *)iconView.superview;
    for (UIView *view in scroll.subviews) {
        if ([view isKindOfClass:[AvatarView class]])
            ((AvatarView *)view).enabled = NO;
    }
    
    //Show activity while loading ProductView
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSDictionary *appParameters = [NSDictionary dictionaryWithObject:iconView.appId
                                                              forKey:SKStoreProductParameterITunesItemIdentifier];
    
    SKStoreProductViewController *productViewController = [[SKStoreProductViewController alloc] init];
    [productViewController setDelegate:self];
    [productViewController loadProductWithParameters:appParameters
                                     completionBlock:^(BOOL result, NSError *error)
    {
        //Make sure a positive result then present
        if (result) {
            [self presentViewController:productViewController
                               animated:YES
                             completion:nil];            
        }
        
        //Enable buttons whether or not the result is true
        for (UIView *view in scroll.subviews) {
            if ([view isKindOfClass:[AvatarView class]])
                ((AvatarView *)view).enabled = YES;
        }
        
        //Dismiss activity
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    }];
}

- (void)loadAppIds {
    [[AboutMeEngine engineWithDelegate:self] getMyAppids];
}

#pragma mark AboutMeEngineDelegate

- (void)engineDidLoadAppIds:(NSArray *)appIds {
    //Add App Icons after avatar photo
    appScroll.appIds = appIds;
}

#pragma mark SKProductViewControllerDelegate
-(void) productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) aboutMePageChangedTo:(int)page {
        switch (page) {
            case 0:
                backgroundImageView.image = [[UIImage imageNamed:@"background"] blurImageWithAmount:0.6f];
                break;
            case 1:
                backgroundImageView.image = [UIImage imageNamed:@"depaul.jpg"];
                break;
            case 2:
                backgroundImageView.image = [[UIImage imageNamed:@"background"] blurImageWithAmount:0.6f];
                [appScroll scrollToPage:0];
                if (!appScroll.buttonsShown)
                    [appScroll meAction];
                break;
        }
}

#pragma mark Rotation

-(BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
