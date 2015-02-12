//
//  InviteContactsVC.m
//  OrganizeNow
//
//  Created by David Hodge on 1/7/15.
//  Copyright (c) 2015 Genesis Apps, LLC. All rights reserved.
//

#import "InviteContactsVC.h"
#import "ContactCell.h"
#import "Person.h"

@interface InviteContactsVC ()

@property (nonatomic, strong) NSMutableArray *personArray;
@property (nonatomic, strong) NSArray *searchResults;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *sections;

@end

@implementation InviteContactsVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadContactsWithPermission];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Review" style:UIBarButtonItemStylePlain target:self action:@selector(segueToReview)];
}

-(void)segueToReview
{
    [self performSegueWithIdentifier:@"ShowReviewVC" sender:self];
}

-(void)createIndexDictionary
{
    BOOL found;
    
    // Loop through the books and create our keys
    for (NSDictionary *contact in self.personArray)
    {
        NSString *c = [[contact objectForKey:@"title"] substringToIndex:1];
        
        found = NO;
        
        for (NSString *str in [self.sections allKeys])
        {
            if ([str isEqualToString:c])
            {
                found = YES;
            }
        }
        
        if (!found)
        {
            [self.sections setValue:[[NSMutableArray alloc] init] forKey:c];
        }
    }
    
    for (NSDictionary *contact in self.personArray)
    {
        [[self.sections objectForKey:[[contact objectForKey:@"title"] substringToIndex:1]] addObject:contact];
    }
    
    // Sort each section array
    for (NSString *key in [self.sections allKeys])
    {
        [[self.sections objectForKey:key] sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]]];
    }
}

#pragma mark - Search

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
#warning predicate is incorrect. somehow we must sort by the person's full name
    NSPredicate *firstNamePredicate = [NSPredicate
                                    predicateWithFormat:@"firstName like[cd] %@",
                                    searchText];
    
    NSPredicate *lastNamePredicate = [NSPredicate predicateWithFormat:@"lastName like[cd] %@", searchText];
    
    NSPredicate *fullNamePredicate = [NSCompoundPredicate orPredicateWithSubpredicates:[NSArray arrayWithObjects:firstNamePredicate, lastNamePredicate, nil]];

    
    _searchResults = [_personArray filteredArrayUsingPredicate:fullNamePredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

#pragma mark - Load Contacts

-(void)loadContactsWithPermission
{
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied ||
        ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted){
        
        NSLog(@"The user needs to change app permissions to access the address book.");
        
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        self.personArray = [self getContactsFromAddressBook];
        
    } else{ //ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined
        ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error) {
            if (!granted){
                NSLog(@"User denied Address Book Permission.");
                return;
            }
            self.personArray = [self getContactsFromAddressBook];
        });
    }
}
#warning gets entire address book everytime you load. should do some caching/checking
-(NSMutableArray *)getContactsFromAddressBook
{
    /*
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    NSArray *contactsRef = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
     */
    
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonSortByLastName);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    
    NSMutableArray *allContacts = [NSMutableArray arrayWithCapacity:nPeople];
    
    if (addressBook != nil)
    {
        int nullCounter = 0;
        for (int i = 0; i < nPeople; i++)
        {
            Person *person = [[Person alloc] init];

            ABRecordRef contactPerson = CFArrayGetValueAtIndex(allPeople,i);
            
            NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson,kABPersonFirstNameProperty);
            if (firstName != nil) {
                person.firstName = firstName;
            } else {
                person.firstName = @"";
            }
            
            NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
            if (lastName != nil) {
                person.lastName = lastName;
            } else {
                person.lastName = @"";
            }

            //NSString *phoneNumber = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
            //person.phoneNumber = phoneNumber;
            if (firstName != nil && lastName != nil)
            {
                [allContacts addObject:person];
            } else
            {
                nullCounter++; //to delete extraneous space
            }
        }
        //Delete extraneous space
        for (int i = 0; i < nullCounter; i++)
        {
            //[allContacts removeLastObject];
        }
    }
    return allContacts;
}

#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
    
    //Configure Cell in different method
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(ContactCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Person *person = [[Person alloc] init];
    if (self.tableView == self.searchDisplayController.searchResultsTableView)
    {
        person = [self.searchResults objectAtIndex:indexPath.row];
    } else {
        person = [self.personArray objectAtIndex:indexPath.row];
    }
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@",person.firstName, person.lastName];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    //return [[self.sections allKeys] count];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return self.searchResults.count;
    } else {
        return self.personArray.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

}



@end
