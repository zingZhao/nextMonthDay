//
//  ViewController.m
//  计算当前时间一个月内的星期数
//
//  Created by 赵奎博 on 2016/12/1.
//  Copyright © 2016年 赵奎博. All rights reserved.
//

#import "ViewController.h"
#import "zkb_tool.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self zkbHaveWeeksAndDaysFromDate:@"2016年6月19日" needMonth:1];
}

/**
 months表示几个月后
 */
-(void)zkbHaveWeeksAndDaysFromDate:(NSString *)startDay needMonth:(NSInteger)months{
    
    NSString * form = @"yyyy年MM月dd日";
    
    //计算之后的时间
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setYear:0];
    
    [adcomps setMonth:months];
    
    [adcomps setDay:0];
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    
    [formatter1 setDateFormat:form];//此处使用的formater格式要与字符串格式完全一致，否则转换失败
    [formatter1 setTimeZone:[NSTimeZone localTimeZone]];//将字符串转换成日期
        
    NSDate *date = [formatter1 dateFromString:startDay];
    
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:date options:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:form];
    
#pragma mark --- 一个月后的时间
    NSString * str = [dateFormatter stringFromDate:newdate];
    
    NSInteger days = ([zkb_tool timeTodata:str] - [zkb_tool timeTodata:startDay]) / 3600 / 24;
    
    NSDateComponents *_comps = [[NSDateComponents alloc] init];
    _comps.calendar.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    
    NSArray * ary_week = [[zkb_tool data_Totime:([zkb_tool timeTodata:startDay] * 1000)] componentsSeparatedByString:@"-"];
    [_comps setDay:[NSString stringWithFormat:@"%@",ary_week[2]].integerValue];
    [_comps setMonth:[NSString stringWithFormat:@"%@",ary_week[1]].integerValue];
    [_comps setYear:[NSString stringWithFormat:@"%@",ary_week[0]].integerValue];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *_date = [gregorian dateFromComponents:_comps];
    NSDateComponents *weekdayComponents =
    [gregorian components:NSCalendarUnitWeekday fromDate:_date];
    
#pragma mark --- 当前是周几
    NSString * week = @"0";
    if(weekdayComponents.weekday == 1){
        week = @"7";
    }else{
        week = [NSString stringWithFormat:@"%ld",weekdayComponents.weekday - 1];
    }
    NSInteger weeks = days / 7;
    NSInteger otherDays = days % 7;
    NSInteger nextweek = (otherDays + week.integerValue) % 7;
    
    NSLog(@"------%ld\n--------%ld\n-----------周%@\n-----------下个月是周%ld",weeks,otherDays,week,nextweek);
    
    NSMutableArray * array = [NSMutableArray arrayWithArray:@[[NSString stringWithFormat:@"%ld",weeks],[NSString stringWithFormat:@"%ld",weeks],[NSString stringWithFormat:@"%ld",weeks],[NSString stringWithFormat:@"%ld",weeks],[NSString stringWithFormat:@"%ld",weeks],[NSString stringWithFormat:@"%ld",weeks],[NSString stringWithFormat:@"%ld",weeks]]];
    
    int i=0;
    if(nextweek < otherDays){
        while (i < otherDays) {
            NSString * str = array[(week.intValue + i) % 7];
            [array replaceObjectAtIndex:(week.intValue + i) % 7 withObject:[NSString stringWithFormat:@"%ld",str.integerValue + 1]];
            ++i;
        }
    }else{
        while (i < otherDays) {
            NSString * str = array[(week.intValue + i) % 7];
            [array replaceObjectAtIndex:(week.intValue + i) % 7 withObject:[NSString stringWithFormat:@"%ld",str.integerValue + 1]];
            ++i;
        }
    }
    
    NSLog(@"%@",array);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
