//
//  CreditCardMethods.h
//  objective_merchant
//
//  Created by Joshua Krall on 2/8/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface BillingCreditCard (Methods)

- (bool) is_validMonth:(NSInteger)month;
- (bool) is_validExpiryYear:(NSInteger)year;
- (bool) is_validStartYear:(NSInteger)year;
- (bool) is_validIssueNumber:(NSInteger)number;

+ (bool) is_validNumber:(NSString *)number;
+ (NSDictionary *)cardCompanies;
+ (NSString *)getType:(NSString *)number;
+ (NSString *)lastDigits:(NSString *)number;
+ (NSString *)mask:(NSString *)number;
+ (bool) is_matchingType:(NSString *)number type:(NSString *)type;

@end
