//
//  NSKeyedArchiver+TCExtension.h
//  GetOn
//
//  Created by Cerko on 16/1/10.
//  Copyright © 2016年 Tonchema. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN
@interface NSKeyedArchiver (TCExtension)

/**
 *  归档
 *
 *  @param rootObject 要归档的数据
 *  @param fileName   归档文件名
 *
 *  @return YES 归档成功
 */
+ (BOOL)archiveRootObject:(id)rootObject toFileName:(NSString *)fileName;


@end


@interface NSKeyedUnarchiver (TCExtension)

/**
 *  解档
 *
 *  @param fileName 解档文件名
 *
 *  @return 解档后的数据
 */
+ (nullable id)unarchiveObjectWithFileName:(NSString *)fileName;

@end

NS_ASSUME_NONNULL_END
