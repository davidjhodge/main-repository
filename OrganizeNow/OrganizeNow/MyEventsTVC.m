//
//  MyEventsTVC.m
//  OrganizeNow
//
//  Created by David Hodge on 1/7/15.
//  Copyright (c) 2015 Genesis Apps, LLC. All rights reserved.
//

#import "MyEventsTVC.h"
#import "EventCell.h"
#import "Event+Create.h"

@implementation MyEventsTVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"My Events";
    
    //Delete seperators below end of table
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (IBAction)createEventButtonPressed:(id)sender
{
    
}
#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventCell"];
    
    //Configure Cell in different method
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(EventCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
#warning This event does not have any data
    Event *event = [[Event alloc] init];
    //cell.nameLabel.text = event.name;
    //cell.headcountLabel.text = [NSString stringWithFormat:@"%d",event.goingCount];
    //cell.dateLabel.text = [self getMonthDayStringFromDate:event.startTime];
}

- (NSString *)getMonthDayStringFromDate:(NSDate *)aDate
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit units = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components = [calendar components:units fromDate:aDate];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    NSString *monthName = [dateFormatter.monthSymbols objectAtIndex:components.month-1];
    
    NSString *monthDayString = [NSString stringWithFormat:@"%@ %d",monthName,components.day];
    
    return monthDayString;
}

#pragma mark - UITableViewDelegate

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

@end
