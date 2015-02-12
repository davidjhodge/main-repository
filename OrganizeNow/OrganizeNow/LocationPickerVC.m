//
//  LocationPickerVC.m
//  OrganizeNow
//
//  Created by David Hodge on 1/13/15.
//  Copyright (c) 2015 Genesis Apps, LLC. All rights reserved.
//

#import "LocationPickerVC.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationPickerVC () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) NSArray *filteredArray;
@property (weak, nonatomic) IBOutlet UISearchBar *locationSearchBar;

@end

@implementation LocationPickerVC

#pragma mark - UITableViewDataSource

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Where at?";
    
    self.searchResults = [[NSMutableArray alloc]init];
    [self.searchResults addObject:@"Date"];
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStylePlain target:self action:@selector(searchBarSearchButtonClicked)];
    self.navigationItem.rightBarButtonItem = searchButton;
}

#pragma mark - Search

-(void)searchBarSearchButtonClicked
{
    [self.locationSearchBar resignFirstResponder];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:@"216 Sweet Gum Rd" completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            CLLocation *location = placemark.location;
            CLLocationCoordinate2D coordinate = location.coordinate;
            
            NSLog(@"%@",[NSString stringWithFormat:@"%f, %f", coordinate.latitude, coordinate.longitude]);
            
            if ([placemark.areasOfInterest count] > 0) {
                NSString *areaOfInterest = [placemark.areasOfInterest objectAtIndex:0];
                NSLog(@"Area of Interest: %@", areaOfInterest);
            } else {
                NSLog(@"No Area of Interest Was Found");
            }
        }
    }];
    
}

/*
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *predicate = [NSPredicate
                                       predicateWithFormat:@"All",
                                       searchText];
    
    _searchResults = [_filteredArray filteredArrayUsingPredicate:predicate];
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
*/


#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressCell"];
    
    //Configure Cell in different method
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.text = [self.searchResults objectAtIndex:indexPath.row];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.searchResults.count;
}

@end
