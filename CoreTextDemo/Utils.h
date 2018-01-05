//
//  Utils.h
//  CoreTextDemo
//
//  Created by lxm on 2018/1/5.
//  Copyright © 2018年 lixiaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CoreTextLinkData;
@class CoreTextData;
@interface Utils : NSObject
+ (CoreTextLinkData *)touchLinkInView:(UIView*)view atPoint:(CGPoint)point data:(CoreTextData*)data;
@end
