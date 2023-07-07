//
//  ViewController.m
//  Api-Examples-iOS
//
//  Created by WorkSpace_Sun on 2021/11/24.
//

#import "ViewController.h"
#import "CameraVideoExample.h"
#import "CustomVideoExample.h"
#import "ScreenRecordExample.h"
#import "MicrophoneAudioExample.h"
#import "CustomAudioExample.h"
#import "SwitchRoomExample.h"
#import "MultiRoomsExample.h"
#import "DirectLiveExample.h"
#import "TranscodingLiveDefaultExample.h"
#import "TranscodingLiveCustomExample.h"
#import "AudioMusicMixExample.h"
#import "AudioEffectMixExample.h"
#import "SendMessageExample.h"
#import "MultiProfileExample.h"
#import "ConnectQualityExample.h"
#import "ScanViewController.h"

static NSString *TABLE_VIEW_CELL_IDENTIFIER = @"TABLE_VIEW_CELL_IDENTIFIER";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, ScanViewControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *exampleList;
@property (nonatomic, strong) NSArray *moduleList;
@property (nonatomic, copy) NSString *roomToken;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"API Examples";
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadSubviews];
    [self setupDataSource];
}

- (void)loadSubviews {
    UIButton *scanButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [scanButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [scanButton setImage:[UIImage imageNamed:@"ic_scan"] forState:UIControlStateNormal];
    [scanButton addTarget:self action:@selector(scanAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:scanButton];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)scanAction:(UIButton *)button {
    ScanViewController *scanVc = [ScanViewController new];
    scanVc.delegate = self;
    scanVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:scanVc animated:YES completion:nil];
}

- (void)scanQRResult:(NSString *)qrString {
    if (qrString.length != 0) {
        NSDictionary *dic = [self getDic:qrString];
        if (dic) {
            [self showAlertWithTitle:@"提示" message:@"Token 合法，扫描成功！"];
            self.roomToken = qrString;
            [self.tableView reloadData];
        }
    }
}

- (NSDictionary *)getDic:(NSString *)destRoomTokenString {
    NSArray *componentArray = [destRoomTokenString componentsSeparatedByString:@":"];
    if (componentArray && componentArray.count >= 3) {
        NSString *decodeString = [NSString base64DecodingString:componentArray[2]];
        if (decodeString.length != 0) {
            return [NSString dictionaryWithJSONString:decodeString];
        } else {
            [self showAlertWithTitle:@"错误" message:@"Token 不合法，请重新扫描！"];
            return nil;
        }
    } else {
        [self showAlertWithTitle:@"错误" message:@"Token 不合法，请重新扫描！"];
        return nil;
    }
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [self.navigationController presentViewController:alertController animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertController dismissViewControllerAnimated:NO completion:nil];
            });
        }];
    });
}

- (void)setupDataSource {
    
    self.moduleList = @[
        @"视频通话相关",
        @"纯音频通话相关",
        @"CDN 转推相关",
        @"其他功能"
    ];
    
    self.exampleList = @[
        @[
            @{
                @"desc": @"摄像头采集音视频通话",
                @"class": @"CameraVideoExample"
            },
            @{
                @"desc": @"自定义采集音视频通话",
                @"class": @"CustomVideoExample"
            },
            @{
                @"desc": @"屏幕录制采集音视频通话",
                @"class": @"ScreenRecordExample"
            }
        ],
        @[
            @{
                @"desc": @"麦克风采集纯音频通话",
                @"class": @"MicrophoneAudioExample"
            },
            @{
                @"desc": @"自定义采集纯音频通话",
                @"class": @"CustomAudioExample"
            }
        ],
        @[
            @{
                @"desc": @"CDN 单人转推",
                @"class": @"DirectLiveExample"
            },
            @{
                @"desc": @"CDN 合流转推（默认合流任务）",
                @"class": @"TranscodingLiveDefaultExample"
            },
            @{
                @"desc": @"CDN 合流转推（自定义合流任务）",
                @"class": @"TranscodingLiveCustomExample"
            }
        ],
        @[
            @{
                @"desc": @"音乐文件混音",
                @"class": @"AudioMusicMixExample"
            },
            @{
                @"desc": @"音效文件混音",
                @"class": @"AudioEffectMixExample"
            },
            @{
                @"desc": @"PCM 音源混音",
                @"class": @"AudioSourceMixExample"
            },
            @{
                @"desc": @"发送房间消息",
                @"class": @"SendMessageExample"
            },
            @{
                @"desc": @"大小流",
                @"class": @"MultiProfileExample"
            },
            @{
                @"desc": @"通话质量统计",
                @"class": @"ConnectQualityExample"
            },
            @{
                @"desc": @"跨房媒体转发",
                @"class": @"MediaRelayExample"
            }
        ]
    ];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.moduleList) {
        return self.moduleList.count;
    }
    return 0;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.moduleList) {
        return self.moduleList[section];
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.exampleList) {
        return [self.exampleList[section] count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TABLE_VIEW_CELL_IDENTIFIER];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TABLE_VIEW_CELL_IDENTIFIER];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text =  self.exampleList[indexPath.section][indexPath.row][@"desc"];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.roomToken.length == 0) {
        [self showAlertWithTitle:@"提示" message:@"请点击右上方扫描按钮添加 roomToken！"];
        return;
    }
    NSString *classStr = self.exampleList[indexPath.section][indexPath.row][@"class"];
    Class class = NSClassFromString(classStr);
    if (class) {
        BaseViewController *viewController = [class new];
        viewController.roomToken = self.roomToken;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == self.moduleList.count - 1) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 90)];
        NSArray *infoArray = @[[NSString stringWithFormat:@"SDK 版本：%@", [QNRTC versionInfo]]];
        if (self.roomToken.length != 0) {
            NSArray *componentArray = [self.roomToken componentsSeparatedByString:@":"];
            NSString *decodeString = [NSString base64DecodingString:componentArray[2]];
            NSDictionary *dic = [NSString dictionaryWithJSONString:decodeString];
            infoArray = @[[NSString stringWithFormat:@"用户名：%@", dic[@"userId"]],
                                   [NSString stringWithFormat:@"房间号：%@", dic[ @"roomName"]],
                                   [NSString stringWithFormat:@"SDK 版本：%@", [QNRTC versionInfo]]];
        }
        for (NSInteger i = 0; i < infoArray.count; i++) {
            UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 15 + i* 20, [UIScreen mainScreen].bounds.size.width - 36, 20)];
            infoLabel.text = infoArray[i];
            infoLabel.font = [UIFont systemFontOfSize:12.f];
            infoLabel.textColor = [UIColor blackColor];
            [footerView addSubview:infoLabel];
        }
        return footerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == self.moduleList.count - 1) {
        return 90;
    }
    return 0;
}

#pragma mark - Lazy Loading
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end
