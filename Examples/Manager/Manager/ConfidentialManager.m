//
//  ConfidentialManager.m
//  Manager
//
//  Created by Yoon Lee on 1/25/13.
//  Copyright (c) 2013 Yoon Lee. All rights reserved.
//

#import "ConfidentialManager.h"
#import <CommonCrypto/CommonDigest.h>
#define kContents                           @"kMapFiles"
#define kOutputFileName                     @"Confidential.plist"
#define TTX_READABLE_PASSWORD               @"CRYPTO_FOR_FUN"

@interface ConfidentialManager()

+(NSString*)sha1:(NSString*)input;

@end

@implementation ConfidentialManager
@synthesize contents;

#pragma mark -
#pragma mark NSCoding

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        id savedResource = [aDecoder decodeObjectForKey:kContents];
        [self setContents:savedResource];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.contents forKey:kContents];
}

+(id)shared
{
    static ConfidentialManager *ttxConfidentialShared = nil;
    
    if (ttxConfidentialShared == nil) {
        NSString *path = [[ConfidentialManager documentsDirectory] stringByAppendingPathComponent:kOutputFileName];
        ttxConfidentialShared = [[CryptoCoder unarchiveObjectWithFile:path] retain];
        
        // very first time usage
        if (ttxConfidentialShared == nil) {
            ttxConfidentialShared = [[ConfidentialManager alloc] init];
            ttxConfidentialShared.contents = [[NSMutableDictionary alloc] init];
        }
    }
    
    return ttxConfidentialShared;
}

+(NSString*)sha1:(NSString*)input
{
    // SHA1
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i ++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

+(NSString*)CCPassword
{
    return [ConfidentialManager sha1:TTX_READABLE_PASSWORD];
}

+(NSString *)documentsDirectory
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}

-(void)addContent:(id)obj forKey:(NSString*)key
{
    [self.contents setObject:obj forKey:key];
}

-(void)addBundlePlistContent:(NSString*)filename
{
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];
    NSFileManager *filemanager = [NSFileManager defaultManager];
    if ([filemanager fileExistsAtPath:path]) {
        NSData *tmpData = [NSData dataWithContentsOfFile:path];
        id plist = [NSPropertyListSerialization propertyListWithData:tmpData options:NSPropertyListOpenStepFormat format:nil error:nil];
        id list = nil;
        
        if ([plist isKindOfClass:[NSDictionary class]]) {
            list = [[NSDictionary alloc] initWithContentsOfFile:path];
        }
        else if ([plist isKindOfClass:[NSArray class]]) {
            list = [[NSArray alloc] initWithContentsOfFile:path];
        }
        
        [self.contents setObject:list forKey:filename];
        [list release];
    }
}

-(void)save
{
    NSString *path = [[ConfidentialManager documentsDirectory] stringByAppendingPathComponent:kOutputFileName];
    [CryptoCoder archiveRootObject:self toFile:path];
}

-(void)flush
{
    NSString *path = [[ConfidentialManager documentsDirectory] stringByAppendingPathComponent:kOutputFileName];
    NSFileManager *filemanager = [NSFileManager defaultManager];
    if ([filemanager fileExistsAtPath:path]) {
        [filemanager removeItemAtPath:path error:nil];
    }
}

-(void)dealloc
{
    [contents release];
    contents = nil;
    [super dealloc];
}

@end

