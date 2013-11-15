//
//  LMPlayerListViewController.m
//  LeagueManager
//
//  Created by lyfing on 13-10-21.
//  Copyright (c) 2013年 lyfing.com. All rights reserved.
//

#import "LMPlayerListViewController.h"
#import "LMPlayerViewController.h"

@interface LMPlayerListViewController ()
@property (nonatomic,strong) Team *team;
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation LMPlayerListViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.team = nil;
    self.tableView = nil;
}

- (id)initWithTeam:(Team *)team
{
    if ( self = [super init] ) {
        self.team = team;
        
        //Add observer
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceivePlayerChangeNotification:) name:kNotificationPlayerChanged object:nil];
        
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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Private Method
- (void)setupViews
{
    self.title = [NSString stringWithFormat:@"Players in %@",self.team.name];
    
    CGSize size = self.view.frame.size;
    //UITableView
    CGRect frame = CGRectMake(0.0f,0.0f,size.width,size.height - kSystemNavigationBarHeight);
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction:)];
    self.navigationItem.rightBarButtonItem = add;
}

- (NSArray *)sortPlayers
{
    NSSortDescriptor *sortLastNameDescriptor = [[NSSortDescriptor alloc] initWithKey:kPlayerLastName ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortLastNameDescriptor];
    
    return [[[self.team valueForKey:kPlayers] allObjects] sortedArrayUsingDescriptors:sortDescriptors];
}

- (Player *)playForIndexPath:(NSIndexPath *)indexPath
{
    Player *player = nil;
    
    NSArray *players = [self sortPlayers];
    if ( indexPath.row < [players count] ) {
        player = [players objectAtIndex:indexPath.row];
    }
    
    return player;
}
#pragma mark - Configure Cell
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Player *player = [self playForIndexPath:indexPath];
    if ( player ) {
        NSString *displayTxt = [NSString stringWithFormat:@"%@ %@,%d,%@",player.lastName,player.firstName,[player.age intValue],player.signature];
        [cell.textLabel setText:displayTxt];
        [cell.detailTextLabel setText:[player valueForKey:kPlayerEmail]];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *players = [self sortPlayers];
    if ( indexPath.row < [players count] ) {
        Player *player = [players objectAtIndex:indexPath.row];
        LMPlayerViewController *playerVC = [[LMPlayerViewController alloc] initWithPlayer:player andTeam:self.team withViewType:LMViewControllerStyleDisplay];
        playerVC.viewControllerStyle = LMViewControllerStyleDisplay;
        [self.navigationController pushViewController:playerVC animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - Cell Edit
//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setEditing:YES animated:YES];
    
    return UITableViewCellEditingStyleDelete;
}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self deleteAction:indexPath];
    [tableView setEditing:NO animated:YES];
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.team valueForKey:kPlayers] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseId = @"CellResultId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if ( nil == cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseId];
    }
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}
#pragma mark - Action Method
- (void)addAction:(id)sender
{
    LMPlayerViewController *playerVC = [[LMPlayerViewController alloc] initWithPlayer:nil andTeam:self.team withViewType:LMViewControllerStyleAdd];
    [self.navigationController pushViewController:playerVC animated:YES];
}

- (void)deleteAction:(NSIndexPath *)indexPath
{
    Player *player = [self playForIndexPath:indexPath];
    if ( player ) {
        LMAppDelegate *appDelegate = (LMAppDelegate *)[UIApplication sharedApplication].delegate;
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        [context deleteObject:player];
        [appDelegate saveContext];
    }
}

#pragma mark - Handel Notification
- (void)didReceivePlayerChangeNotification:(NSNotification *)notify
{
    [self.tableView reloadData];
}
@end