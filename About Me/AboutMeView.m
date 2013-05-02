//
//  AboutMeScrollView.m
//  About Me
//
//  Created by Shabbir Vijapura on 4/27/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import "AboutMeView.h"

@implementation AboutMeView

#define DEPAUL_LONGITUDE -87.654806
#define DEPAUL_LATITUDE 41.923545

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    //information about myself for table
    infoArray = @[
                  @{@"title": @"Name: ", @"detail" : @"Shabbir Vijapura"},
                  @{@"title": @"Birthday: ", @"detail" : @"July 31st, 1990 [22]"},
                  @{@"title": @"School: ", @"detail" : @"Depaul University"},
                  @{@"title": @"About Me: ", @"detail" : @"Work/Experience/Skills/Interest"},
                  ];
    
    aboutMeDictionary = @{
                          
                          @"professional":
                              @[
                                  @{@"title" : @"Shabz.Co Apps (Founder/CEO)",
                                    @"detail" : @"Current iOS Developer",
                                    @"url" : @"http://shabz.co"},
                                  @{@"title" : @"Sears Corporate",
                                    @"detail" : @"Current Lead iOS Developer",
                                    @"url"  : @"http://shopyourway.com"},
                                  @{@"title" : @"Ora Interactive(Startup)",
                                    @"detail" : @"Current iOS Developer",
                                    @"url" : @"http://orainteractive.com"},
                                  @{@"title" : @"Pebble Smartwatch",
                                    @"detail" : @"Current iOS Developer",
                                    @"url" : @"http://getpebble.com"},
                                  @{@"title" : @"Crowdstar",
                                    @"detail" : @"Previous Lead iOS Developer",
                                    @"url" : @"http://crowdstar.com"},],
                          
                          @"skills":
                              @[
                                  @{@"title" : @"iOS Development"},
                                  @{@"title" : @"UI/UX Design"},
                                  @{@"title" : @"Backend Web Services"},
                                  @{@"title" : @"PHP"},
                                  @{@"title" : @"Java"},
                                  @{@"title" : @"SVN"},
                                  @{@"title" : @"Git"},
                                  @{@"title" : @"SQL"},
                                  @{@"title" : @"Agile Methodologies"}],
                          
                          @"interests":
                              @[
                                  @{@"title" : @"Watching Basketball"},
                                  @{@"title" : @"Hanging out with friends"},
                                  @{@"title" : @"Eating new things"},
                                  @{@"title" : @"Programming"},
                                  @{@"title":  @"Gymnastics"},
                                  @{@"title" : @"Cooking"}]
                          };

    //Add xib file view to self
    NSArray *screens = [[NSBundle mainBundle] loadNibNamed: @"AboutMeView" owner: self options: nil];
    if (![[screens objectAtIndex:0] isDescendantOfView:self])
        [self addSubview: [screens objectAtIndex: 0]];

    //Set Scroll size and enable paging
    scroll.contentSize = CGSizeMake(960, 0);
    scroll.pagingEnabled = YES;
    scroll.delegate = self;
    
    //Make Mapview rounded
    mapView.layer.cornerRadius = 5.0;
    mapView.layer.masksToBounds = YES;
    
    //Add annotation for Depaul University
    CLLocationCoordinate2D touchMapCoordinate = CLLocationCoordinate2DMake(DEPAUL_LATITUDE, DEPAUL_LONGITUDE);
    MKPointAnnotation *annot = [[MKPointAnnotation alloc] init];
    annot.coordinate = touchMapCoordinate;
    annot.title = @"Depaul University";
    [mapView addAnnotation:annot];
    
    //Call delegate initially to blur image
    [_delegate aboutMePageChangedTo:0];
    
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //Calculate page number
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    //if the page hasn't changed return
    if (page == currentPage) return;
    
    currentPage = page;
    //Tell delegate that the page has changed
    if ([_delegate respondsToSelector:@selector(aboutMePageChangedTo:)])
        [_delegate aboutMePageChangedTo:currentPage];
    
    //If page with map zoom so you can see current location & map annoatation
    if (page == 1) {
        //If location is not allowed don't zoom
        BOOL locationAllowed = [CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized;
        if (!locationAllowed) return;
        
        //Do this on a background thread so theres no lag on the main thread
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(concurrentQueue, ^{
            MKMapRect zoomRect = MKMapRectNull;
            for (id <MKAnnotation> annotation in mapView.annotations)
            {
                MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
                MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
                if (MKMapRectIsNull(zoomRect)) {
                    zoomRect = pointRect;
                } else {
                    zoomRect = MKMapRectUnion(zoomRect, pointRect);
                }
            }
            [mapView setVisibleMapRect:zoomRect animated:YES];
        });
    }
}

