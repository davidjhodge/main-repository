//
//  DetailTVC.m
//  Social Network
//
//  Created by David Hodge on 10/19/14.
//  Copyright (c) 2014 Genesis Apps, LLC. All rights reserved.
//

#import "DetailTVC.h"
#import "PostCell.h"
#import "Post.h"

@interface DetailTVC () <UIActionSheetDelegate, NSURLConnectionDelegate>

@end

@implementation DetailTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Delete Button
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteButtonPressed)];
    deleteButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = deleteButton;
}

-(void)deleteButtonPressed
{
    UIActionSheet *deleteActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Nevermind" destructiveButtonTitle:@"Delete" otherButtonTitles:nil];
    deleteActionSheet.tag = 1;
    [deleteActionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

-(void)deletePostFromServer
{
    Post *post = [self.fetchedResultsController objectAtIndexPath:self.selectedIndex];
    NSLog(@"PostIndex: %ld. PostUserID: %@",(long)self.selectedIndex.row,post.createdBy);
    
    NSString *variablesForPHP = [NSString stringWithFormat:@"whoPosted=%@&createdAt=%@",post.createdBy,post.createdAt];
    
    NSString *linkText = @"http://ec2-54-84-9-63.compute-1.amazonaws.com/php/TestServiceDeletePost.php?";
    linkText = [linkText stringByAppendingString:variablesForPHP];
    linkText = [linkText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"Link Text: %@",linkText);
    
    NSURL *url = [NSURL URLWithString:linkText];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    NSLog(@"Post Deleted From Server");
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (actionSheet.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    [self deletePostFromServer];
                    break;
                    
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    
    //Configure Cell in different method
    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

- (void)configureCell:(PostCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.createdByLabel.text = self.createdBy;
    cell.contentLabel.text = self.content;
    cell.createdAtLabel.text = self.createdAt;
    cell.likesLabel.text = self.likes;
    
    //Perhaps set what happens when you press the like button
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"%@,%@",error,error.localizedDescription);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
