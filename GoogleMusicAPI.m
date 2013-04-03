//
//  GoogleMusicAPI.m
//  Google Play Project
//
//  Created by William Joshua Billingham on 3/12/13.
//  Copyright 2013 University of Michigan. All rights reserved.
//

#import "GoogleMusicAPI.h"
#import "FormBuilder.h"

NSString* HTTPS_WWW_GOOGLE_COM_ACCOUNTS_CLIENT_LOGIN = @"https://www.google.com/accounts/ClientLogin";
NSString* HTTPS_PLAY_GOOGLE_COM_MUSIC_SERVICES_SEARCH = @"https://play.google.com/music/services/search";
NSString* HTTPS_PLAY_GOOGLE_COM_MUSIC_SERVICES_LOADALLTRACKS = @"https://play.google.com/music/services/loadalltracks";
NSString* HTTPS_PLAY_GOOGLE_COM_MUSIC_SERVICES_LOADPLAYLIST = @"https://play.google.com/music/services/loadplaylist";
NSString* HTTPS_PLAY_GOOGLE_COM_MUSIC_SERVICES_DELETEPLAYLIST = @"https://play.google.com/music/services/deleteplaylist";
NSString* HTTPS_PLAY_GOOGLE_COM_MUSIC_SERVICES_ADDPLAYLIST = @"https://play.google.com/music/services/addplaylist";
NSString* HTTPS_PLAY_GOOGLE_COM_MUSIC_PLAY_SONGID = @"https://play.google.com/music/play?u=0&songid=%1$s&pt=e";

@implementation GoogleMusicAPI

@synthesize client;

+ (id)sharedManager {
    static GoogleMusicAPI *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
	if (self = [super init]) {
		client = [[HttpClient alloc] init];
	}
	return self;
}

- (void)dealloc {
	[client release];
	[super dealloc];
}

- (void)login:(NSString*)email withPassword:(NSString*)pass withDelegate:(id)delegate {
	
	NSLog(@"In login, great");
	FormBuilder* form = [[[FormBuilder alloc] init] autorelease];
	[form addField:@"service" withValue:@"sj"];
	[form addField:@"Email" withValue:email];
	[form addField:@"Passwd" withValue:pass];
	
	[form close];
	
	[self.client setDelegateOnce:delegate];
	
	[self.client dispatchPost:HTTPS_WWW_GOOGLE_COM_ACCOUNTS_CLIENT_LOGIN withForm:form isLogin:true];
	
}
/*- (void)getSongUrl:(Song)song (id<NSURLConnectionDelegate>)delegate {
}*/

@end
