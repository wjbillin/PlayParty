//
//  HttpBodyBuilder.h
//  Google Play Project
//
//  Created by William Joshua Billingham on 4/24/13.
//  Copyright 2013 University of Michigan. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HttpBodyBuilder : NSObject {

}

@property (nonatomic, retain) NSMutableString* body;

- (void)addField:(NSString*)key withValue:(NSString*) value;
- (NSData*)close;

@end
