//
//  TDAliPayModel.h
//  edX
//
//  Created by Elite Edu on 17/1/14.
//  Copyright © 2017年 edX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDAliPayModel : NSObject

- (instancetype)initWithOrder:(NSDictionary *)order;

//总金额
@property (nonatomic,strong) NSString *total_fee;
//商户网站唯一订单号
@property (nonatomic,strong) NSString *out_trade_no;
//商品名称
@property (nonatomic,strong) NSString *subject;
//商品详情
@property (nonatomic,strong) NSString *body;

//卖家支付宝账号
@property (nonatomic,strong) NSString *seller_email;
//卖家支付宝ID
@property (nonatomic,strong) NSString *seller_id;
//接口名称
@property (nonatomic,strong) NSString *service;
//参数编码字符集
@property (nonatomic,strong) NSString *_input_charset;
//签名
@property (nonatomic,strong) NSString *sign;
//支付类型
@property (nonatomic,strong) NSString *payment_type;
//服务器异步通知页面路径
@property (nonatomic,strong) NSString *notify_url;
//签名方式
@property (nonatomic,strong) NSString *sign_type;
//合作者身份ID
@property (nonatomic,strong) NSString *partner;
//该笔订单允许的最晚付款时间，逾期将关闭交易。
@property (nonatomic,strong) NSString *it_b_pay;


@end
