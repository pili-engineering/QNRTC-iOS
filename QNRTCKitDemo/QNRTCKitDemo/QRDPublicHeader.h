//
//  QNRTCHeader.h
//  QNRTCKitDemo
//
//  Created by 冯文秀 on 2018/1/15.
//  Copyright © 2018年 PILI. All rights reserved.
//

#ifndef QNRTCHeader_h
#define QNRTCHeader_h

#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS

#ifndef ARRAY_SIZE
    #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof(arr[0]))
#endif

/*********************  宽高  *********************/

#define QRD_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define QRD_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define QRD_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define QRD_LOGIN_TOP_SPACE (QRD_iPhoneX ? 140: 100)

/*********************  颜色  *********************/
// 颜色RGB 通用
#define QRD_COLOR_RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

// 主色调
#define QRD_THEME_COLOR QRD_COLOR_RGBA(50,163,211,1)
// 底色
#define QRD_GROUND_COLOR QRD_COLOR_RGBA(21, 21, 21, 1)
// 蓝
#define QRD_HEAD_BLUE_COLOR QRD_COLOR_RGBA(88,140,238,1)
// 黄
#define QRD_HEAD_YELLOW_COLOR QRD_COLOR_RGBA(248,207,94,1)
// 绿
#define QRD_HEAD_GREEN_COLOR QRD_COLOR_RGBA(79,161,106,1)
// 红
#define QRD_HEAD_RED_COLOR QRD_COLOR_RGBA(205,88,73,1)
// 橘
#define QRD_HEAD_ORANGE_COLOR QRD_COLOR_RGBA(255,170,102,1)
// 青
#define QRD_HEAD_CYAN_COLOR QRD_COLOR_RGBA(0,255,255,1)


/*********************  字体  *********************/
#define QRD_LIGHT_FONT(FontSize) [UIFont fontWithName:@"PingFangSC-Light" size:FontSize]
#define QRD_REGULAR_FONT(FontSize) [UIFont fontWithName:@"PingFangSC-Regular" size:FontSize]
#define QRD_BOLD_FONT(FontSize) [UIFont fontWithName:@"HelveticaNeue-Bold" size:FontSize]

// userDefault Key
#define QN_USER_ID_KEY @"QN_USER_ID"
#define QN_APP_ID_KEY @"QN_APP_ID"
#define QN_SET_CONFIG_KEY @"QN_SET_CONFIG"
#define QN_ROOM_NAME_KEY @"QN_ROOM_NAME"
#define QN_RTC_DEMO_APPID @"d8lk7l4ed"

#ifndef dispatch_queue_async_safe
#define dispatch_queue_async_safe(queue, block)\
if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(queue)) == 0) {\
block();\
} else {\
dispatch_async(queue, block);\
}
#endif

#ifndef dispatch_main_async_safe
#define dispatch_main_async_safe(block) dispatch_queue_async_safe(dispatch_get_main_queue(), block)
#endif

#ifndef dispatch_queue_sync_safe
#define dispatch_queue_sync_safe(queue, block)\
if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(queue)) == 0) {\
block();\
} else {\
dispatch_sync(queue, block);\
}
#endif

#ifndef dispatch_main_sync_safe
#define dispatch_main_sync_safe(block) dispatch_queue_sync_safe(dispatch_get_main_queue(), block)
#endif

#endif /* QNRTCHeader_h */
