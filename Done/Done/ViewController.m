//
//  ViewController.m
//  Done
//
//  Created by David Hodge on 10/15/14.
//  Copyright (c) 2014 Genesis Apps, LLC. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>
#import "ToDoCell.h"
#import "AddToDoViewController.h"
#import "UpdateToDoViewController.h"
#import "Item.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

//Batch Updates
@property (strong, nonatomic) UIBarButtonItem *checkAllButton;

@property (strong, nonatomic) NSIndexPath *selection;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Check All Button
    self.checkAllButton = [[UIBarButtonItem alloc]initWithTitle:@"Check All" style:UIBarButtonItemStylePlain target:self action:@selector(checkAll:)];
    self.navigationItem.leftBarButtonItem = self.checkAllButton;
    
    NSLog(@"%@",self.managedObjectContext);
    
    //Initialize Fetch Request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Item"];
    
    //Sort Descriptors
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:YES]]];
    
    //Initialize FetchedResultsController
    self.fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    //Configure Fetched Results Controller
    self.fetchedResultsController.delegate = self;
    
    //Perform Fetch
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    
    if (error)
    {
        NSLog(@"Unable to perform fetch.");
        NSLog(@"%@,%@",error,error.localizedDescription);
    }
}

-(void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
}

#pragma mark - Batch Updates

-(void)checkAll:(id)sender
{
    //Create Entity Description
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:self.managedObjectContext];
    
    //Initialize Batch Update Request
    NSBatchUpdateRequest *batchUpdateRequest = [[NSBatchUpdateRequest alloc]initWithEntity:entityDescription];
    
    //Configure Batch Update Request
    [batchUpdateRequest setResultType:NSUpdatedObjectIDsResultType];
    [batchUpdateRequest setPropertiesToUpdate:@{ @"done" : @YES }];
    
    //Execute Batch Request
    NSError *batchUpdateRequestError = nil;
    NSBatchUpdateResult *batchUpdateResult = (NSBatchUpdateResult *)[self.managedObjectContext executeRequest:batchUpdateRequest error:&batchUpdateRequestError];
    
    if (batchUpdateRequestError) {
        NSLog(@"Unable to execute batch update request.");
        NSLog(@"%@,%@",batchUpdateRequestError,batchUpdateRequestError.localizedDescription);
    } else {
        //Extract Object IDs
        NSArray *objectIDs = batchUpdateResult.result;
        
        for (NSManagedObjectID *objectID in objectIDs) {
            //Turn Managed Objects into Faults
            NSManagedObject *managedObject = [self.managedObjectContext objectWithID:objectID];
            
            if (managedObject) {
                [self.managedObjectContext refreshObject:managedObject mergeChanges:NO];
            }
        }
        
        //Perform fetch
        NSError *fetchError = nil;
        [self.fetchedResultsController performFetch:&fetchError];
        
        if (fetchError) {
            NSLog(@"Unable to perform fetch.");
            NSLog(@"%@,%@",fetchError,fetchError.localizedDescription);
        }
    }
}

#pragma mark - NSFetchedResultsController Delegate Methods

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type)
    {
        case NSFetchedResultsChangeInsert: {
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete: {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(ToDoCell *)[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in each section.
    NSArray *sections = self.fetchedResultsController.sections;
    id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ToDoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    //Move configuration to new method
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

-(void)configureCell:(ToDoCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    //Item is now NSManagedObject subclass
    Item *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    //Update cell
    [cell.nameLabel setText:record.name]; //Instead of [cell.nameLabel setText:[record valueForKey: "name"];
    [cell.doneButton setSelected:[record.done boolValue]];
    
    //setBlock is generated for us already
    [cell setDidTapButtonBlock:^{
        BOOL isDone = [record.done boolValue];
        
        //Update Record
        record.done = @(!isDone);
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //Store selection
    [self setSelection:indexPath];
    
    //Perform segue
    [self performSegueWithIdentifier:@"update" sender:self];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSManagedObject *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        if (record) {
            
            [self.fetchedResultsController.managedObjectContext deleteObject:record];
        }
    }
    NSLog(@"%d",editingStyle);
}

#pragma mark - Prepare for Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"add"]) {
        //Get Ref to VC
        UINavigationController *nc = (UINavigationController *)[segue destinationViewController];
        AddToDoViewController *vc = (AddToDoViewController *)[nc topViewController];
        
        //Configure VC
        [vc setManagedObjectContext:self.managedObjectContext];
        
    } else if ([segue.identifier isEqualToString:@"update"]) {
        
        //Get reference to view controller
        UpdateToDoViewController *vc = (UpdateToDoViewController *)[segue destinationViewController];
        
        //Set Managed Object Context
        [vc setManagedObjectContext:self.managedObjectContext];
        
        //If a cell is selected at an indexPath, get the corresponding record in the fetchedResultsController
        if (self.selection) {
            Item *record = [self.fetchedResultsController objectAtIndexPath:self.selection];
        
            if (record) {
                [vc setRecord:record];
            }
        
        //Reset Selection
        [self setSelection:nil];
        }
    }
}

@end
