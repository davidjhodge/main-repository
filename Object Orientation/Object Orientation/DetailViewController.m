//
//  DetailViewController.m
//  Object Orientation
//
//  Created by David Hodge on 10/13/14.
//  Copyright (c) 2014 Genesis Apps, LLC. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"

@interface DetailViewController () <UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *engineTextField;
@property (weak, nonatomic) IBOutlet UITextField *colorTextField;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

/*
-(void)engine:(NSString *)aEngineType color:(NSString *)aColor
{
}*/

- (IBAction)submit:(id)sender {
    //[self engine:self.engineTextField.text color:self.colorTextField.text];
    
    ViewController *vc = (ViewController *)[[UIApplication sharedApplication] keyWindow].rootViewController;
    vc.engineType = self.engineTextField.text;
    vc.color = self.colorTextField.text;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TextField Delegates

// This method enables or disables the processing of return key
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Tap Gesture

- (void)handleTap:(UIGestureRecognizer *)recognizer
{
    [self.engineTextField endEditing:YES];
}

@end
