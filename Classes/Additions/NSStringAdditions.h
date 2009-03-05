//
//  NSStringAdditions.h
//  objective_merchant
//
//  Created by Joshua Krall on 2/7/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#if defined(TARGET_IPHONE_SIMULATOR) || defined(TARGET_OS_IPHONE)
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif



@interface NSString (RubyAdditions)

- (bool) is_blank;
+ (bool) is_blank:(NSString *)str;
- (NSString *) capitalizeFirstLetter;
- (NSString *) lowercaseFirstLetter;
- (NSString *) toCamelcase;
- (NSString *) humanize;

@end

@interface NSString (RegexKitLiteEnumeratorAdditions) 
	- (NSEnumerator *)matchEnumeratorWithRegex:(NSString *)regex;
@end