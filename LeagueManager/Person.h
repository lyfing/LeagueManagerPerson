//
//  Person.h
//  LeagueManager
//
//  Created by lyfing on 13-10-30.
//  Copyright (c) 2013年 lyfing.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Person : NSManagedObject

@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSString * signature;

@end
