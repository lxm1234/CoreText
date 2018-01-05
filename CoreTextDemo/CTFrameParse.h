//
//  CTFrameParse.h
//  CoreTextDemo
//
//  Created by lxm on 2018/1/5.
//  Copyright © 2018年 lixiaomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreTextData.h"
#import "CTFrameParserConfig.h"
@interface CTFrameParse : NSObject
+ (NSDictionary*)attributesWithConfig:(CTFrameParserConfig*)config;
+ (CoreTextData*) parseContent:(NSString*)content config:(CTFrameParserConfig*)config;
+ (CoreTextData*) parseAttributedContent:(NSMutableAttributedString*)content config:(CTFrameParserConfig*)config;
+ (CoreTextData*) parseTemplateFile:(NSString*)path config:(CTFrameParserConfig*)config;
@end
