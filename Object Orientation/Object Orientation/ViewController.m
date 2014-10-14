//
//  ViewController.m
//  Object Orientation
//
//  Created by David Hodge on 10/13/14.
//  Copyright (c) 2014 Genesis Apps, LLC. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *engineTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.engineType = @"V?";
    self.color = @"?color";
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self updateView];
    NSString *debug = [self toString];
    NSLog(@"%@", debug);
}

-(void)updateView{
    
    self.engineTypeLabel.text = self.engineType;
    self.colorLabel.text = self.color;
     
    NSLog(@"Engine: %@",self.engineType);
    NSLog(@"Color: %@", self.color);
}

#pragma mark - Debugging

-(NSString *)toString
{
    NSString *output = [NSString stringWithFormat:@"Engine: %@, Color:%@", self.engineType, self.color];
    
    return output;
}

@end
