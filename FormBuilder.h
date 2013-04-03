//
//  FormBuilder.h
//  Google Play Project
//
//  Created by William Joshua Billingham on 3/21/13.
//  Copyright 2013 University of Michigan. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FormBuilder : NSObject {
}

+ (FormBuilder*)getEmpty;
- (void)close;
- (void)addField:(NSString*)key withValue:(NSString*)value;

@property (nonatomic, retain) NSMutableData* data;
@property (nonatomic, retain) NSString* boundary;
@property (nonatomic, retain) NSString* content_type;

@end
