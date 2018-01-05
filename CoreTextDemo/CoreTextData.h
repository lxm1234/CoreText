//
//  CoreTextData.h
//  CoreTextDemo
//
//  Created by lxm on 2018/1/5.
//  Copyright © 2018年 lixiaomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface CoreTextData : NSObject
@property (assign,nonatomic) CTFrameRef ctFrame;
@property (assign,nonatomic) CGFloat height;
@property (strong,nonatomic) NSArray* imageArray;
@property (strong,nonatomic) NSArray* linkArray;
@end
