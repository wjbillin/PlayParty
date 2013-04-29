//
//  LibraryViewController.m
//  Google Play Project
//
//  Created by William Joshua Billingham on 4/24/13.
//  Copyright 2013 University of Michigan. All rights reserved.
//

#import "LibraryViewController.h"
#import "JSONKit.h"
#import "PartyServerAPI.h"


@implementation LibraryViewController

@synthesize playlists;
@synthesize isInitialized;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	NSLog(@"returning %d sections", [self.playlists count]);
    return [self.playlists count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	NSDictionary* playlist_full = [self.playlists objectAtIndex:section];
	NSArray* playlist_songs = [playlist_full objectForKey:@"playlist"];
    return [playlist_songs count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
    NSDictionary* playlist_full = [self.playlists objectAtIndex:section];
	return [playlist_full objectForKey:@"title"];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleInsert;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	NSDictionary* playlist_full = [self.playlists objectAtIndex:indexPath.section];
	NSArray* playlist_songs = [playlist_full objectForKey:@"playlist"];
	NSDictionary* song = [playlist_songs objectAtIndex:indexPath.row];
    
    // Configure the cell...
	NSString* main_label = [song objectForKey:@"title"];
	NSMutableString* detail_label = [NSMutableString stringWithString:[song objectForKey:@"artist"]];
	[detail_label appendFormat:@" - %@", [song objectForKey:@"album"]];
	
	cell.textLabel.text = main_label;
	cell.detailTextLabel.text = detail_label;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        NSLog(@"adding this song to queue");
		PartyServerAPI* server_api = [PartyServerAPI sharedManager];
		[server_api addSongToQueue:self songIndex:indexPath];
    }   
}



/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark -
#pragma mark URL connection

- (void)didSucceedUrlLoad:(NSMutableData*)data {
	// received playlist data
	
	if (!self.isInitialized) {
	
		NSLog(@"Successful url load of library songs");
		
		NSString* data_str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"%@", data_str);
		
		NSDictionary* result_dict = [data objectFromJSONData];
		 
		self.playlists = [result_dict objectForKey:@"playlists"];
		
		/*self.checked = [[NSMutableArray alloc] init];
		NSLog(@"playlists size is %d", [self.playlists count]);
		for (int i = 0; i < [self.playlists count]; ++i) {
			NSLog(@"iterating");
			[self.checked addObject:[NSNumber numberWithBool:NO]];
		}
		NSLog(@"checked size is %d", [self.checked count]);*/
		
		[data_str release];
		
		[self.tableView reloadData];
		[self.tableView setEditing:YES];
		
		self.isInitialized = true;
		 
		// tell queue view controller to set the timestamp
		[[[[self tabBarController] viewControllers] objectAtIndex:1] setTimestamp];
		
	} else {
		NSLog(@"Got response from adding of a song");
		// if data != 'OK', error out
		
		NSString* data_str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"%@", data_str);
		if (![data_str isEqualToString:@"OK!"]) {
			NSLog(@"ERROR: adding of song failed: %@", data_str);
		}
	}

}

- (void)didErrorUrlLoad:(NSString*)error_str {
	NSLog(@"ERROR: %@", error_str);
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSLog(@"did select a row");
	
	[tableView cellForRowAtIndexPath:indexPath].editing = YES;
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

