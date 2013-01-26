//
//  ConfidentialManager.h
//  Manager
//
//  Created by Yoon Lee on 1/25/13.
//  Copyright (c) 2013 Yoon Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CryptoCoding.h"

@interface ConfidentialManager : NSObject<CryptoCoding>
{
    NSMutableDictionary *contents;
}

// contents
// handles with serialization!
// can be store&load single object
// moreover, store&load plist in bundle (project folder)
@property(nonatomic, retain)NSMutableDictionary *contents;

// class shared static method
+(id)shared;

// adding object to contents
-(void)addContent:(id)obj forKey:(NSString*)key;

// adding bundle plist to contents
// `key` is automatically set as plist filename
// please add filename without extension.
// ex)yoon.plist(x)->yoon(o)
-(void)addBundlePlistContent:(NSString*)filename;

// save with serialization!
-(void)save;

// deleting crypto file
-(void)flush;

@end
