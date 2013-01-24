/**
 * Ti.Paypal Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiPaypalPaypalButton.h"
#import "PayPalPayment.h"
#import "TiUtils.h"

NSString* ppTestID = @"APP-80W284485P519543T";

@implementation TiPaypalPaypalButton

-(id)init
{
    if ((self = [super init])) {
        buttonType = BUTTON_152x33;
        ppEnv = ENV_SANDBOX;
        paymentType = TYPE_PERSONAL;
        paymentSubtype = SUBTYPE_NOT_SET;
        textStyle = BUTTON_TEXT_PAY;
        appID = [[NSString alloc] initWithString:ppTestID];
        
        shipping = YES;
        feePaid = NO;
		donation = NO;
    }
    return self;
}

-(void)dealloc
{
    RELEASE_TO_NIL(advancedPayment);
    RELEASE_TO_NIL(preapprovalKey);
    RELEASE_TO_NIL(preapprovalMerchantName);
    RELEASE_TO_NIL(simplePayment);
    RELEASE_TO_NIL(appID);
    RELEASE_TO_NIL(language);
    [super dealloc];
}

-(void)populateDefaultLanguage:(PayPal*)instance {
    NSString* preferredLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString* countryCode = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    // This array was taken from PayPal's documentation, page 12:
    // https://cms.paypal.com/cms_content/US/en_US/files/developer/PP_MECL_Developer_Guide_and_Reference_iOS.pdf
    NSArray* supportedLanguages = [NSArray arrayWithObjects:
                                   @"es_AR", @"pt_BR", @"en_AU", @"en_BE", @"nl_BE", @"fr_BE", 
                                   @"en_CA", @"fr_CA", @"fr_FR", @"en_FR", @"de_DE", @"en_DE", 
                                   @"zh_HK", @"en_HK", @"en_IN", @"it_IT", @"ja_JP", @"en_JP", 
                                   @"es_MX", @"en_MX", @"nl_NL", @"en_NL", @"pl_PL", @"en_PL", 
                                   @"en_SG", @"es_ES", @"en_ES", @"de_CH", @"en_CH", @"fr_CH", 
                                   @"zh_TW", @"en_TW", @"en_US",
                                   nil];
    NSString* preferredLocale = [NSString stringWithFormat:@"%@_%@", preferredLanguage, countryCode];
    if (![supportedLanguages containsObject:preferredLocale]) {
        // PayPal doesn't support the optimal locale (like es_US, for example)
        // So let's find one that is the language the user prefers, at least.
        for (NSString* supportedLanguage in supportedLanguages) {
            if ([supportedLanguage hasPrefix:preferredLanguage]) {
                instance.lang = supportedLanguage;
                break;
            }
        }
    }
    else {
        instance.lang = preferredLocale;
    }
}

// The instance might be configured more than once!  In fact, it's re-configured after every transaction!
-(void)configureInstance
{
    PayPal* instance = [self getPayPalInstance];
	[instance setShippingEnabled:shipping];
    
    if (language != nil) {
        instance.lang = language;
    }
    else {
        [self populateDefaultLanguage:instance];
    }
    
    [instance setFeePayer:feePaid ? FEEPAYER_EACHRECEIVER : FEEPAYER_SENDER];
}

-(PayPal*)getPayPalInstance
{
    static bool initialized = NO;
    if (!initialized) {
        [PayPal initializeWithAppID:appID forEnvironment:ppEnv];
        initialized = YES;
    }
    
    return [PayPal getPayPalInst];
}

-(void)createButton
{
    ENSURE_UI_THREAD_0_ARGS;
    
    [self configureInstance];
    UIButton* paypalButton = [[self getPayPalInstance] getPayButtonWithTarget:self
                                                                    andAction:@selector(checkout)
                                                                andButtonType:buttonType
                                                                andButtonText:textStyle];
    
    [self addSubview:paypalButton];
    createdButton = YES;
    [self.proxy fireEvent:@"buttonDisplayed"];
    [[TiPaypalModule instance] fireEvent:@"buttonDisplayed"];
}

-(void)checkout
{
    ENSURE_UI_THREAD_0_ARGS;
    PayPal* instance = [self getPayPalInstance];
    [self configureInstance];
    if (simplePayment != nil) {
        [instance checkoutWithPayment:simplePayment];
    }
    else if (advancedPayment != nil) {
        [instance advancedCheckoutWithPayment:advancedPayment];
    }
    else if (preapprovalKey != nil) {
        [instance preapprovalWithKey:preapprovalKey andMerchantName:preapprovalMerchantName];
    }
    else {
        [self throwException:@"Checkout Improperly Called" subreason:@"Checkout called before setting payment or advancedPayment" location:CODELOCATION];
    }
}

-(void)populateCommonProperties:(NSObject*)payment fromArgs:(NSDictionary*)args
{
    [payment setRecipient:[args valueForKey:@"recipient"]];
	[payment setSubTotal:[NSDecimalNumber decimalNumberWithString:[[args valueForKey:@"subtotal"] stringValue]]];
    
    [payment setPaymentType:[TiUtils intValue:[args valueForKey:@"paymentType"] def:TYPE_PERSONAL]];
    [payment setPaymentSubType:[TiUtils intValue:[args valueForKey:@"paymentSubtype"] def:SUBTYPE_NOT_SET]];
    
	[payment setDescription:[args valueForKey:@"itemDescription"]];
    [payment setCustomId:[args valueForKey:@"customID"]];
	[payment setMerchantName:[args valueForKey:@"merchantName"]];
    
    PayPalInvoiceData* invoiceData = [[[PayPalInvoiceData alloc] init] autorelease];
    invoiceData.totalTax = [NSDecimalNumber decimalNumberWithString:[[args valueForKey:@"tax"] stringValue]];
	invoiceData.totalShipping = [NSDecimalNumber decimalNumberWithString:[[args valueForKey:@"shipping"] stringValue]];
    
    NSArray* invoiceItems = [args objectForKey:@"invoiceItems"];
    if (invoiceItems != nil) {
        invoiceData.invoiceItems = [NSMutableArray array];
        for (NSDictionary* rawItem in invoiceItems) {
            PayPalInvoiceItem* item = [[PayPalInvoiceItem alloc] init];
            item.name = [rawItem valueForKey:@"name"];
            item.itemId = [rawItem valueForKey:@"itemID"];
            item.totalPrice = [NSDecimalNumber decimalNumberWithString:[[rawItem valueForKey:@"totalPrice"] stringValue]];
            item.itemPrice = [NSDecimalNumber decimalNumberWithString:[[rawItem valueForKey:@"itemPrice"] stringValue]];
            item.itemCount = NUMINT([TiUtils intValue:[rawItem valueForKey:@"itemCount"] def:1]);
            [invoiceData.invoiceItems addObject:[item autorelease]];
        }
    }
    [payment setInvoiceData:invoiceData];
}

-(void)setPayment_:(NSDictionary*)args
{
    // Clean up existing payment methods.
	RELEASE_TO_NIL(simplePayment);
    RELEASE_TO_NIL(advancedPayment);
    
    // And now initialize the simple payment.
	simplePayment = [[PayPalPayment alloc] init];
    [self populateCommonProperties:simplePayment fromArgs:args];
    
	simplePayment.paymentCurrency = [args valueForKey:@"currency"];
    simplePayment.ipnUrl = [args valueForKey:@"ipnUrl"];
    simplePayment.memo = [args valueForKey:@"memo"];
}

-(void)setAdvancedPayment_:(NSDictionary*)args
{
    // Clean up existing payment methods.
    RELEASE_TO_NIL(simplePayment);
    RELEASE_TO_NIL(advancedPayment);
    
    // And now initialize the parallel payment.
    advancedPayment = [[PayPalAdvancedPayment alloc] init];
    
    NSArray* payments = [args valueForKey:@"payments"];
    advancedPayment.receiverPaymentDetails = [NSMutableArray array];
    
    for (NSDictionary* details in payments) {
        PayPalReceiverPaymentDetails* payment = [[PayPalReceiverPaymentDetails alloc] init];
        [self populateCommonProperties:payment fromArgs:details];
        // If one of the payments sets "isPrimary", PayPal treats this as a chain payment. Otherwise, parallel.
        payment.isPrimary = [TiUtils boolValue:[details valueForKey:@"isPrimary"] def:NO];
        [advancedPayment.receiverPaymentDetails addObject:[payment autorelease]];
    }
    
	advancedPayment.paymentCurrency = [args valueForKey:@"currency"];
    advancedPayment.ipnUrl = [args valueForKey:@"ipnUrl"];
    advancedPayment.memo = [args valueForKey:@"memo"];
}

-(void)setPreapprovalKey_:(NSString*)value
{
    if (preapprovalKey != value) {
        RELEASE_TO_NIL(preapprovalKey);
        preapprovalKey = [value retain];
    }
}

-(void)setPreapproval_:(NSDictionary*)args
{
    PayPal* instance = [self getPayPalInstance];
    PayPalPreapprovalDetails* details = [instance preapprovalDetails];
    
    id currency = [args objectForKey:@"currency"];
    if (currency != nil) {
        [details setCurrency:[TiUtils stringValue:currency]];
    }
    
    id dayOfMonth = [args objectForKey:@"dayOfMonth"];
    if (dayOfMonth != nil) {
        [details setDateOfMonth:[TiUtils intValue:dayOfMonth]];
    }
    
    id dayOfWeek = [args objectForKey:@"dayOfWeek"];
    if (dayOfWeek != nil) {
        [details setDayOfWeek:[TiUtils intValue:dayOfWeek]];
    }
    
    id isApproved = [args objectForKey:@"isApproved"];
    if (isApproved != nil) {
        [details setApproved:[TiUtils boolValue:isApproved]];
    }
    
    id paymentPeriod = [args objectForKey:@"paymentPeriod"];
    if (paymentPeriod != nil) {
        [details setPaymentPeriod:[TiUtils intValue:paymentPeriod]];
    }
    
    id pinRequired = [args objectForKey:@"pinRequired"];
    if (pinRequired != nil) {
        [details setPinRequired:[TiUtils boolValue:pinRequired]];
    }
    
    id maxAmountPerPayment = [args objectForKey:@"maxAmountPerPayment"];
    if (maxAmountPerPayment != nil) {
        [details setMaxPerPayment:[NSDecimalNumber decimalNumberWithString:[TiUtils stringValue:maxAmountPerPayment]]];
    }
    
    id maxNumberOfPayments = [args objectForKey:@"maxNumberOfPayments"];
    if (maxNumberOfPayments != nil) {
        [details setMaxNumPayments:[TiUtils intValue:maxNumberOfPayments]];
    }
    
    id maxNumberOfPaymentsPerPeriod = [args objectForKey:@"maxNumberOfPaymentsPerPeriod"];
    if (maxNumberOfPaymentsPerPeriod != nil) {
        [details setMaxNumPaymentsPerPeriod:[TiUtils intValue:maxNumberOfPaymentsPerPeriod]];
    }
    
    id maxTotalAmountOfAllPayments = [args objectForKey:@"maxTotalAmountOfAllPayments"];
    if (maxTotalAmountOfAllPayments != nil) {
        [details setMaxTotalAmountOfAllPayments:[NSDecimalNumber decimalNumberWithString:[TiUtils stringValue:maxTotalAmountOfAllPayments]]];
    }
    
    id rawMerchantName = [args objectForKey:@"merchantName"];
    if (rawMerchantName != nil) {
        preapprovalMerchantName = [[TiUtils stringValue:rawMerchantName] retain];
        [details setMerchantName:preapprovalMerchantName];
    }
    
    id ipnUrl = [args objectForKey:@"ipnUrl"];
    if (ipnUrl != nil) {
        [details setIpnUrl:[TiUtils stringValue:ipnUrl]];
    }
    
    id memo = [args objectForKey:@"memo"];
    if (memo != nil) {
        [details setMemo:[TiUtils stringValue:memo]];
    }
}

-(void)setButtonStyle_:(NSNumber*)style
{
    buttonType = [TiUtils intValue:style def:BUTTON_152x33];
}

-(void)setPaypalEnvironment_:(NSNumber*)env
{
    ppEnv = [TiUtils intValue:env def:ENV_SANDBOX];
}

-(void)setTransactionType_:(NSNumber*)type
{
    NSLog(@"WARNING: 'transactionType' IS NOT A VALID PROPERTY! You need to use the 'paymentType' property on the PAYMENT DICTIONARY! See docs or example for more info.");
}

-(void)setFeePaidByReceiver_:(NSNumber*)yn
{
    feePaid = [TiUtils boolValue:yn def:NO];
}

-(void)setEnableShipping_:(NSNumber*)yn
{
    shipping = [TiUtils boolValue:yn def:YES];
}

-(void)setLanguage_:(NSString*)value
{
    if (language != value) {
        RELEASE_TO_NIL(language);
        language = [value retain];
    }
}

-(void)setAppID_:(NSString*)newID
{
    if (appID != newID) {
        RELEASE_TO_NIL(appID);
        appID = [newID retain];
        
        if (appID == nil) {
            appID = [[NSString alloc] initWithString:ppTestID];
        }
    }
}
-(void)setAppId_:(NSString*)newID
{
	[self setAppID_:newID];
}

-(void)setTextStyle_:(NSNumber*)style
{
	textStyle = [TiUtils intValue:style def:BUTTON_TEXT_PAY];
}

#pragma mark Paypal delegate

- (void)paymentSuccessWithKey:(NSString *)payKey andStatus:(PayPalPaymentStatus)paymentStatus
{
    NSDictionary* event = [NSDictionary dictionaryWithObjectsAndKeys:payKey,@"transactionID",nil];
    if ([self.proxy _hasListeners:@"paymentSuccess"]) {
        [self.proxy fireEvent:@"paymentSuccess" withObject:event];
    }
    if ([[TiPaypalModule instance] _hasListeners:@"paymentSuccess"]) {
        [[TiPaypalModule instance] fireEvent:@"paymentSuccess" withObject:event];
    }
}

-(void)paymentCanceled
{
    if ([self.proxy _hasListeners:@"paymentCancelled"]) {
        [self.proxy fireEvent:@"paymentCancelled"];
    }
    if ([[TiPaypalModule instance] _hasListeners:@"paymentCancelled"]) {
        [[TiPaypalModule instance] fireEvent:@"paymentCancelled"];
    }
}

- (void)paymentFailedWithCorrelationID:(NSString *)correlationID
{
    NSMutableDictionary* event = [NSDictionary dictionaryWithObjectsAndKeys:correlationID,@"correlationID",nil];
    if ([self.proxy _hasListeners:@"paymentFailed"]) {
        [self.proxy fireEvent:@"paymentFailed" withObject:event];
    }
    if ([[TiPaypalModule instance] _hasListeners:@"paymentFailed"]) {
        [[TiPaypalModule instance] fireEvent:@"paymentFailed" withObject:event];
    }
}

- (void)paymentLibraryExit
{
	// Do nothing for now
}

@end
