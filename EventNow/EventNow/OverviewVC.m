//
//  OverviewVC.m
//  EventNow
//
//  Created by David Hodge on 12/29/14.
//  Copyright (c) 2014 Genesis Apps, LLC. All rights reserved.
//

#import "OverviewVC.h"
#import "Item+Create.h"
#import "ItemCell.h"
#import "AppDelegate.h"
#import "Overview.h"

@interface OverviewVC ()

//Array Of Items is a publically accessible in .h
@property (nonatomic) double totalPrice;

@end

@implementation OverviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addPayPalButton];
    //PayPalPayment *currentPayment =
    
    self.navigationItem.title = @"Overview";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                   [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                   [UIFont fontWithName:@"HelveticaNeue-Medium" size:17], NSFontAttributeName, nil];
    Overview *overview = [Overview getInstance];
    self.items = overview.overviewArray;
    
    [self setTotalPrice:self.totalPrice];
}

-(void)setTotalPrice:(double)aPrice
{
    if (self.items.count > 0)
        
    for (Item *item in self.items)
    {
        aPrice += item.price;
    }
}


/*
-(void)addToCart
{
    Item *item = [Item itemWithTitle:@"Uber" price:10.43 iconImage:[UIImage imageNamed:@"27-planet.png"]];

    [self.items addObject:item];
}
*/
#pragma mark - PayPal

-(void)payWithPayPal
{
    //[PayPal checkoutWithPayment:currentPayment];
}

-(void)addPayPalButton
{
    UIButton *button = [[PayPal getPayPalInst]
                        getPayButtonWithTarget:self
                        andAction:@selector(payWithPayPal)
                        andButtonType:BUTTON_278x43
                        andButtonText:BUTTON_TEXT_PAY];
    [self.view addSubview:button];
}

//Delegate Methods

//paymentSuccessWithKey:andStatus: is required. Record the payment status
// as successful and perform associated bookkeeping. Make no UI updates.
//
//payKey is a string that uniquely identifies the transaction.
//paymentStatus is an enum: STATUS_COMPLETED, STATUS_CREATED, or STATUS_OTHER
- (void)paymentSuccessWithKey:(NSString *)payKey
                    andStatus:(PayPalPaymentStatus)paymentStatus {
    status = PAYMENTSTATUS_SUCCESS;
}

//paymentFailedWithCorrelationID:andErrorCode:andErrorMessage:
// Record the payment as failed and perform associated bookkeeping.
// Make no UI updates.
//
//correlationID is a string that uniquely identifies to PayPal the failed transaction.
//errorCode is generally (but not always) a numerical code associated with the error.
//errorMessage is a human-readable string describing the error that occurred.
/*
- (void)paymentFailedWithCorrelationID:
(NSString *)correlationID andErrorCode:
(NSString *)errorCode andErrorMessage:
(NSString *)errorMessage {
    status = PAYMENTSTATUS_FAILED;
}*/

- (void)paymentFailedWithCorrelationID:
(NSString *)correlationID {
    status = PAYMENTSTATUS_FAILED;
}

//paymentCanceled is required. Record the payment as canceled by
// the user and perform associated bookkeeping. No UI updates.
- (void)paymentCanceled {
    status = PAYMENTSTATUS_CANCELED;
}

#warning This needs implementation
//PaymentLibraryExit
-(void)paymentLibraryExit
{
    
}

#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"ItemCell";
    ItemCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    Item *item = [self.items objectAtIndex:indexPath.row];
    
    cell.imageView.image = item.image;
    cell.titleLabel.text = item.title;
    cell.priceLabel.text = [Item getPriceStringFromDouble:item.price];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

@end
