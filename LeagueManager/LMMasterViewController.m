//
//  LMMasterViewController.m
//  LeagueManager
//
//  Created by lyfing on 13-5-22.
//  Copyright (c) 2013年 lyfing.com. All rights reserved.
//

#import "LMMasterViewController.h"
#import "LMTeamViewController.h"
#import "LMPlayerListViewController.h"
#import "Team.h"

@interface LMMasterViewController ()
{
    NSFetchedResultsController *_fetchResultController;
}
@property (nonatomic,strong) NSFetchedResultsController *fetchResultController;
@end

@implementation LMMasterViewController
@synthesize fetchResultController = _fetchResultController;

- (void)dealloc
{
    self.fetchResultController.delegate = nil;
    self.fetchResultController = nil;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    [self setupViews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Private Method
- (void)setupViews
{
    self.title = @"Team";
    
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction:)];
    self.navigationItem.rightBarButtonItem = add;
}

#pragma mark - Action Method
- (void)addAction:(id)sender
{
    LMTeamViewController *teamVC = [[LMTeamViewController alloc] initWithTeam:nil withViewControllerStyle:LMViewControllerStyleAdd];
    [self.navigationController pushViewController:teamVC animated:YES];
}
#pragma mark - NSFetchedResultsController
- (NSFetchedResultsController *)fetchResultController
{
    if ( _fetchResultController ) {
        return _fetchResultController;
    }
    
    static NSString *kTeamCache = @"TemaCache";
    [NSFetchedResultsController deleteCacheWithName:kTeamCache];
    
    LMAppDelegate *appDelegate = (LMAppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kEntityTeam];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:kTeamName ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    _fetchResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest  managedObjectContext:context sectionNameKeyPath:nil cacheName:kTeamCache];
    _fetchResultController.delegate = self;
    [_fetchResultController performFetch:nil];
    
    return _fetchResultController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    if ( NSFetchedResultsChangeInsert == type ) {
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
    else if ( NSFetchedResultsChangeUpdate == type )
    {
        [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
    }
    else if ( NSFetchedResultsChangeDelete == type )
    {
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    if ( NSFetchedResultsChangeInsert == type ) {
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationRight];
    }
    else if ( NSFetchedResultsChangeDelete == type )
    {
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}
#pragma mark - Configure Cell
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Team *team = [self.fetchResultController objectAtIndexPath:indexPath];
    cell.textLabel.text = [[team valueForKey:kTeamName] description];
    cell.detailTextLabel.text = [[team valueForKey:kTeamUniformColor] description];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.fetchResultController fetchedObjects] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TeamCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( nil == cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Team *team = [self.fetchResultController objectAtIndexPath:indexPath];
    if ( team ) {
        LMPlayerListViewController *playerListVC = [[LMPlayerListViewController alloc] initWithTeam:team];
        [self.navigationController pushViewController:playerListVC animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    Team *team = [self.fetchResultController objectAtIndexPath:indexPath];
    if ( team ) {
        LMTeamViewController *teamVC = [[LMTeamViewController alloc] initWithTeam:team withViewControllerStyle:LMViewControllerStyleDisplay];
        [self.navigationController pushViewController:teamVC animated:YES];
    }
}
@end