//
//  BelModel.m
//  Article
//
//  Created by 小强 on 16/10/26.
//  Copyright © 2016年 xiaoqiang. All rights reserved.
//

#import "BelModel.h"

@implementation BelModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString: @"id"] ) {
       self.id1 =value;
    }
}
@end
