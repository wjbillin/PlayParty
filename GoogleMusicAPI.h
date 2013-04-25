//
//  GoogleMusicAPI.h
//  Google Play Project
//
//  Created by William Joshua Billingham on 3/12/13.
//  Copyright 2013 University of Michigan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"

@interface GoogleMusicAPI : NSObject {
}

@property (nonatomic,retain) HttpClient* client;

+ (id)sharedManager;
- (void)login:(NSString*)email withPassword:(NSString*)pass withDelegate:(id)delegate;
- (void)getPlaylists:(id)delegate;
//- (void)getSongUrl:(Song)song (id<NSURLConnectionDelegate>)delegate;

@end
