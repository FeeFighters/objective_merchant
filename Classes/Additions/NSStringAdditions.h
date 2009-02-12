//
//  NSStringAdditions.h
//  objective_merchant
//
//  Created by Joshua Krall on 2/7/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSString (RubyAdditions)

- (bool) is_blank;
+ (bool) is_blank:(NSString *)str;
- (NSString *) capitalizeFirstLetter;

@end
