//
//  LMPlayViewController.m
//  LeagueManager
//
//  Created by lyfing on 13-10-21.
//  Copyright (c) 2013年 lyfing.com. All rights reserved.
//

#import "LMPlayerViewController.h"

@interface LMPlayerViewController ()
@property (nonatomic,strong) UITextField *firstNameTField;
@property (nonatomic,strong) UITextField *lastNameTField;
@property (nonatomic,strong) UITextField *emailTField;
@property (nonatomic,strong) UITextField *ageTField;
@property (nonatomic,strong) UITextField *signaturTField;
@property (nonatomic,strong) Player *player;
@property (nonatomic,strong) Team *team;
@end

@implementation LMPlayerViewController
- (void)dealloc
{
    self.firstNameTField = nil;
    self.lastNameTField = nil;
    self.emailTField = nil;
    self.ageTField = nil;
    self.signaturTField = nil;
    self.player = nil;
    self.team = nil;
}

- (id)initWithPlayer:(Player *)player andTeam:(Team *)team withViewType:(LMViewControllerStyle)view
{
    if ( self = [super init] ) {
        self.player = player;
        self.team = team;
        _viewControllerStyle = view;
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.title = @"Player";
    [self setupViews];
    [self setViewControllerStyle:_viewControllerStyle];
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
    CGRect frame = CGRectMake(10, 20, 100, 30);
    UILabel *firstNameLbl = [[UILabel alloc] initWithFrame:frame];
    firstNameLbl.backgroundColor = [UIColor clearColor];
    [firstNameLbl setText:@"First Name:"];
    [firstNameLbl setFont:[UIFont systemFontOfSize:12.0f]];
    [firstNameLbl setTextColor:[UIColor blackColor]];
    [self.view addSubview:firstNameLbl];
    
    frame = CGRectMake(110, 15, 200, 30);
    self.firstNameTField = [[UITextField alloc] initWithFrame:frame];
    self.firstNameTField.placeholder = @"First Name";
    [self.firstNameTField setFont:[UIFont systemFontOfSize:12.0f]];
    self.firstNameTField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:self.firstNameTField];
    
    frame = CGRectMake(10, 50, 100, 30);
    UILabel *lastNameLbl = [[UILabel alloc] initWithFrame:frame];
    lastNameLbl.backgroundColor = [UIColor clearColor];
    [lastNameLbl setText:@"Last Name:"];
    [lastNameLbl setFont:[UIFont systemFontOfSize:12.0f]];
    [lastNameLbl setTextColor:[UIColor blackColor]];
    [self.view addSubview:lastNameLbl];
    
    frame = CGRectMake(110, 45, 200, 30);
    self.lastNameTField = [[UITextField alloc] initWithFrame:frame];
    self.lastNameTField.placeholder = @"Last Name";
    [self.lastNameTField setFont:[UIFont systemFontOfSize:12.0f]];
    self.lastNameTField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:self.lastNameTField];
    
    frame = CGRectMake(10, 90, 100, 30);
    UILabel *emailLbl = [[UILabel alloc] initWithFrame:frame];
    emailLbl.backgroundColor = [UIColor clearColor];
    [emailLbl setText:@"Email:"];
    [emailLbl setFont:[UIFont systemFontOfSize:12.0f]];
    [emailLbl setTextColor:[UIColor blackColor]];
    [self.view addSubview:emailLbl];
    
    frame = CGRectMake(110, 85, 200, 30);
    self.emailTField = [[UITextField alloc] initWithFrame:frame];
    self.emailTField.placeholder = @"Email";
    [self.emailTField setFont:[UIFont systemFontOfSize:12.0f]];
    self.emailTField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:self.emailTField];
    
    frame = CGRectMake(10, 130, 100, 30);
    UILabel *ageLbl = [[UILabel alloc] initWithFrame:frame];
    ageLbl.backgroundColor = [UIColor clearColor];
    [ageLbl setText:@"Age:"];
    [ageLbl setFont:[UIFont systemFontOfSize:12.0f]];
    [ageLbl setTextColor:[UIColor blackColor]];
    [self.view addSubview:ageLbl];
    
    frame = CGRectMake(110, 125, 200, 30);
    self.ageTField = [[UITextField alloc] initWithFrame:frame];
    self.ageTField.placeholder = @"Age";
    [self.ageTField setFont:[UIFont systemFontOfSize:12.0f]];
    self.ageTField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:self.ageTField];
    
    frame = CGRectMake(10, 170, 100, 30);
    UILabel *signatureLbl = [[UILabel alloc] initWithFrame:frame];
    signatureLbl.backgroundColor = [UIColor clearColor];
    [signatureLbl setText:@"Signature:"];
    [signatureLbl setFont:[UIFont systemFontOfSize:12.0f]];
    [signatureLbl setTextColor:[UIColor blackColor]];
    [self.view addSubview:signatureLbl];
    
    frame = CGRectMake(110, 165, 200, 30);
    self.signaturTField = [[UITextField alloc] initWithFrame:frame];
    self.signaturTField.placeholder = @"Signature";
    [self.signaturTField setFont:[UIFont systemFontOfSize:12.0f]];
    self.signaturTField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:self.signaturTField];
}

