//
//  TalkModel.m
//  Product-PEWindow
//
//  Created by qianfeng on 16/4/22.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "TalkModel.h"

@implementation TalkModel

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.createTime forKey:@"createTime"];
    [aCoder encodeObject:self.nickname forKey:@"nickname"];
    [aCoder encodeObject:self.headImg forKey:@"headImg"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    self = [super init];
    if (self)
    {
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.createTime = [aDecoder decodeObjectForKey:@"createTime"];
        self.nickname = [aDecoder decodeObjectForKey:@"nickname"];
        self.headImg = [aDecoder decodeObjectForKey:@"headImg"];
    }
    return self;
}

@end
