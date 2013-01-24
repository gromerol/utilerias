/**
 * Ti.Paypal Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiPaypalPaypalButtonProxy.h"
#import "TiPaypalPaypalButton.h"

@implementation TiPaypalPaypalButtonProxy

#pragma mark Public API

static NSArray* ppButtonKeySequence;

-(NSArray*)keySequence
{
    if (ppButtonKeySequence == nil) {
        ppButtonKeySequence = [[NSArray alloc] initWithObjects:@"appID",@"paypalEnvironment",nil];
    }
    return ppButtonKeySequence;
}

-(void)viewDidAttach
{
    [(TiPaypalPaypalButton*)[self view] createButton];
}

@end
