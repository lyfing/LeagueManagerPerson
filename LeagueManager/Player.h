//
//  Player.h
//  LeagueManager
//
//  Created by lyfing on 13-10-30.
//  Copyright (c) 2013年 lyfing.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Person.h"

@class Team;

@interface Player : Person

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) Team *team;

@end
