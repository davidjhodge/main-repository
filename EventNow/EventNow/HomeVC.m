//
//  HomeVC.m
//  EventNow
//
//  Created by David Hodge on 12/29/14.
//  Copyright (c) 2014 Genesis Apps, LLC. All rights reserved.
//

#import "HomeVC.h"
#import "AppDelegate.h"
#import "Item+Create.h"
#import "UIImageEffects.h"

@interface HomeVC ()

@property (nonatomic) double total;
@property (nonatomic, strong) NSArray *industryArray;
@property (nonatomic, strong) UIBarButtonItem *totalButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.navigationItem.title = @"EventNow";
    UIImage *titleImage = [UIImage imageNamed:@"Map-Pin_0000_Map-Pin-Blur.png"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:titleImage];
    
    //Total Button. Checkout Button is built in storyboard
    self.totalButton = [[UIBarButtonItem alloc] initWithTitle:@" $0.00" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.totalButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = self.totalButton;
    
    //Change seperator color and delete seperators below end of table
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.separatorInset = UIEdgeInsetsZero;
    if ([self.tableView respondsToSelector:@selector(layoutMargins)]) {
        self.tableView.layoutMargins = UIEdgeInsetsZero;
    }

    self.industryArray = [self createArrayOfInustries];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //UIImage *image = [self takeSnapshotOfView:self.blurImageView];
    //[self blurWithImageEffects:image];
    
    [self setTotal];
}

-(void)setTotal
{
    AppDelegate *aD = [UIApplication sharedApplication].delegate;
    self.totalButton.title = [Item getPriceStringFromDouble:aD.price];
    self.navigationItem.leftBarButtonItem = self.totalButton;
}
/*
#pragma mark - Background Blur

- (UIImage *)blurWithImageEffects:(UIImage *)image
{
    return [UIImageEffects imageByApplyingBlurToImage:image withRadius:30 tintColor:[UIColor colorWithWhite:1 alpha:0.2] saturationDeltaFactor:1.5 maskImage:nil];

}
*/

#warning This is not used anymore. Item+Create implements this as a class method
/*
//Formats a double in price format.
-(NSString *)getPriceStringFromDouble:(double)aDouble
{
    NSNumber *number = [NSNumber numberWithDouble:aDouble];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSString *groupingSeperator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
    [formatter setGroupingSeparator:groupingSeperator];
    [formatter setGroupingSize:3];
    [formatter setAlwaysShowsDecimalSeparator:NO];
    [formatter setUsesGroupingSeparator:YES];
    
    return [NSString stringWithFormat:@" %@",[formatter stringFromNumber:number]];
}
*/
-(NSArray *)createArrayOfInustries
{
    Industry *transportation = [Industry industryWithTitle:@"Transportation"
                                                  iconName:@"136-tractor.png"
                                           segueIdentifier:@"TransportationSegue"];
    
    Industry *food = [Industry industryWithTitle:@"Food"
                                        iconName:@"48-fork-and-knife.png"
                                 segueIdentifier:@"FoodSegue"];
    
    Industry *drinks = [Industry industryWithTitle:@"Drinks"
                                          iconName:@"144-martini.png"
                                   segueIdentifier:@"DrinksSegue"];

    
    Industry *hotels = [Industry industryWithTitle:@"Hotels & Lodging"
                                          iconName:@"53-house"
                                   segueIdentifier:@"HotelsSegue"];
    
    Industry *guestList = [Industry industryWithTitle:@"Guest List"
                                             iconName:@"112-group.png"
                                      segueIdentifier:@"GroupSegue"];
    
    NSArray *array = @[transportation, food, drinks, hotels, guestList];
    
    return array;
}

#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"IndustryCell";
    IndustryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    Industry *industry = [self.industryArray objectAtIndex:indexPath.row];
    cell.iconImageView.image = [UIImage imageNamed:industry.icon];
    //cell.imageView.contentMode = UIViewContentModeCenter;
    cell.titleLabel.text = industry.title;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.industryArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Industry *industry = [self.industryArray objectAtIndex:indexPath.row];
    
    //self.selectedIndexPath = indexPath;
    
    [self performSegueWithIdentifier:industry.segueIdentifier sender:self];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"TransportationSegue"]) {
    
    }
}

@end
