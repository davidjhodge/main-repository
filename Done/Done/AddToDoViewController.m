//
//  AddToDoViewController.m
//  Done
//
//  Created by David Hodge on 10/15/14.
//  Copyright (c) 2014 Genesis Apps, LLC. All rights reserved.
//

#import "AddToDoViewController.h"
#import <CoreData/CoreData.h>
#import "Item.h"

@interface AddToDoViewController () <UITextFieldDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation AddToDoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    [self.view addGestureRecognizer:tgr];
    
}

-(IBAction)save:(id)sender
{
    //Helpers
    NSString *name = self.textField.text;
    
    if (name && name.length) /*If name exists and is longer than 0 chracters */ {
        //Create Entity
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:self.managedObjectContext];
        
        //Initialize Record
        Item *record = [[Item alloc]initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
        
        //Populate Record
        record.name = name;
        record.createdAt = [NSDate date];
        
        //Save Record
        NSError *error = nil;
        
        if([self.managedObjectContext save:&error])
        {
            //Dismiss VC
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            if (error) {
                NSLog(@"Could not save record.");
                NSLog(@"%@,%@",error,error.localizedDescription);
            }
            
            //Show Alert View
            [[[UIAlertView alloc]initWithTitle:@"Warning" message:@"Your To-Do could not be saved." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
        }
    } else {
        //Show Alert
        [[[UIAlertView alloc]initWithTitle:@"Warning" message:@"Your To-Do needs a name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
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
