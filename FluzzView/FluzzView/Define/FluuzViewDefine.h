//
// FluuzViewDefine.h
// FluzzView
//
// Created by wangchaojs02 on 15/3/22.
// Copyright (c) 2015年 wangchaojs02. All rights reserved.
//

#ifndef COLOR_RGBA
    #define COLOR_RGBA(r, g, b, a) \
        [UIColor colorWithRed : (r) / 255.0 green : (g) / 255.0 blue : (b) / 255.0 alpha : a]
    #define COLOR_HEXA(hexValue, alpha) \
        COLOR_RGBA( (hexValue >> 16) & 0xff, (hexValue >> 8) & 0xff, (hexValue >> 0) & 0xff, alpha )

    #define COLOR_HEX(hexValue) COLOR_HEXA(hexValue, 1 )
    #define COLOR_RGB(r, g, b) COLOR_RGBA(r, g, b, 1)

    #define COLOR_RANDOM() COLOR_RGB( arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256) )
#endif /* ifndef COLOR_RGBA */


#ifndef INDEX_PATH
    #define INDEX_PATH(row, section) [NSIndexPath indexPathForRow : row inSection : section]
#endif

#ifndef WEAK_OBJ
    #define WEAK_OBJ(obj) __weak typeof(obj)     __weak_##obj##__     = obj;
    #define STRONG_OBJ(obj) __strong typeof ( __weak_##obj##__  ) obj = __weak_##obj##__;
#endif

#ifndef RANDOM
    #define RANDOM(minimum, maximum) arc4random_uniform( (maximum) - (minimum) ) + (minimum)
#endif

#ifndef YCLog
    #if __has_include(< CocoaLumberjack / CocoaLumberjack.h >)
        #import <CocoaLumberjack/CocoaLumberjack.h>
        #import <CocoaLumberjack/DDDispatchQueueLogFormatter.h>
        #ifdef DEBUG
            static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
        #else
            static const DDLogLevel ddLogLevel = DDLogLevelWarn;
        #endif
        #define TTYCOLOR(hexValue) DDMakeColor( ( (hexValue >> 16) & 0xff ), ( (hexValue >> 8) & 0xff ), ( (hexValue >> 0) & 0xff ) )
        #define YCLogSetup() \
            setenv("XcodeColors", "YES", 0); \
            [DDLog addLogger:[DDTTYLogger sharedInstance]]; \
            [[DDTTYLogger sharedInstance] setForegroundColor:TTYCOLOR(0x731822) backgroundColor:TTYCOLOR(0x032028) forFlag:DDLogFlagError]; \
            [[DDTTYLogger sharedInstance] setForegroundColor:TTYCOLOR(0x6E7318) backgroundColor:TTYCOLOR(0x032028)  forFlag:DDLogFlagWarning]; \
            [[DDTTYLogger sharedInstance] setForegroundColor:TTYCOLOR(0x176D3C) backgroundColor:TTYCOLOR(0x032028)  forFlag:DDLogFlagInfo]; \
            [[DDTTYLogger sharedInstance] setForegroundColor:TTYCOLOR(0x034048) backgroundColor:TTYCOLOR(0x032028)  forFlag:DDLogFlagDebug]; \
            [[DDTTYLogger sharedInstance] setForegroundColor:TTYCOLOR(0x033028) backgroundColor:TTYCOLOR(0x032028)  forFlag:DDLogFlagVerbose]; \
            [[DDTTYLogger sharedInstance] setColorsEnabled:YES]; \
            [[DDTTYLogger sharedInstance] setLogFormatter:[[DDDispatchQueueLogFormatter alloc] init]];

        #define YCLogError    DDLogError
        #define YCLogWarn     DDLogWarn
        #define YCLogInfo     DDLogInfo
        #define YCLogDebug    DDLogDebug
        #define YCLogVerbose  DDLogVerbose
    #else /* if __has_include(< CocoaLumberjack / CocoaLumberjack.h >) */
        #define YCFILE  (strrchr(__FILE__, '/') ? : __FILE__) + 1
        #define YCLog(flag, fmt, ...) printf("%s: %s:%d %s %s\n", flag, YCFILE, __LINE__, __func__, (const char*) [[NSString stringWithFormat:fmt,##__VA_ARGS__] UTF8String])

        #define YCLogSetup()
        #define YCLogError(fmt, ...)    YCLog("E", fmt,##__VA_ARGS__)
        #define YCLogWarn(fmt, ...)     YCLog("W", fmt,##__VA_ARGS__)
        #define YCLogInfo(fmt, ...)     YCLog("I", fmt,##__VA_ARGS__)
        #define YCLogDebug(fmt, ...)    YCLog("D", fmt,##__VA_ARGS__)
        #define YCLogVerbose(fmt, ...)  YCLog("V", fmt,##__VA_ARGS__)
    #endif /* if __has_include(< CocoaLumberjack / CocoaLumberjack.h >) */
    #ifdef NSLog
        #undef NSLog
        #define NSLog YCLogInfo
    #endif
#endif /* ifndef YCLog */