#pragma mark -

#pragma mark UITableView Delegate/Datasource

#pragma mark UITableViewDelegate
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (tableView == theTableView) return nil;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    view.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    [imageView setImage:[UIImage imageNamed:@"header.png"]];
    [view addSubview:imageView];
    imageView.alpha = 0.8;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 310, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    label.textColor = [UIColor whiteColor];
    [view addSubview:label];
    
    switch (section) {
        case 0: label.text = @"Professional Background"; break;
        case 1: label.text = @"Technical Skills"; break;
        case 2: label.text = @"Interests"; break;
    }
    
    return view;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == theTableView)
        return 0;
    else
        return 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if (tableView == theTableView)
        return 1;
    else
        return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (tableView == theTableView)
        return infoArray.count;
    else
        if (section == 0)
            return ((NSArray *) [aboutMeDictionary objectForKey:@"professional"]).count;
        else if (section == 1)
            return ((NSArray *) [aboutMeDictionary objectForKey:@"skills"]).count;
        else
            return ((NSArray *) [aboutMeDictionary objectForKey:@"interests"]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == theTableView) {
        static NSString *CellIdentifier = @"MainTable";
        const NSInteger ACCESSORY_TAG = 1001;
        
        AccessoryTableCell *cellView;
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            //Set up the cell
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.backgroundView = [[UIImageView alloc] init];
            cell.selectedBackgroundView = [[UIImageView alloc] init];
            cell.selectionStyle = (indexPath.row == 0 || indexPath.row == 1) ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleGray;

            //Set up text labels
            cell.textLabel.backgroundColor = [UIColor clearColor];
            [cell.detailTextLabel setAdjustsFontSizeToFitWidth:YES];
            [cell.detailTextLabel setMinimumScaleFactor:0.3];
            cell.detailTextLabel.backgroundColor = [UIColor clearColor];
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
            cell.textLabel.textColor = [UIColor colorWithRed:41/255.0f green:128/255.0f blue:185/255.0f alpha:1.0];
            
            cellView = [AccessoryTableCell accessoryWithColor:[UIColor whiteColor]];
            cellView.tag = ACCESSORY_TAG;
            cellView.accessoryColor = [UIColor lightGrayColor];
            cellView.highlightedColor = [UIColor whiteColor];
            cell.accessoryView =cellView;

        } else {
            cellView = (AccessoryTableCell *)[cell viewWithTag:ACCESSORY_TAG];
        }
        
        //Add Custom Grouped images
        UIImage *rowBackground;
        UIImage *selectionBackground;
        NSInteger sectionRows = [tableView numberOfRowsInSection:[indexPath section]];
        if (indexPath.row == 0) {
            rowBackground = [UIImage imageNamed:@"topRow.png"];
            selectionBackground = [UIImage imageNamed:@"topRowSelected.png"];
        }
        else if (indexPath.row == sectionRows - 1) {
            if (indexPath.section == 0) {
                rowBackground = [UIImage imageNamed:@"bottomRow.png"];
                selectionBackground = [UIImage imageNamed:@"bottomRowSelected.png"];
            } else {
                rowBackground= [UIImage imageNamed:@"bottomRow.png"];
                selectionBackground = [UIImage imageNamed:@"bottomRowSelected.png"];
            }
        }
        else {
            rowBackground = [UIImage imageNamed:@"middleRow.png"];
            selectionBackground = [UIImage imageNamed:@"middleRowSelected.png"];
        }
        
        ((UIImageView *)cell.backgroundView).image = rowBackground;        
        ((UIImageView *)cell.selectedBackgroundView).image = selectionBackground;

        NSDictionary *info = [infoArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [info objectForKey:@"title"];
        cell.detailTextLabel.text = [info objectForKey:@"detail"];
        
        BOOL showArrow = (indexPath.row == 2 || indexPath.row == 3);
        cellView.showArrow = showArrow;
        
        return cell;
    } else {
        static NSString *CellIdentifier = @"AboutMeTable";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        const NSInteger ACCESSORY_TAG = 1001;
        
        AccessoryTableCell *cellView;
        
        if (cell == nil)
        {
            //Set up the cell
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            cell.backgroundView = [[UIImageView alloc] init];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            //Set up text labels
            cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.detailTextLabel.backgroundColor = [UIColor clearColor];
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
            cell.textLabel.textColor = [UIColor colorWithRed:41/255.0f green:128/255.0f blue:185/255.0f alpha:1.0];
            
            
            cellView = [AccessoryTableCell accessoryWithColor:[UIColor whiteColor]];
            cellView.tag = ACCESSORY_TAG;
            cellView.accessoryColor = [UIColor lightGrayColor];
            cellView.highlightedColor = [UIColor whiteColor];
            cell.accessoryView =cellView;

        } else {
            cellView = (AccessoryTableCell *)[cell viewWithTag:ACCESSORY_TAG];
        }
        
        ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"blankrow"];
        
        cellView.showArrow = (indexPath.section == 0) ? YES : NO;
        
        if (indexPath.section == 0) {
            NSArray *array = ((NSArray *) [aboutMeDictionary objectForKey:@"professional"]);
            NSDictionary *dict = [array objectAtIndex:indexPath.row];
            cell.textLabel.text = [dict objectForKey:@"title"];
            cell.detailTextLabel.text = [dict objectForKey:@"detail"];
        } else if (indexPath.section == 1) {
            NSArray *array = ((NSArray *) [aboutMeDictionary objectForKey:@"skills"]);
            NSDictionary *dict = [array objectAtIndex:indexPath.row];
            cell.textLabel.text = [dict objectForKey:@"title"];
            cell.detailTextLabel.text = @"";
        } else {
            NSArray *array = ((NSArray *) [aboutMeDictionary objectForKey:@"interests"]);
            NSDictionary *dict = [array objectAtIndex:indexPath.row];
            cell.textLabel.text = [dict objectForKey:@"title"];
            cell.detailTextLabel.text = @"";
        }
        
        return cell;

        
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView == theTableView) {
        if (indexPath.row == 2) {
            [scroll setContentOffset:CGPointMake(320, 0) animated:YES];
        } else if (indexPath.row == 3) {
            //Make sure scrollViewDidScroll doesn't get called so theres no flash of Depauls image
            scroll.delegate = nil;
            [scroll performSelector:@selector(setDelegate:) withObject:self afterDelay:0.3];
            [scroll setContentOffset:CGPointMake(640, 0) animated:YES];
        }
    } else {
        if (indexPath.section == 0) {
            NSArray *array = ((NSArray *) [aboutMeDictionary objectForKey:@"professional"]);
            NSDictionary *dict = [array objectAtIndex:indexPath.row];
            WebViewController *web = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
            [((ViewController *) _delegate).navigationController pushViewController:web animated:YES];
            web.url = [NSURL URLWithString:[dict objectForKey:@"url"]];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
