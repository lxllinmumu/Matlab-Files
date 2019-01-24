function last_supper = eatting_tool_1_1()
%% 改进想法及现存问题
%截止时间：eatting_tool 1.1版到****.**.**失败

%用途：主要解决个人（209寝室）对饮食的选择困难问题

%1.0功能：菜单选择（需个人编写xls或xlsx菜单）
%      音乐播放
%      菜品随机选择（支持类型筛选）
%      时间显示
%1.1新增功能：

%(已解决) 1.如何将提示信息显示在带有鼠标事件的背景图上（如：喇叭）;

% 2.如何将xls中的菜品类型（如米饭，汤类等）筛选出，显示于popupmenu上，
%   而不是手动输入各种类型;

% 3.如何使界面更友好，更柔和舒服

% 4.如何优化，使读取计算等更迅速
%   特别是matlab第一次运行时，读取超慢的

% 5.用餐时间popupmenu功能没真正应用，只是单纯做了界面
%   主要是缺少想法

% 6.默认背景图片，没有手动添加功能，主要是两个方面问题：
%   >>老婆只有蕾姆一个！换是不可能换的！这辈子都不可能换的！！！
%   >>由于界面大小固定，添加不同大小图片可能导致变形，解决方法有两个：
%       -_- 统一添加的背景图片尺寸（这样很不友好）
%       -_- 实现界面尺寸可调（这样的话，很多控件大小位置都要改变）
% uibuttongroup到底是个怎样的设定？？
%为什么在控件里必须放第一个？否则其它全部被覆盖
%position为何只能从（0,0）开始
%而且，背景为何无法显示？不管放哪
%% 建立图像界面及变量、初始化
%全局变量
global rand_N
global xls_num xls_txt xls_raw
global Select_Type Select_Time
global None_Flag
global BGM
h_figure = figure(1);
set(h_figure,'position',[600 350 400 300],...
    'menubar','none','numbertitle','off','toolbar','none',...
    'name','209用餐工具','color','white');
mode = 1;
None_Flag = 0;
%当未读取新歌时，播放指定目录下文件
file_path00 = 'E:\Matlab2017a\MATLAB\MatlabR2017a-Program\';
file_path01 = '209_Eatting_Tool\';
file_name0 = '寻道树 - 别了夏天.mp3';
file = [file_path00,file_path01,file_name0];
[BGM_data,Fs] = audioread(file);
BGM = audioplayer(BGM_data,Fs);
%% 添加背景图片和音乐
%路径相同
Path = 'E:\Matlab2017a\MATLAB\MatlabR2017a-Program\209_Eatting_Tool\';
LeiMu_JPG_Name = '蕾姆';
LeiMu_JPG_File = [Path,LeiMu_JPG_Name];
LeiMu_JPG = imread(LeiMu_JPG_File,'jpg');
hAxes_LeiMu = axes('parent',h_figure);
set(hAxes_LeiMu,'box','off',...
    'xtick',[],'ytick',[],...
    'units','pixels',...
    'position',[0 0 400 300]);
imshow(LeiMu_JPG);
BGM_JPG_Name = '喇叭';
BGM_JPG_File = [Path,BGM_JPG_Name];
BGM_JPG = imresize(imread(BGM_JPG_File,'jpg'),[28,35]);

%% ui控件
%************************文本*************************** 
List_Time_Text = {'早餐','午餐','晚餐'};
List_Type_Text = {'随意','米饭','面食','汤类','杂食'};
List_Over_Text = {'主人用餐偷税~嘤嘤',...
                  '主人！这个好吃~~',...
                  '主人！最喜欢了~'};
%************************按钮组*************************** 
BG_UI = uibuttongroup(h_figure,'Position',[0 0 400 300]);
uicontrol(BG_UI,'position',[55 130 40 12],...
          'style','radiobutton',...
          'string',List_Time_Text(1),...
          'visible','on');
uicontrol(BG_UI,'position',[55 145 40 12],...
          'style','radiobutton',...
          'string',List_Time_Text(2));      
uicontrol(BG_UI,'position',[55 160 40 12],...
          'style','radiobutton',...
          'string',List_Time_Text(3));
%**********************按钮控件***************************
Menu_UI = uicontrol('position',[135 26 46 38],...
                    'style','pushbutton','string','菜单',...
                    'backgroundcolor',[0.53 0.81 0.91],'fontsize',9,...
                    'fontweight','bold','foregroundcolor','white',...
                    'visible','on',...
                    'callback',@Menu_CallbackFcn);
Start_UI = uicontrol('position',[213 26 46 38],...
                     'style','pushbutton','string','开始',...
                     'backgroundcolor',[0.53 0.81 1],'fontsize',9,...
                     'fontweight','bold','foregroundcolor','white',...
                     'visible','on',...
                     'callback',@Start_CallbackFcn);     
uicontrol('position',[68 85 46 35],...
          'style','text','string','用餐推荐',...
          'backgroundcolor',[0.98 0.94 0.9],'fontsize',11,...
          'fontweight','bold','foregroundcolor',[1 0.5 0],...
          'visible','on');
%************************************************************  
%*********************哈！作诗~~！***************************
uicontrol('position',[13 75 24 150],...
          'style','text','string','可曾闲来愁沽酒',...
          'backgroundcolor',[1 1 1],'fontsize',13,...
          'fontweight','bold','foregroundcolor',[0.53 0.81 1],...
          'visible','on')
uicontrol('position',[363 75 24 150],...
          'style','text','string','能否相对饮几盅',...
          'backgroundcolor',[1 1 1],'fontsize',13,...
          'fontweight','bold','foregroundcolor',[0.53 0.81 1],...
          'visible','on')
