//
//  main.m
//  NSColorList
//
//  Created by sunyanguo on 4/6/15.
//  Copyright (c) 2015 sunyanguo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

//字体颜色
NSString *const cTextBlack_Color = @"00000064"; //一号字体黑色 0,0,0
NSString *const cTextDarkGray_Color = @"66666664"; //二号字体黑灰色 102,102,102
NSString *const cTextLightGray_Color = @"aaaaaa64"; //三号字体灰色 170,170,170
NSString *const cTextWhite_Color = @"ffffff64"; //四号字体白色 255,255,255
NSString *const cTextRed_Color = @"d3077564"; //价格字体红色 211,7,117

//主色调
NSString *const cMainBackground_Color = @"f8f8f864"; //主背景色 248,248,248
NSString *const cMainRed_Color = @"d3077564"; //主色调红色 211,7,117
NSString *const cMainBlack_Color = @"3232325f"; //主色调黑色 50,50,50 透明度95%
NSString *const cMainWhite_Color = @"ffffff64"; //主色调白色 255,255,255

//辅助色
NSString *const cAssistBlue_Color = @"5598dc64"; //辅助色蓝色 85,152,220
NSString *const cAssistOrange_Color = @"ff740d64"; //辅助色橙色 255,116,13
NSString *const cAssistGreen_Color = @"7bc73064"; //辅助色绿色 123,199,48
NSString *const cAssistPurple_Color = @"c672e164"; //辅助色紫色 198,114,225
NSString *const cAssistGray_Color = @"aaaaaa64"; //辅助色灰色 170,170,170

NSString *const cLine_Split_Cell_Color = @"dddddd64"; //Cell分割线颜色 221,221,221

NSString *const cBackground_CellSelected_Color = @"eeeeee64"; //Cell选中颜色 238,238,238

NSString *const cBackground_DialogMessage_Color = @"18181864"; //提示框背景色
NSString *const cText_DialogMessage_Color = @"a3a3a364"; //提示框字体颜色

NSColor *hexColor(NSString *hexColor) {
    if ([hexColor hasPrefix:@"#"]) {
        hexColor = [hexColor substringFromIndex:1];
    }
    if ([hexColor length] == 6) {
        hexColor = [hexColor stringByAppendingString:@"64"];
    }
    unsigned int red, green, blue, alpha;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    range.location = 6;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&alpha];
    
    return [NSColor colorWithCalibratedRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:(float)(alpha/100.0f)];
}



int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        NSString *filePath = [NSString stringWithUTF8String:__FILE__];
        NSString *fileContent = [NSString stringWithContentsOfFile:filePath
                                                          encoding:NSUTF8StringEncoding
                                                             error:nil];
        
        NSMutableArray *subColorNameArray = [NSMutableArray new];
        NSMutableArray *subColorValueArray = [NSMutableArray new];

        NSString *regularExpress = @"c\\w*Color\\s.*\";";
        NSRange range = [fileContent rangeOfString:regularExpress options:NSRegularExpressionSearch];
 
        NSRange holeRange = NSMakeRange(0, fileContent.length);
        while (range.location != NSNotFound) {
            NSString *sub = [fileContent substringWithRange:range];
            NSArray *subArray =[sub componentsSeparatedByString:@"="];
            NSString *value = subArray[1];
            value = [value stringByReplacingOccurrencesOfString:@"@" withString:@""];
            value = [value stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            value = [value stringByReplacingOccurrencesOfString:@";" withString:@""];
            value = [value stringByReplacingOccurrencesOfString:@" " withString:@""];
            value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            [subColorValueArray addObject:value];

            value = subArray[0];
            value = [value stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            value = [value stringByReplacingOccurrencesOfString:@" " withString:@""];
            value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            [subColorNameArray addObject:value];
            NSRange searchRange = NSMakeRange(NSMaxRange(range), holeRange.length -NSMaxRange(range));
//            NSLog(@"%@",NSStringFromRange(searchRange));
            range = [fileContent rangeOfString:regularExpress options:NSRegularExpressionSearch range:searchRange];
        }
        NSLog(@"%@",subColorNameArray);
        NSLog(@"%@",subColorValueArray);
        assert([subColorValueArray count] == [subColorNameArray count]);
        if ([subColorNameArray count] == 0) {
            return 0;
        }
//        NSColorList *list2 = [[NSColorList alloc] initWithName:@"Custom" fromFile:[@"~/Library/Colors/Custom.clr" stringByStandardizingPath]]; // 这里要绝对路径
        NSColorList *list = [[NSColorList alloc] init];


        for ( int i=0; i< [subColorNameArray count]; i++) {
            [list setColor:hexColor(subColorValueArray[i]) forKey:subColorNameArray[i]];
        }
        
        
//       NSColorList *colorList = [NSColorList colorListNamed:@"Apple"];
        [list setColor:hexColor(cMainRed_Color) forKey:@"test4"];
//       BOOL ret = [list writeToFile:[@"~/Library/Colors/Custom.clr" stringByStandardizingPath]];
        NSString *fileppp = @"~/Library/Colors/custom.clr";
        NSString *writePath = [fileppp stringByStandardizingPath];// 这里要绝对路径
        BOOL ret = [list writeToFile:writePath];

        assert(ret);
        NSLog(@"%@",list);
        
//        NSLog(@"%@",[NSColorList availableColorLists]);//输出所有的可以用的颜色列表
    }
    return 0;
}
