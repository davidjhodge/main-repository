//
//  Industry+Create.h
//  EventNow
//
//  Created by David Hodge on 12/29/14.
//  Copyright (c) 2014 Genesis Apps, LLC. All rights reserved.
//

#import "Industry.h"

@interface Industry (Create)

+ (Industry *)industryWithTitle:(NSString *)title iconName:(NSString *)nameOfIcon segueIdentifier:(NSString *)segueIdentifier;

@end
