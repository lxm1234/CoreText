//
//  CTFrameParserConfig.m
//  CoreTextDemo
//
//  Created by lxm on 2018/1/5.
//  Copyright © 2018年 lixiaomeng. All rights reserved.
//

#import "CTFrameParserConfig.h"

@implementation CTFrameParserConfig
- (id)init
{
    self = [super init];
    if (self) {
        _width = 200.0f;
        _fontsize = 16.0f;
        _lineSpace = 8.0f;
        _textColor = RGB(108, 108, 108);
    }
    return self;
}
@end
