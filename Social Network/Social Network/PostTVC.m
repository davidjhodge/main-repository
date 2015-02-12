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

static NSString * const PostCellIdentifer = @"PostCell";

@interface PostTVC ()

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
    
     //NSLog(@"CreatedBy: %@, Content: %@, CreatedAt: %@, Likes: %@", post.createdBy, post.content, [self stringFromDate:[post createdAt]], [post.likes stringValue]);
    
    //Perhaps set what happens when you press the like button
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    //return 159;
    return [self heightForBasicCellAtIndexPath:indexPath];
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
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *postDate = [formatter dateFromString:date];
    
    NSTimeInterval distanceBetweenDates = [now timeIntervalSinceDate:postDate];
    
    NSInteger secondsBetweenDates = distanceBetweenDates;
    NSInteger minutesBetweenDates = distanceBetweenDates/SECONDS_IN_A_MINUTE;
    NSInteger hoursBetweenDates = distanceBetweenDates/SECONDS_IN_A_HOUR;
    NSInteger daysBetweenDates = distanceBetweenDates/SECONDS_IN_A_DAY;
    NSInteger weeksBetweenDates = distanceBetweenDates/SECONDS_IN_A_WEEK;

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


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self performSegueWithIdentifier:@"ShowDetail" sender:self];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ShowDetail"]) {
        
        NSIndexPath *indexPath = nil;
        
        if ([sender isKindOfClass:[PostCell class]]) {
            indexPath = [self.tableView indexPathForCell:sender];
        }
        
        Post *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        DetailTVC *vc = (DetailTVC *)[segue destinationViewController];
        vc.createdBy = post.createdBy;
        vc.content = post.content;
        vc.createdAt = post.createdAt;
        vc.likes = [post.likes stringValue];
        
    }
}

@end
