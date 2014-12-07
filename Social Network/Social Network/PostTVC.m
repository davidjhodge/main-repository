//
//  PostTVC.m
//  Social Network
//
//  Created by David Hodge on 10/19/14.
//  Copyright (c) 2014 Genesis Apps, LLC. All rights reserved.
//

#import "PostTVC.h"
#import "PostCell.h"
#import "Post.h"
#import "Post+Database.h"
#import "DetailTVC.h"
#import "AmazonFetcher.h"
#import "DemoPostTVC.h"
#import "CreateNewPostVC.h"

static NSString * const PostCellIdentifer = @"PostCell";

@interface PostTVC () <NSURLConnectionDelegate>

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) PostCell *cellToUpdateLikes;
@property (nonatomic, strong) NSMutableData *responseData;

@end

@implementation PostTVC

-(void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    if (managedObjectContext) {
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Post"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO]];
        request.predicate = nil; //All new posts
        request.fetchLimit = 100;
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
}

#pragma mark - Like Functionality

- (IBAction)LikeButton:(UIButton*)sender {
    
    //Gets the cell that the button was in
    PostCell *cell = (PostCell *)sender.superview.superview;
    self.selectedIndexPath = [self.tableView indexPathForCell:cell];

    if (cell.likesAreEnabled == YES) //LIKE
    {
        //Updates the UI to show the likes have been incremented
        NSInteger newLikes = [cell.likesLabel.text integerValue] + 1;
        cell.likesLabel.text = [NSString stringWithFormat:@"%ld", (long) newLikes];
        
        //Disables the button so the user can only like 1 time
        //sender.titleLabel.textColor = [UIColor lightTextColor];
        //sender.titleLabel.text = @"Unlike";

        [self like];
        NSLog(@"Liked");
        
        cell.likesAreEnabled = NO;
        
    } else if (cell.likesAreEnabled == NO) //UNLIKE
    {
        //Updates the UI to show the likes have decremented
        NSInteger newLikes = [cell.likesLabel.text integerValue] - 1;
        cell.likesLabel.text = [NSString stringWithFormat:@"%ld", (long) newLikes];
        
        //Re-enables the button so the user can like again if they choose
        //sender.titleLabel.textColor = [UIColor blueColor];
        //sender.titleLabel.text = @"Like";
        
        [self unlike];
        NSLog(@"Unliked");

        cell.likesAreEnabled = YES;
        
    } else
    {
        NSLog(@"Error");
    }

}

-(void)like
{
    Post *post = [self.fetchedResultsController objectAtIndexPath:self.selectedIndexPath];
    
    NSString *variablesForPHP = [NSString stringWithFormat:@"whoPosted=%@&createdAt=%@&likesOperator=",post.createdBy,post.createdAt];
    
    NSString *linkText = @"http://ec2-54-84-9-63.compute-1.amazonaws.com/php/TestServiceUpdateLikes.php?";
    linkText = [linkText stringByAppendingString:variablesForPHP];
    linkText = [linkText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    linkText = [linkText stringByAppendingString:@"%2B"];
    NSLog(@"Link Text: %@",linkText);

    NSURL *url = [NSURL URLWithString:linkText];
    NSLog(@"URL: %@",url);
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
}

-(void)unlike
{
    Post *post = [self.fetchedResultsController objectAtIndexPath:self.selectedIndexPath];
    
    NSString *variablesForPHP = [NSString stringWithFormat:@"whoPosted=%@&createdAt=%@&likesOperator=",post.createdBy,post.createdAt];
    
    NSString *linkText = @"http://ec2-54-84-9-63.compute-1.amazonaws.com/php/TestServiceUpdateLikes.php?";
    linkText = [linkText stringByAppendingString:variablesForPHP];
    linkText = [linkText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    linkText = [linkText stringByAppendingString:@"%2D"];
    NSLog(@"Link Text: %@",linkText);
    
    NSURL *url = [NSURL URLWithString:linkText];
    NSLog(@"URL: %@",url);
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
}



#pragma mark - UITableViewDataSource

//Get the post for each row from the fetched results controller
//The fetched results controller is managed in superclass of PostTVC

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:PostCellIdentifer];
    
    //Configure Cell in different method
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(PostCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Post *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.createdByLabel.text = post.createdBy;
    cell.contentLabel.text = post.content;
    cell.createdAtLabel.text = [self stringWithTimeSinceDate:post.createdAt];
    cell.likesLabel.text = [post.likes stringValue];
    
     //NSLog(@"CreatedBy: %@, Content: %@, CreatedAt: %@, Likes: %@", post.createdBy, post.content, [self stringWithTimeSinceDate:post.createdAt], [post.likes stringValue]);
    
    //Perhaps set what happens when you press the like button
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 159;
    //return [self heightForBasicCellAtIndexPath:indexPath];
}

-(CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath
{
    static PostCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:PostCellIdentifer];
    });
    
    [self configureCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell
{
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

#define SECONDS_IN_A_WEEK 604800;
#define SECONDS_IN_A_DAY 86400;
#define SECONDS_IN_A_HOUR 3600;
#define SECONDS_IN_A_MINUTE 60;

- (NSString *)stringWithTimeSinceDate:(NSString *)date
{
    NSDate *now = [NSDate date];
    
#warning This pulls the timezone from settings, not from the user's actual location

    //User TimeZone
    NSDateFormatter *localFormatter = [[NSDateFormatter alloc] init];
    [localFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *postDate = [localFormatter dateFromString:date];
    postDate = [self toLocalTime:postDate];
    
    NSTimeInterval distanceBetweenDates = [now timeIntervalSinceDate:postDate];
    
    NSInteger secondsBetweenDates = distanceBetweenDates;
    NSInteger minutesBetweenDates = distanceBetweenDates/SECONDS_IN_A_MINUTE;
    NSInteger hoursBetweenDates = distanceBetweenDates/SECONDS_IN_A_HOUR;
    NSInteger daysBetweenDates = distanceBetweenDates/SECONDS_IN_A_DAY;
    NSInteger weeksBetweenDates = distanceBetweenDates/SECONDS_IN_A_WEEK;

    NSLog(@"%ld",(long)distanceBetweenDates);
    NSString *timeSince = nil;
    
    if (secondsBetweenDates <= 60)
    {
        //seconds
        timeSince = [NSString stringWithFormat:@"%@sec",[@(secondsBetweenDates) stringValue]];
    } else if (minutesBetweenDates <= 60) {
        //minutes
        timeSince = [NSString stringWithFormat:@"%@min",[@(minutesBetweenDates) stringValue]];
    } else if (hoursBetweenDates <= 24) {
        //hours
        timeSince = [NSString stringWithFormat:@"%@hr",[@(hoursBetweenDates) stringValue]];
    } else if (daysBetweenDates < 7) {
        //days
        timeSince = [NSString stringWithFormat:@"%@d",[@(daysBetweenDates) stringValue]];
    } else {
        //weeks
        timeSince = [NSString stringWithFormat:@"%@w",[@(weeksBetweenDates) stringValue]];
    }
    
    return timeSince;
}

-(NSDate *)toLocalTime:(NSDate *)aDate
{
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate: aDate];
    return [NSDate dateWithTimeInterval: seconds sinceDate: aDate];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectedIndexPath = indexPath;
    
    [self performSegueWithIdentifier:@"ShowDetail" sender:self];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ShowDetail"]) {

        NSIndexPath *indexPath = self.selectedIndexPath;

        Post *post = [self.fetchedResultsController objectAtIndexPath:indexPath];

        DetailTVC *vc = (DetailTVC *)[segue destinationViewController];
        vc.createdBy = post.createdBy;
        vc.content = post.content;
        vc.createdAt = [self stringWithTimeSinceDate:post.createdAt];
        vc.likes = [post.likes stringValue];
        vc.selectedIndex = self.selectedIndexPath;
        vc.managedObjectContext = self.managedObjectContext;
        vc.fetchedResultsController = self.fetchedResultsController;
        
        NSLog(@"Prepare For Segue: %@,%@,%@,%@",vc.createdBy,vc.content,vc.createdAt,vc.likes);

    } else if ([segue.identifier isEqualToString:@"CreatePostSegue"])
    {
        CreateNewPostVC *cnpvc = (CreateNewPostVC *)[segue destinationViewController];
        cnpvc.managedObjectContext = self.managedObjectContext;
        cnpvc.fetchedResultsController = self.fetchedResultsController;
    }
}

#pragma mark - NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
    NSString *string = [NSString stringWithUTF8String:[_responseData bytes]];
    NSLog(@"%@",string);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"%@,%@",error,error.localizedDescription);
}

@end
