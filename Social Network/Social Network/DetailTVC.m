//
//  DetailTVC.m
//  Social Network
//
//  Created by David Hodge on 10/19/14.
//  Copyright (c) 2014 Genesis Apps, LLC. All rights reserved.
//

#import "DetailTVC.h"
#import "PostCell.h"

@interface DetailTVC ()

@end

@implementation DetailTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"DetailTVC ViewDidLoad: %@,%@,%@,%@",self.createdBy,self.content,self.createdAt,self.likes);
}

#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    
    //Configure Cell in different method
    [self configureCell:cell atIndexPath:indexPath];
    NSLog(@"Cell Configured");

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
