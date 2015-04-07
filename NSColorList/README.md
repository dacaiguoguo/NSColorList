# NSColorList
用代码实现将常用色值添加到ColorPicker中,生成可在xib中用的色值列表
用正则分析了代码中的变量


1. 颜色命名 要以c开头 以Color 结尾
NSString *const cTextBlack_Color = @"00000064"; //一号字体黑色 0,0,0

2.要16进制的色值

3.正则tips
NSString *regularExpress = @"c\\w*Color\\s.*\";";
\\w 字母数字下划线
* 重复不限次数
\\s 空格
. 为不限字符