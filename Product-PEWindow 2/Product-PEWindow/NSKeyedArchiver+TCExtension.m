//
//  NSKeyedArchiver+TCExtension.m
//  GetOn
//
//  Created by Cerko on 16/1/10.
//  Copyright © 2016年 Tonchema. All rights reserved.
//

#import "NSKeyedArchiver+TCExtension.h"
#import "AppDelegate.h"


@implementation NSKeyedArchiver (TCExtension)
+ (BOOL)archiveRootObject:(id)rootObject toFileName:(NSString *)fileName{
    return [NSKeyedArchiver archiveRootObject:rootObject toFile:[[AppDelegate currentUserPath] stringByAppendingPathComponent:fileName]];

}
@end

@implementation NSKeyedUnarchiver (TCExtension)

+ (nullable id)unarchiveObjectWithFileName:(NSString *)fileName{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[[AppDelegate currentUserPath] stringByAppendingPathComponent:fileName]];
}

@end
