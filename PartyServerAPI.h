//
//  PartyServerAPI.h
//  Google Play Project
//
//  Created by William Joshua Billingham on 4/24/13.
//  Copyright 2013 University of Michigan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"


@interface PartyServerAPI : NSObject {

}

@property (nonatomic, retain) NSString* host;
@property (nonatomic, retain) HttpClient* client;

+ (id) sharedManager;
- (void)login:(NSString*)host pass:(NSString*)pass title:(NSString*)title withDelegate:(id)delegate;
- (void)getPlaylists:(NSArray*)playlists withDelegate:(id)delegate;

@end
