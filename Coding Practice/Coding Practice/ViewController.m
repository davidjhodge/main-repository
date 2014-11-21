//
//  ViewController.m
//  Coding Practice
//
//  Created by David Hodge on 10/25/14.
//  Copyright (c) 2014 Genesis Apps, LLC. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *array = @[@5,@4,@3,@4];
    
    for (int i = 1; i < array.count; i++)
    {
        NSNumber *firstNumber = array[i-1];
        NSNumber *secondNumber = array[i];
        
        if (firstNumber > secondNumber) {
            
            NSNumber *temp = firstNumber;
            firstNumber = secondNumber;
            secondNumber = temp;
        }
    }
    
    NSLog(@"%@",array);
    












































}


@end
