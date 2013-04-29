//
//  PlaylistSelect.m
//  Google Play Project
//
//  Created by William Joshua Billingham on 4/15/13.
//  Copyright 2013 University of Michigan. All rights reserved.
//

#import	"LibraryViewController.h"
#import "PlaylistSelectController.h"
#import "QueueViewController.h"
#import	"GoogleMusicAPI.h"
#import "PartyServerAPI.h"

@implementation PlaylistSelectController
@synthesize playlists;
@synthesize checked;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSLog(@"playlist select view loaded");

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain
																  target:self action:@selector(pushTabViewController:)];
	self.navigationItem.rightBarButtonItem = doneButton;
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

- (IBAction)pushTabViewController:(id)sender {
	
	NSMutableArray* selected_playlists = [[NSMutableArray alloc] init];
	for (int i = 0; i < [self.checked count]; i++) {
		if ([[self.checked objectAtIndex:i] boolValue] == YES) {
			NSLog(@"adding index %d to the selected playlists", i);
			[selected_playlists addObject:[NSNumber numberWithInt:i]];
		}
	}
	
	LibraryViewController* libraryViewController = [[LibraryViewController alloc] init];
	libraryViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Library" image:nil tag:0];
	libraryViewController.isInitialized = false;
	QueueViewController* queueViewController = [[QueueViewController alloc] init];
	queueViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Queue" image:nil tag:1];
	queueViewController.tabBarItem.badgeValue = @"0";
	
	NSArray* view_controllers = [[NSArray alloc] initWithObjects:libraryViewController, queueViewController, nil];
	
	UITabBarController* tabController = [[UITabBarController alloc] init];
	[tabController setViewControllers:view_controllers];
	[self presentModalViewController:tabController animated:YES];
	
	// form url to let middle man know what playlists we've chosen
	PartyServerAPI* server_api = [PartyServerAPI sharedManager];
	[server_api getPlaylists:selected_playlists withDelegate:libraryViewController];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	NSLog(@"returning %u rows as count", self.playlists.count);
    return self.playlists.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	NSArray* label = [[self.playlists objectAtIndex:indexPath.row] componentsSeparatedByString:@","];
	NSString* main_label = [label objectAtIndex:0];
	NSString* detail_label = [label objectAtIndex:1];
	
	NSLog(@"%d", [[self.checked objectAtIndex:indexPath.row] boolValue]);
	
	if ([[self.checked objectAtIndex:indexPath.row] boolValue] == YES) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		NSLog(@"thinks it should be checked");
	} else {
		NSLog(@"doesn't think it should be checked");
		cell.accessoryType = UITableViewCellAccessoryNone;
	}

	
	NSLog(@"main label is %@", main_label);
	NSLog(@"detail label is %@", detail_label);
	detail_label = [detail_label stringByAppendingString:@" Songs"];
	
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


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


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
	
	NSLog(@"Successful url load of playlists");
	
	NSString* data_str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSLog(@"%@", data_str);
	
	self.playlists = [data_str componentsSeparatedByString:@";"];
	
	self.checked = [[NSMutableArray alloc] init];
	NSLog(@"playlists size is %d", [self.playlists count]);
	for (int i = 0; i < [self.playlists count]; ++i) {
		NSLog(@"iterating");
		[self.checked addObject:[NSNumber numberWithBool:NO]];
	}
	NSLog(@"checked size is %d", [self.checked count]);
	
	[data_str release];
	
	[self.tableView reloadData];
}

- (void)didErrorUrlLoad:(NSString*)error_str {
	NSLog(@"ERROR: %@", error_str);
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	
	NSLog(@"checked size is %d", [self.checked count]);
	
	if ([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark) {
		[tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
		[self.checked replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:NO]];
		NSLog(@"set checked array to false");
	} else {
		[tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
		[self.checked replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:YES]];
		NSLog(@"set checked array to true");
	}
	
	NSLog(@"after setting, bool is %d", [[self.checked objectAtIndex:indexPath.row] boolValue]);
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
	[self.tableView deselectRowAtIndexPath:indexPath animated:TRUE];
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
	[self.playlists release];
}


@end