- (void)setViewControllerStyle:(LMViewControllerStyle)mViewControllerStyle
{
    //configure the UI
    UIBarButtonItem *rightItem = nil;
    if ( LMViewControllerStyleDisplay == mViewControllerStyle ) {
        self.title = @"Player";
        
        [self.firstNameTField setText:self.player.firstName];
        self.firstNameTField.enabled = NO;
        [self.lastNameTField setText:self.player.lastName];
        self.lastNameTField.enabled = NO;
        [self.emailTField setText:self.player.email];
        self.emailTField.enabled = NO;
        [self.ageTField setText:[self.player.age stringValue]];
        self.ageTField.enabled = NO;
        [self.signaturTField setText:self.player.signature];
        self.signaturTField.enabled = NO;
        
        rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction:)];
    }
    else if ( LMViewControllerStyleAdd == mViewControllerStyle )
    {
        self.title = @"Add Player";
        
        self.firstNameTField.enabled = YES;
        self.lastNameTField.enabled = YES;
        self.emailTField.enabled = YES;
        self.ageTField.enabled = YES;
        self.signaturTField.enabled = YES;
        [self.firstNameTField becomeFirstResponder];
        
        rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveAction:)];
    }
    else if ( LMViewControllerStyleEdit == mViewControllerStyle )
    {
        self.title = @"Player";
        
        self.firstNameTField.enabled = YES;
        self.lastNameTField.enabled = YES;
        self.emailTField.enabled = YES;
        self.ageTField.enabled = YES;
        self.signaturTField.enabled = YES;
        [self.firstNameTField becomeFirstResponder];
        
        rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveAction:)];
    }
    self.navigationItem.rightBarButtonItem = rightItem;

}

#pragma mark - Action Method
- (void)editAction:(id)sender
{
    self.viewControllerStyle = LMViewControllerStyleEdit;
}

- (void)saveAction:(id)sender
{
    if ( [self.firstNameTField.text length] == 0 || [self.lastNameTField.text length] == 0 || [self.emailTField.text length] == 0 || [self.ageTField.text length] == 0 || [self.signaturTField.text length] == 0 ) {
        return;
    }
    
    LMPlayerChangedType changeType = LMPlayerChangedTypeModify;
    
    LMAppDelegate *appDelegate = (LMAppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    if ( nil == self.player ) {
        Player *player = [NSEntityDescription insertNewObjectForEntityForName:kEntityPlayer inManagedObjectContext:context];
        self.player = player;
        changeType = LMPlayerChangedTypeAdd;
    }
    self.player.firstName = [self.firstNameTField text];
    self.player.lastName = [self.lastNameTField text];
    self.player.email = [self.emailTField text];
    self.player.age = [NSNumber numberWithInt:[[self.ageTField text] intValue]];
    self.player.signature = [self.signaturTField text];
    self.player.team = self.team;
    
    
    [appDelegate saveContext];
    
    //Send Notification
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPlayerChanged object:nil];
    
    self.viewControllerStyle = LMViewControllerStyleDisplay;
}
@end