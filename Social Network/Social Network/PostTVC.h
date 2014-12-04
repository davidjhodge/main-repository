//
//  PostTVC.h
//  Social Network
//
//  Created by David Hodge on 10/19/14.
//  Copyright (c) 2014 Genesis Apps, LLC. All rights reserved.
//

#import "CoreDataTVC.h"

@interface PostTVC : CoreDataTVC

//Specifies which objects to pull from the database
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