%************************************************************
%***********************操作提示文本框***********************
Text_UI1 = uicontrol('position',[120 85 160 35],...
                     'style','text','string','',...
                     'backgroundcolor',[1 1 1],'fontsize',12,...
                     'fontweight','bold',...
                     'visible','on');
Text_UI2 = uicontrol('position',[120 125 160 25],...
                     'style','text','string','待选择...',...
                     'backgroundcolor',[0.97 0.97 1],'fontsize',11,...
                     'fontweight','bold','foregroundcolor','red',...
                     'visible','on');   
Text_UI3 = uicontrol('position',[120 150 160 30],...
                     'style','text',...
                     'string',['Current：',datestr(now,31)],...
                     'backgroundcolor',[1 1 1],'fontsize',10,...
                     'fontweight','bold',...
                     'visible','on'); 
BGM_UI = uicontrol('position',[310 267 35 28],...
                   'string','音乐',...
                   'backgroundcolor',[1 1 1],'fontsize',7,...
                   'fontweight','bold','foregroundcolor','black',...
                   'visible','on','CData',BGM_JPG,...
                   'Callback',@BGM_CallbackFcn);         
%********************弹出式选择框*************************                 
Popupmenu_UI1 = uicontrol('position',[55 225 60 55],...
                        'style','popupmenu','fontsize',9,...
                        'string',List_Time_Text,'fontweight','bold');
Popupmenu_UI2 = uicontrol('position',[285 125 60 55],...
                        'style','popupmenu','fontsize',9,...
                        'string',List_Type_Text,'fontweight','bold');  
set(Popupmenu_UI1,'callback',{@Time_CallbackFcn});
set(Popupmenu_UI2,'callback',{@Type_CallbackFcn});

%% 定时器  
%用于时间更新
TimePeriod = 0.1;
t = timer('TimerFcn', {@Timer_Callback}, ...
    'ExecutionMode','fixedDelay', 'Period', TimePeriod);
start(t);
set(h_figure,'DeleteFcn',{@Delete_CallbackFcn,t});  

%% 回调函数
    function BGM_CallbackFcn(~,~,~)
        set(BGM_UI,'string','读取中');
        [file_name,file_path] = uigetfile('*.mp3');
        file = [file_path,file_name];
        true_flag = ischar(file);
        if(true_flag)
            [BGM_data,Fs] = audioread(file);
            BGM = audioplayer(BGM_data,Fs);
            set(BGM_UI,'string','播放中');
            play(BGM);%播放音乐   
        else
            set(BGM_UI,'string','未读取');
        end
        BGM.StopFcn = @BGM_StopFcn;%音乐停止则调用该函数
        %BGM.StopFcn = 'if mode,play(BGM);end'
        %两种写法均可  
    end
    function BGM_StopFcn(~,~,~)
    %实现循环播放    
        if mode
            play(BGM);
        end
    end
    function Time_CallbackFcn(~,~,~)
       tick1 = get(Popupmenu_UI2,'value');
       Select_Time = List_Time_Text(tick1);
    end
    function Type_CallbackFcn(~,~,~)
       tick2 = get(Popupmenu_UI2,'value');
       Select_Type = List_Type_Text(tick2);
    end
    function Menu_CallbackFcn(~,~,~)
    %读取xls菜单
        set(Text_UI2,'string','读取菜单，请稍等...');
        pause(0.15);
        [file_name,file_path] = uigetfile({'*.xls;*.xlsx'});
        file = [file_path,file_name]
        true_flag = ischar(file);
        if(true_flag)
            [xls_num,xls_txt,xls_raw] = xlsread(file);
            rand_N = size(xls_num,1);
            set(Text_UI2,'string','菜单已读取');
        else
            set(Text_UI2,'string','未读取新菜单');
        end
    end
    function Start_CallbackFcn(~,~,~)
    %随机选择饮食 
    %随机？谁让我有选择困难嘞！
        set(Text_UI2,'string','正在选择，请稍等...');    
        cnt = 1;
        random = '随意';
        Type_Flag = strcmp(Select_Type,random);
        if(Type_Flag)
           Res = unidrnd(rand_N)+1;
        end
        while(~Type_Flag)
            Res = unidrnd(rand_N)+1;
            Last_Dinner_Txt = xls_txt(Res,2);
            Type_Flag = strcmp(Select_Type,Last_Dinner_Txt);
            cnt = cnt + 1;
            if(cnt==100)
               Type_Flag = 1;%避免死循环 
               None_Flag = 1;
            end
        end
        pause(0.15);    
        Last_Dinner = xls_txt(Res,3) ;  
        if(None_Flag)
            set(Text_UI2,'string','无相关食物，已随机');
            None_Flag = 0;
        else        
            Over_N = unidrnd(3);
            set(Text_UI2,'string',List_Over_Text(Over_N)); 
        end
        set(Text_UI1,'string',Last_Dinner,...
            'foregroundcolor','red');          
    end
    function Timer_Callback(~,~,~)
    %显示时间（这很必要）
    %死宅才不会知道外面几点了 >> 笑 ^*^
        set(Text_UI3,'string',['时间：',datestr(now,31)]);
    end
    function Delete_CallbackFcn(~,~,t)
    %窗口关闭，停止所有操作    
        mode = false;
        stop(BGM);  
%该stop语句需改进--->>
%当用户未选取歌曲而直接退出，则报错
%可预输入歌曲解决
        stop(t);
        last_supper = fprintf('>>用户已退出\n');
    end

end