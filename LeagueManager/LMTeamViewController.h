//
//  LMTeamViewController.h
//  LeagueManager
//
//  Created by lyfing on 13-10-21.
//  Copyright (c) 2013年 lyfing.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Team.h"

@interface LMTeamViewController : UIViewController
@property (nonatomic,strong) Team *team;
- (id)initWithTeam:(Team *)team withViewControllerStyle:(LMViewControllerStyle)style;
@end
