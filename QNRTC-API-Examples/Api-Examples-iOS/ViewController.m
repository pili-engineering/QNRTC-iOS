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

static NSString *TABLE_VIEW_CELL_IDENTIFIER = @"TABLE_VIEW_CELL_IDENTIFIER";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *exampleList;
@property (nonatomic, strong) NSArray *moduleList;
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
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)setupDataSource {
    
    self.moduleList = @[
        @"视频通话相关",
        @"纯音频通话相关",
//        @"房间相关",
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
//        @[
//            @{
//                @"desc": @"快速切换房间",
//                @"class": @"SwitchRoomExample"
//            },
//            @{
//                @"desc": @"加入多个房间",
//                @"class": @"MultiRoomsExample"
//            }
//        ],
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
    NSString *classStr = self.exampleList[indexPath.section][indexPath.row][@"class"];
    Class class = NSClassFromString(classStr);
    if (class) {
        [self.navigationController pushViewController:[class new] animated:YES];
    }
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
