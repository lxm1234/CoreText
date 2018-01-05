//
//  CoreTextLinkData.h
//  CoreTextDemo
//
//  Created by lxm on 2018/1/5.
//  Copyright © 2018年 lixiaomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreTextLinkData : NSObject
@property (strong,nonatomic) NSString* title;
@property (strong,nonatomic) NSString* url;
@property (assign,nonatomic) NSRange range;
@end
