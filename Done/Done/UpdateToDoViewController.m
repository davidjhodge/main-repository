//
//  UpdateToDoViewController.m
//  Done
//
//  Created by David Hodge on 10/17/14.
//  Copyright (c) 2014 Genesis Apps, LLC. All rights reserved.
//

#import "UpdateToDoViewController.h"
#import <CoreData/CoreData.h>

@interface UpdateToDoViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Item *record;

@end

@implementation UpdateToDoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.record) {
        self.textField.text = self.record.name;
    }
    
    //Tap
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    [self.view addGestureRecognizer:tgr];
}

-(void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
}

-(void)setRecord:(Item *)record
{
    _record = record;
}

- (IBAction)cancel:(id)sender {
    
    //Pop View Controller (not dismissViewController because we are in a navigation stack)
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)save:(id)sender {
    
    NSString *name = self.textField.text;
    
    if (name && name.length) {
        
        //Populate Record
        self.record.name = name;
        self.record.createdAt = [NSDate date];
        
        //Save Record
        NSError *error = nil;
        if ([self.managedObjectContext save:&error]) {
            //Record has been saved
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            if (error)
            NSLog(@"Record could not be saved.");
            NSLog(@"%@,%@",error,error.localizedDescription);
            
            [[[UIAlertView alloc]initWithTitle:@"Warning" message:@"There was an error saving your To-Do." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
        }
    } else {
        [[[UIAlertView alloc]initWithTitle:@"Warning" message:@"We didn't find any text in the text field." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
    }
}

#pragma mark - Tap

- (void) handleTapFrom: (UITapGestureRecognizer *)recognizer
{
    [self.textField resignFirstResponder];
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
