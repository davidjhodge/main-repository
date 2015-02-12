//
//  CreateEventSpecificsVC.m
//  OrganizeNow
//
//  Created by David Hodge on 1/7/15.
//  Copyright (c) 2015 Genesis Apps, LLC. All rights reserved.
//

//Make table view with two sections for title and description

#import "CreateEventSpecificsVC.h"
#import "EventAttributeCell.h"

@interface CreateEventSpecificsVC () <UIPickerViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSArray *eventAttributes;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextField;
@property (strong, nonatomic) UITextField *navBarTextField;

@end

@implementation CreateEventSpecificsVC


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.eventAttributes = @[@"Title", @"Start Time", @"End Time", @"Description"];
    
    //Title Text Field
    [self configureTextField:self.titleTextField];
    [self.titleTextField becomeFirstResponder];
    
    //Description Text Field
    [self.descriptionTextField setSelectable:YES];
    
    //TGR to resign text Field
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(returnTap)];
    [self.view addGestureRecognizer:tgr];
    
    [self createNavBarTextField];
}

-(void)createNavBarTextField
{
    //Customize Nav Bar Title
    _navBarTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 170, 40)];
    _navBarTextField.font = [UIFont fontWithName:@"GillSans-Light" size:20];
    _navBarTextField.tintColor = [UIColor whiteColor];
    _navBarTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _navBarTextField.enabled = NO;
    [_navBarTextField addTarget:self
                         action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    
    _navBarTextField.text = self.titleTextField.placeholder;
    self.navigationItem.titleView = _navBarTextField;
}

-(IBAction)textFieldDidChange:(id)sender
{
    _navBarTextField.text = self.titleTextField.text;
    self.navigationItem.titleView = _navBarTextField;
}

- (void)returnTap
{
    [self.view endEditing:YES];
}

- (void)configureTextField:(UITextField *)textField
{
    textField.text = nil;
    textField.delegate = self;
    NSString *placeholderText = @"Hangout at David's";
    UIColor *color = [UIColor lightTextColor];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderText attributes:@{NSForegroundColorAttributeName: color}];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
