//
//  TimePickerVC.m
//  OrganizeNow
//
//  Created by David Hodge on 1/11/15.
//  Copyright (c) 2015 Genesis Apps, LLC. All rights reserved.
//

//Set minimum date to 12am that day

#import "TimePickerVC.h"
#import "AppDelegate.h"

@interface TimePickerVC ()

@property (weak, nonatomic) IBOutlet UILabel *fromTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *toTextLabel;

@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation TimePickerVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureStats];
    
    self.navigationItem.title = @"What time?";
    
        UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextButtonPressed:)];
    self.navigationItem.rightBarButtonItem = nextButton;
    
    //Date Picker and Format
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [_dateFormatter setDateFormat:@"h:mm a 'on' MMMM dd"];
    [self.datePicker addTarget:self action:@selector(startDatePickerChanged:) forControlEvents:UIControlEventValueChanged];
    self.datePicker.date = [[NSDate alloc] initWithTimeIntervalSinceNow: (NSTimeInterval) 2];
    self.datePicker.minimumDate = [[NSDate alloc] initWithTimeIntervalSinceNow: (NSTimeInterval) 0];
    
    //fromLabel color init
    self.fromTextLabel.textColor = [UIColor whiteColor];

}

#warning This doesn't work
-(void)configureStats
{
    AppDelegate *aD = [UIApplication sharedApplication].delegate;
    Event *event = aD.userCreatedEvent;
    NSLog(@"Start time: %@, EndTime: %@",[self.dateFormatter stringFromDate:event.startTime],[self.dateFormatter stringFromDate:event.endTime]);
    
    if (event.startTime != nil)
    {
        self.startTimeLabel.text = [self.dateFormatter stringFromDate:event.startTime];
        [self.datePicker setDate:event.startTime];
    }
    
    if (event.endTime != nil)
    {
        self.endTimeLabel.text = [self.dateFormatter stringFromDate:event.endTime];
        [self.datePicker setDate:event.endTime];
    }
}

#pragma mark - Segmented Control

- (IBAction)indexChanged:(UISegmentedControl *)sender {
    switch (self.segmentedControl.selectedSegmentIndex)
    {
        case 0:
            
            [self.datePicker removeTarget:self action:@selector(endDatePickerChanged:) forControlEvents:UIControlEventValueChanged];
            [self.datePicker addTarget:self action:@selector(startDatePickerChanged:) forControlEvents:UIControlEventValueChanged];
            
            //Change color of labels
            self.fromTextLabel.textColor = [UIColor whiteColor];
            self.toTextLabel.textColor = [UIColor lightTextColor];
            
            break;
        case 1:
            
            [self.datePicker removeTarget:self action:@selector(startDatePickerChanged:) forControlEvents:UIControlEventValueChanged];
            [self.datePicker addTarget:self action:@selector(endDatePickerChanged:) forControlEvents:UIControlEventValueChanged];
            
            //Change color of labels
            self.fromTextLabel.textColor = [UIColor lightTextColor];
            self.toTextLabel.textColor = [UIColor whiteColor];
            
            break;
        default:
            break;
    }
}

#pragma mark- Date Picker

- (void)startDatePickerChanged:(UIDatePicker *)datePicker
{
    NSString *strDate = [self.dateFormatter stringFromDate:datePicker.date];
    self.startTimeLabel.text = strDate;
    
    AppDelegate *aD = [UIApplication sharedApplication].delegate;
    Event *event = aD.userCreatedEvent;
    event.startTime = datePicker.date;
}

- (void)endDatePickerChanged:(UIDatePicker *)datePicker
{
    NSString *strDate = [self.dateFormatter stringFromDate:datePicker.date];
    self.endTimeLabel.text = strDate;
    
    AppDelegate *aD = [UIApplication sharedApplication].delegate;
    Event *event = aD.userCreatedEvent;
    event.endTime = datePicker.date;
}

#pragma mark - Next Segue

- (IBAction)nextButtonPressed:(id)sender {
    [self checkValidDate];
}

- (void)checkValidDate
{
    AppDelegate *aD = [UIApplication sharedApplication].delegate;
    Event *event = aD.userCreatedEvent;
    
    NSComparisonResult result = [event.startTime compare:event.endTime];
    if (result == NSOrderedAscending)
    {
        [self performSegueWithIdentifier:@"NextSegue" sender:self];
    } else if (result == NSOrderedDescending)
    {
        NSString *errorMessage = @"Wait a minute, the event can't end before it starts!";
        [self showAlertViewWithMessage:errorMessage];
    } else {
        NSString *errorMessage = @"Event start and end times are equal";
        //[self showAlertViewWithMessage:errorMessage];
        [self performSegueWithIdentifier:@"NextSegue" sender:self];
    }
}

-(void)showAlertViewWithMessage:(NSString *)message
{
    NSLog(@"%@", message);
    UIAlertView *invalidDateAlert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [invalidDateAlert show];
}

@end
