//
//  OverviewVC.m
//  EventNow
//
//  Created by David Hodge on 12/29/14.
//  Copyright (c) 2014 Genesis Apps, LLC. All rights reserved.
//

#import "OverviewVC.h"

@interface OverviewVC ()

@end

@implementation OverviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addPayPalButton];
    //PayPalPayment *currentPayment =
    
    self.navigationItem.title = @"Overview";
    
}

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
- (void)paymentFailedWithCorrelationID:
(NSString *)correlationID andErrorCode:
(NSString *)errorCode andErrorMessage:
(NSString *)errorMessage {
    status = PAYMENTSTATUS_FAILED;
}

//paymentCanceled is required. Record the payment as canceled by
// the user and perform associated bookkeeping. No UI updates.
- (void)paymentCanceled {
    status = PAYMENTSTATUS_CANCELED;
}

-(void)openUber
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"uber://?action=setPickup&pickup=my_location"]];
}

@end
