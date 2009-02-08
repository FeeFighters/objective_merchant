//
//  CreditCard.h
//  objective_merchant
//
//  Created by Joshua Krall on 2/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ExpiryDate.h"
#import "NSStringAdditions.h"
#import "Validatable.h"

//# == Description
//# This credit card object can be used as a stand alone object. It acts just like an ActiveRecord object
//# but doesn't support the .save method as its not backed by a database.
//# 
//# For testing purposes, use the 'bogus' credit card type. This card skips the vast majority of 
//# validations. This allows you to focus on your core concerns until you're ready to be more concerned 
//# with the details of particular creditcards or your gateway.
//# 
//# == Testing With CreditCard
//# Often when testing we don't care about the particulars of a given card type. When using the 'test' 
//# mode in your Gateway, there are six different valid card numbers: 1, 2, 3, 'success', 'fail', 
//# and 'error'.
//# 
//#--
//# For details, see CreditCardMethods#valid_number?
//#++
//# 
//# == Example Usage
//#   cc = CreditCard.new(
//#     :first_name => 'Steve', 
//#     :last_name  => 'Smith', 
//#     :month      => '9', 
//#     :year       => '2010', 
//#     :type       => 'visa', 
//#     :number     => '4242424242424242'
//#   )
//#   
//#   cc.valid? # => true
//#   cc.display_number # => XXXX-XXXX-XXXX-4242
//#
@interface BillingCreditCard : NSObject 
{

@protected
	NSMutableString *number;
	NSMutableString *month;
	NSMutableString *year;
	NSMutableString *type;
	NSMutableString *firstName;
	NSMutableString *lastName;
	NSMutableString *startMonth;
	NSMutableString *startYear;
	NSMutableString *issueNumber;
	NSMutableString *verificationValue;

#include "Validatable_Definitions.h"	
}

@property(nonatomic, retain) NSString *number;
@property(nonatomic, retain) NSString *month;
@property(nonatomic, retain) NSString *year;
@property(nonatomic, retain) NSString *type;
@property(nonatomic, retain) NSString *firstName;
@property(nonatomic, retain) NSString *lastName;

//# Required for Switch / Solo cards
@property(nonatomic, retain) NSString *startMonth;
@property(nonatomic, retain) NSString *startYear;
@property(nonatomic, retain) NSString *issueNumber;

//# Optional verification_value (CVV, CVV2 etc). Gateways will try their best to 
//# run validation on the passed in value if it is supplied
@property(nonatomic, retain) NSString *verificationValue;

- (ExpiryDate *) expiryDate;
- (bool) is_expired;
- (bool) has_name;
- (bool) has_first_name;
- (bool) has_last_name;
- (bool) has_last_name;
- (NSString *) name;
- (bool) has_verificationValue;
- (NSString *) displayNumber;
- (NSString *) lastDigits;
- (void) validate;

+ (bool) requiresVerificationValue;
+ (bool) requireVerificationValue;
+ (void) setRequireVerificationValue:(bool)value;

@end
