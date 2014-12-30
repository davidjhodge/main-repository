//
//  OverviewVC.h
//  EventNow
//
//  Created by David Hodge on 12/29/14.
//  Copyright (c) 2014 Genesis Apps, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPal.h"

typedef enum PaymentStatuses
{
    PAYMENTSTATUS_SUCCESS,
    PAYMENTSTATUS_FAILED,
    PAYMENTSTATUS_CANCELED,
} PaymentStatus;

@interface OverviewVC : UIViewController <PayPalPaymentDelegate> {
    PaymentStatus status;
}

-(void)payWithPayPal;

@end
