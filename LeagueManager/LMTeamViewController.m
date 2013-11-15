//
//  LMTeamViewController.m
//  LeagueManager
//
//  Created by lyfing on 13-10-21.
//  Copyright (c) 2013年 lyfing.com. All rights reserved.
//

#import "LMTeamViewController.h"

@interface LMTeamViewController ()
@property (nonatomic,strong) UITextField *nameTField;
@property (nonatomic,strong) UITextField *uniformColorTField;
@property (nonatomic,assign) LMViewControllerStyle viewControllerStyle;
@end

@implementation LMTeamViewController
- (void)dealloc
{
    self.nameTField = nil;
    self.uniformColorTField = nil;
}

- (id)initWithTeam:(Team *)team withViewControllerStyle:(LMViewControllerStyle)style
{
    if ( self = [super init] ) {
        self.team = team;
        _viewControllerStyle = style;
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.title = @"Teams";
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
    UILabel *nameLbl = [[UILabel alloc] initWithFrame:frame];
    nameLbl.backgroundColor = [UIColor clearColor];
    [nameLbl setText:@"Team Name:"];
    [nameLbl setFont:[UIFont systemFontOfSize:12.0f]];
    [nameLbl setTextColor:[UIColor blackColor]];
    [self.view addSubview:nameLbl];
    
    frame = CGRectMake(110, 20, 200, 30);
    self.nameTField = [[UITextField alloc] initWithFrame:frame];
    self.nameTField.placeholder = @"Team Name";
    [self.nameTField setFont:[UIFont systemFontOfSize:12.0f]];
    self.nameTField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:self.nameTField];
    
    frame = CGRectMake(10, 50, 100, 30);
    UILabel *uniformColorLbl = [[UILabel alloc] initWithFrame:frame];
    uniformColorLbl.backgroundColor = [UIColor clearColor];
    [uniformColorLbl setText:@"Uniform Color:"];
    [uniformColorLbl setFont:[UIFont systemFontOfSize:12.0f]];
    [uniformColorLbl setTextColor:[UIColor blackColor]];
    [self.view addSubview:uniformColorLbl];
    
    frame = CGRectMake(110, 50, 200, 30);
    self.uniformColorTField = [[UITextField alloc] initWithFrame:frame];
    self.uniformColorTField.placeholder = @"Uniform Color";
    [self.uniformColorTField setFont:[UIFont systemFontOfSize:12.0f]];
    self.uniformColorTField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:self.uniformColorTField];
}

- (void)setViewControllerStyle:(LMViewControllerStyle)mViewControllerStyle
{
    //configure the UI
    UIBarButtonItem *rightItem = nil;
    if ( LMViewControllerStyleDisplay == mViewControllerStyle ) {
        self.title = self.team.name;
        
        [self.nameTField setText:self.team.name];
        self.nameTField.enabled = NO;
        [self.uniformColorTField setText:self.team.uniformColor];
        self.uniformColorTField.enabled = NO;
        
        rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction:)];
    }
    else if ( LMViewControllerStyleAdd == mViewControllerStyle )
    {
        self.title = @"Add Team";
        
        self.nameTField.enabled = YES;
        self.uniformColorTField.enabled = YES;
        
        rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveAction:)];
    }
    else if ( LMViewControllerStyleEdit == mViewControllerStyle )
    {
        self.title = self.team.name;
        
        self.nameTField.enabled = YES;
        self.uniformColorTField.enabled = YES;
        [self.nameTField becomeFirstResponder];
        
        rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveAction:)];
    }
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _viewControllerStyle = mViewControllerStyle;
}

#pragma mark - Action Method
- (void)editAction:(id)sender
{
    self.viewControllerStyle = LMViewControllerStyleEdit;
}

- (void)saveAction:(id)sender
{
    if ( [self.nameTField.text length] == 0 || [self.uniformColorTField.text length] == 0 ) {
        return;
    }
    
    LMAppDelegate *appDelegate = (LMAppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    if ( nil == self.team ) {
        Team *team = [NSEntityDescription insertNewObjectForEntityForName:kEntityTeam inManagedObjectContext:context];
        self.team = team;
    }
    [self.team setValue:[self.nameTField text] forKey:kTeamName];
    [self.team setValue:[self.uniformColorTField text] forKey:kTeamUniformColor];

    [appDelegate saveContext];
    
    self.viewControllerStyle = LMViewControllerStyleDisplay;
}
@end
