//
//  DetailTVC.h
//  Social Network
//
//  Created by David Hodge on 10/19/14.
//  Copyright (c) 2014 Genesis Apps, LLC. All rights reserved.
//

#import "CoreDataTVC.h"

@interface DetailTVC : CoreDataTVC

@property (nonatomic, strong) NSString *createdBy;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *likes;

@end
