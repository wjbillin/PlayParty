//
//  MP3Player.m
//  Google Play Project
//
//  Created by William Joshua Billingham on 4/28/13.
//  Copyright 2013 University of Michigan. All rights reserved.
//

#import "JSONKit.h"
#import "MP3Player.h"
#import "GoogleMusicAPI.h"


@implementation MP3Player

@synthesize cur_playing;
@synthesize delegate;

-(id)init {
	cur_playing = [@"" retain];
	delegate = [self retain]; // placeholder
	return self;
}

-(void)playSong:(NSString*)songID withDelegate:(id)delegate {
	
	NSLog(@"song id is %@", songID);
	
	if ([songID compare:self.cur_playing] == 0) {
		// pause
		return;
	}
	
	GoogleMusicAPI* api = [GoogleMusicAPI sharedManager];
	[api getSongUrl:songID withDelegate:self];
	
	self.cur_playing = songID;
	self.delegate = delegate;
}

-(void)didSucceedUrlLoad:(NSMutableData*)data {
	
	NSLog(@"Successful url load of a song to play");
	
	NSString* data_str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSLog(@"%@", data_str);
	
	NSDictionary* result_dict = [data objectFromJSONData];
	NSString* url_encoded = [result_dict objectForKey:@"url"];
	NSString* url_decoded = [NSString stringWithUTF8String:[url_encoded cStringUsingEncoding:NSUTF8StringEncoding]];
	
	NSLog(@"and the decoded url is %@", url_decoded);
	
	[self.delegate playUrl:url_decoded];
}

-(void)didErrorUrlLoad:(NSString*)error {
	NSLog(@"ERROR: %@", error);
}
	

@end
