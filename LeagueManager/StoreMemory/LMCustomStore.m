//
//  LMCustomStore.m
//  LeagueManager
//
//  Created by lyfing on 13-10-22.
//  Copyright (c) 2013年 lyfing.com. All rights reserved.
//

#import "LMCustomStore.h"
@interface LMCustomStore()
@property (nonatomic,strong) NSMutableDictionary *nodeCacheRefArrays;
@end

@implementation LMCustomStore


- (id)initWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator configurationName:(NSString *)configurationName URL:(NSURL *)url options:(NSDictionary *)options
{
    if ( self = [super initWithPersistentStoreCoordinator:coordinator configurationName:configurationName URL:url options:options]) {
        NSDictionary *metadata = [LMCustomStore metadataForPersistentStoreWithURL:[self URL] error:nil];
        
        [self setMetadata:metadata];
        self.nodeCacheRefArrays = [NSMutableDictionary dictionary];
    }
    
    return self;
}


#pragma mark - NSPersistentStore
- (NSString *)type
{
    return [[self metadata] objectForKey:NSStoreTypeKey];
}

- (NSString *)identifier
{
    return [[self metadata] objectForKey:NSStoreUUIDKey];
}

#pragma mark - NSAtomicStore
- (BOOL)load:(NSError *__autoreleasing *)error
{
    return YES;
}

- (id)newReferenceObjectForManagedObject:(NSManagedObject *)managedObject
{
    NSString *uuid = [LMCustomStore makeUUID];
    
    return uuid;
}

- (NSAtomicStoreCacheNode *)newCacheNodeForManagedObject:(NSManagedObject *)managedObject
{
    NSManagedObjectID *oID = [managedObject objectID];
    id referenceID = [self referenceObjectForObjectID:oID];
    NSAtomicStoreCacheNode *node = [self nodeForReferenceObject:referenceID andObjectID:oID];
    [self updateCacheNode:node fromManagedObject:managedObject];
    
    return node;
}

- (void)updateCacheNode:(NSAtomicStoreCacheNode *)node fromManagedObject:(NSManagedObject *)managedObject
{
    NSEntityDescription *entityDescription = [managedObject entity];
    NSDictionary *attributes = [entityDescription attributesByName];
    for ( NSString *name in [attributes allKeys] ) {
        [node setValue:[managedObject valueForKey:name] forKey:name];
    }
    
    NSDictionary *relationships = [entityDescription relationshipsByName];
    for ( NSString *name in [relationships allKeys] ) {
        id value = [managedObject valueForKey:name];
        if ( [[relationships valueForKey:name] isToMany] ) {
            NSSet *set = (NSSet *)node;
            NSMutableSet *data = [NSMutableSet set];
            for ( NSManagedObject *obj in set ) {
                NSManagedObjectID *oID = [obj objectID];
                id referenceID = [self referenceObjectForObjectID:oID];
                NSAtomicStoreCacheNode *n = [self nodeForReferenceObject:referenceID andObjectID:oID];
                [data addObject:n];
            }
            [node setValue:data forKey:name];
        }
        else
        {
            NSManagedObject *managedObj = (NSManagedObject *)value;
            NSManagedObjectID *oID = [managedObj objectID];
            id referenceID = [self referenceObjectForObjectID:oID];
            NSAtomicStoreCacheNode *n = [self nodeForReferenceObject:referenceID andObjectID:oID];
            [node setValue:n forKey:name];
        }
    }
}

- (NSAtomicStoreCacheNode *)nodeForReferenceObject:(id)reference andObjectID:(NSManagedObjectID *)oID
{
    NSAtomicStoreCacheNode *node = [self.nodeCacheRefArrays objectForKey:reference];
    if ( nil == node ) {
        node = [[NSAtomicStoreCacheNode alloc] initWithObjectID:oID];
        [self.nodeCacheRefArrays setObject:node forKey:reference];
    }
    
    return node;
}

- (BOOL)save:(NSError *__autoreleasing *)error
{
    return YES;
}

#pragma mark - Class Method
+ (NSDictionary *)metadataForPersistentStoreWithURL:(NSURL *)url error:(NSError *__autoreleasing *)error
{
    NSString *path = [[url relativePath] stringByAppendingString:@".plist"];
    
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:path] ) {
        NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
        [mdic setValue:NSStringFromClass([self class]) forKey:NSStoreTypeKey];
        [mdic setValue:[LMCustomStore makeUUID] forKey:NSStoreUUIDKey];
        
        [LMCustomStore writeMetadata:mdic toURL:url];
        
        [@"" writeToURL:url atomically:YES encoding:[NSString defaultCStringEncoding] error:nil];
    }
    
    return [NSDictionary dictionaryWithContentsOfFile:path];
}

+ (BOOL)writeMetadata:(NSDictionary *)metadata toURL:(NSURL *)url
{
    NSString *path = [[url relativePath] stringByAppendingString:@".plist"];
    
    return [metadata writeToFile:path atomically:YES];
}

/**
 *	@brief	Generate the UUID
 */
+ (NSString *)makeUUID
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuidStringRef];
    CFRelease(uuidStringRef);
    
    return uuid;
}
@end
