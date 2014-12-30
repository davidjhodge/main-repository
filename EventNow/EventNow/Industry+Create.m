//
//  Industry+Create.m
//  EventNow
//
//  Created by David Hodge on 12/29/14.
//  Copyright (c) 2014 Genesis Apps, LLC. All rights reserved.
//

#import "Industry+Create.h"

@implementation Industry (Create)

+ (Industry *)industryWithTitle:(NSString *)title iconName:(NSString *)nameOfIcon segueIdentifier:(NSString *)segueIdentifier
{
    Industry *industry = [[Industry alloc]init];
    industry.title = title;
    industry.icon = nameOfIcon;
    industry.segueIdentifier = segueIdentifier;
    
    return industry;
}

@end
