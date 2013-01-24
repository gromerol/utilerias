/**
 * Ti.Paypal Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "PayPal.h"
#import "PayPalPreapprovalDetails.h"
#import "TiModule.h"
#import "KrollCallback.h"

@interface TiPaypalModule : TiModule {
}

// Payment types
@property (readonly, nonatomic) NSNumber* PAYMENT_TYPE_HARD_GOODS;
@property (readonly, nonatomic) NSNumber* PAYMENT_TYPE_SERVICE;
@property (readonly, nonatomic) NSNumber* PAYMENT_TYPE_PERSONAL;

// Button sizes
@property (readonly, nonatomic) NSNumber* BUTTON_152x33;
@property (readonly, nonatomic) NSNumber* BUTTON_194x37;
@property (readonly, nonatomic) NSNumber* BUTTON_278x43;
@property (readonly, nonatomic) NSNumber* BUTTON_294x43;

// Environment settings
@property (readonly, nonatomic) NSNumber* PAYPAL_ENV_LIVE;
@property (readonly, nonatomic) NSNumber* PAYPAL_ENV_SANDBOX;
@property (readonly, nonatomic) NSNumber* PAYPAL_ENV_NONE;

+ (TiPaypalModule*) instance;

@end
