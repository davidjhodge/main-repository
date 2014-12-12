//
//  SuperMyPostsTVC.m
//  Social Network
//
//  Created by David Hodge on 11/15/14.
//  Copyright (c) 2014 Genesis Apps, LLC. All rights reserved.
//

#import "SuperMyPostsTVC.h"
#import "PostCell.h"
#import "Post.h"
#import "Post+Database.h"
#import "DetailTVC.h"
#import "AmazonFetcher.h"

@implementation SuperMyPostsTVC

-(void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    if (managedObjectContext) {
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Post"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO]];
        request.predicate = nil; //All new posts
        
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
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    
    //Configure Cell in different method
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(PostCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Post *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.createdByLabel.text = post.createdBy;
    cell.contentLabel.text = post.content;
    cell.createdAtLabel.text = post.createdAt;
    cell.likesLabel.text = [post.likes stringValue];
    
    //NSLog(@"CreatedBy: %@, Content: %@, CreatedAt: %@, Likes: %@", post.createdBy, post.content, [self stringFromDate:[post createdAt]], [post.likes stringValue]);
    
    //Perhaps set what happens when you press the like button
}

- (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    //Optionally for time zone conversions
    //[formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
    
    NSString *stringFromDate = [formatter stringFromDate:date];
    
    return stringFromDate;
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
        vc.createdAt = [self stringFromDate:[post createdAt]];
        vc.likes = [post.likes stringValue];
        
    }
}

@end

