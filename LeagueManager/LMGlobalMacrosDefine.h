//
//  LMGlobalMacrosDefine.h
//  LeagueManager
//
//  Created by lyfing on 13-5-22.
//  Copyright (c) 2013年 lyfing.com. All rights reserved.
//

#ifndef LeagueManager_LMGlobalMacrosDefine_h
#define LeagueManager_LMGlobalMacrosDefine_h

/*
*Global UI Macros
*/
#define kSystemNavigationBarHeight 44.0f

/*
 *Mark for coredata
 */
#define kTeamName @"name"
#define kTeamUniformColor @"uniformColor"
#define kPlayerEmail @"email"
#define kPlayerLastName @"lastName"
#define kPlayerFirstName @"firstName"
#define kEntityTeam @"Team"
#define kEntityPlayer @"Player"
#define kEntityPerson @"Person"
#define kTeam @"team"
#define kPlayer @"player"
#define kPlayers @"players"
#define kPersonAge @"age"
#define kPersonSignature @"signature"

typedef NS_ENUM(NSInteger, LMViewControllerStyle)
{
    LMViewControllerStyleDisplay,
    LMViewControllerStyleAdd,
    LMViewControllerStyleEdit
};

/*
 *Notification
 */
#define kNotificationType @"kNotificationType"
#define kNotificationObject @"kNotificationObject"

#define kNotificationPlayerChanged @"kNotificationPlayerChanged"
typedef NS_ENUM(NSInteger, LMPlayerChangedType)
{
    LMPlayerChangedTypeNone,
    LMPlayerChangedTypeAdd,
    LMPlayerChangedTypeDelete,
    LMPlayerChangedTypeModify
};

/*
*Switch Macros
*/
//#define kSiwtchStoreTypeMemory
#endif
