//
//  AvatarView.m
//  About Me
//
//  Created by Shabbir Vijapura on 4/26/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import "AvatarView.h"
#import <QuartzCore/QuartzCore.h>

@implementation AvatarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0,2);
        self.layer.shadowRadius = 2;
        self.layer.shadowOpacity = 0.7f;
        
        //Create a spinner to show when loading app icon image
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        spinner.hidesWhenStopped = YES;
        [spinner setCenter:CGPointMake((self.frame.size.width)/2, (self.frame.size.height)/2)];
        [self addSubview:spinner];
        
        engine = [[AboutMeEngine alloc] init];
        engine.delegate = self;
    }
    return self;
}

- (void)setAppId:(NSString *)appId {
    _appId = appId;
    
    //Start loading information about Appid
    [spinner startAnimating];
    [engine loadInfoAboutAppId:appId];
}

#pragma mark AboutMeEngineDelegate

- (void)engineDidLoadAppInfo:(App *)app {
    _app = app;
    
    //Check for cached image
    UIImage *image = [[Utilities sharedUtilities] getCachedImageWithName:app.appId];
    if (image) {
        _image = image;
        [self setNeedsDisplay];
        [spinner stopAnimating];
    } else {
        //Load app icon asynchronously and once it's completed animate it
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(concurrentQueue, ^{
            _image = [UIImage imageWithData:[NSData dataWithContentsOfURL:app.artworkUrl]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[Utilities sharedUtilities] cacheImage:_image withName:app.appId];
                [self setNeedsDisplay];
                [spinner stopAnimating];
            });
        });
    }
}

- (void)setDelegate:(id)delegate {
    _delegate = delegate;
    [self addTarget:_delegate action:@selector(didTapIconView:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didTapIcon:(UITapGestureRecognizer *) gesture {
    if ([_delegate respondsToSelector:@selector(didTapIconView:)])
        [_delegate didTapIconView:self];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGRect b = self.bounds;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(ctx);

    CGPathRef circlePath = CGPathCreateWithEllipseInRect(b, 0);
    CGMutablePathRef inverseCirclePath = CGPathCreateMutableCopy(circlePath);
    CGPathAddRect(inverseCirclePath, nil, CGRectInfinite);
    
    CGContextSaveGState(ctx); {
        CGContextBeginPath(ctx);
        CGContextAddPath(ctx, circlePath);
        CGContextClip(ctx);
        [_image drawInRect:b];
    } CGContextRestoreGState(ctx);
    
    CGContextSaveGState(ctx); {
        CGContextBeginPath(ctx);
        CGContextAddPath(ctx, circlePath);
        CGContextClip(ctx);
        
        CGContextSetShadowWithColor(ctx, CGSizeMake(0, 0), 3.0f, [UIColor colorWithRed:0.994 green:0.989 blue:1.000 alpha:1.0f].CGColor);
        
        CGContextBeginPath(ctx);
        CGContextAddPath(ctx, inverseCirclePath);
        CGContextEOFillPath(ctx);
    } CGContextRestoreGState(ctx);
    
    CGPathRelease(circlePath);
    CGPathRelease(inverseCirclePath);
    
    CGContextRestoreGState(ctx);
}


@end
