//
//  LMPlayViewController.h
//  LeagueManager
//
//  Created by lyfing on 13-10-21.
//  Copyright (c) 2013年 lyfing.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"
#import "Team.h"

@interface LMPlayerViewController : UIViewController
@property (nonatomic,assign) LMViewControllerStyle viewControllerStyle;
- (id)initWithPlayer:(Player *)player andTeam:(Team *)team withViewType:(LMViewControllerStyle)view;
@end
