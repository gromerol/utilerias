/**
 * Ti.Paypal Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import <Foundation/Foundation.h>
#import "PayPal.h"
#import "TiUIView.h"
#import "TiPaypalModule.h"
#import "PayPalReceiverPaymentDetails.h"
#import "PayPalAdvancedPayment.h"
#import "PayPalInvoiceItem.h"

@interface TiPaypalPaypalButton : TiUIView<PayPalPaymentDelegate> {
    PayPalEnvironment ppEnv;
    PayPalPaymentType paymentType;
    PayPalPaymentSubType paymentSubtype;
    PayPalButtonType buttonType;
    PayPalButtonText textStyle;
    BOOL createdButton;
    
    BOOL shipping;
    BOOL feePaid;
	BOOL donation;
    
    NSString* appID;
    NSString* language;
	PayPalPayment* simplePayment;
    PayPalAdvancedPayment* advancedPayment;
    
    NSString* preapprovalKey;
    NSString* preapprovalMerchantName;
}

-(PayPal*)getPayPalInstance;
-(void)createButton;

@end
