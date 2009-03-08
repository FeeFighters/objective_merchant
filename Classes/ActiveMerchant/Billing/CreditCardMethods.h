//
//  CreditCardMethods.h
//  objective_merchant
//
//  Created by Joshua Krall on 2/8/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#if defined(TARGET_IPHONE_SIMULATOR) || defined(TARGET_OS_IPHONE)
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif


@interface BillingCreditCard (Methods)

- (bool) is_validMonth:(NSNumber*)month;
- (bool) is_validExpiryYear:(NSNumber*)year;
- (bool) is_validStartYear:(NSNumber*)year;
- (bool) is_validIssueNumber:(NSNumber*)number;

+ (bool) is_validNumber:(NSString *)number;
+ (NSDictionary *)cardCompanies;
+ (NSString *)getType:(NSString *)number;
+ (NSString *)getTypeWithPartialNumber:(NSString *)partialNumber;
+ (NSString *)lastDigits:(NSString *)number;
+ (NSString *)mask:(NSString *)number;
+ (bool) is_matchingType:(NSString *)number type:(NSString *)type;
+ (NSString*) number:(NSString*)number withSeperator:(NSString*)seperator;
+ (int) expectedCardNumberLength:(NSString*)number;

@end
