//
//  HttpClient.h
//  Google Play Project
//
//  Created by William Joshua Billingham on 3/12/13.
//  Copyright 2013 University of Michigan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FormBuilder.h"

@interface HttpClient : NSObject {
}

- (void)setDelegateOnce:(id)delegate;
- (NSString*)extractAuthToken:(NSString*)response;
- (NSMutableURLRequest*)prepareConnection:(NSString*)address withMethod:(NSString*)method;
- (void)dispatchGet:(NSString*)address;
- (void)dispatchPost:(NSString*)address withForm:(FormBuilder*)form isLogin:(bool)login;
- (void)setCookieFromResponse:(NSURLResponse*)response;
- (void)setupAuthentication:(NSString*)response;
- (NSURL*)adjustAddress:(NSString*)address;

@property (nonatomic, retain) NSString* authorizationToken;
@property (nonatomic, retain) NSString* cookie;
@property (nonatomic, retain) NSString* rawCookie;
@property (nonatomic, retain) NSMutableData* receivedData;
@property (nonatomic, retain) id delegate;

@end
