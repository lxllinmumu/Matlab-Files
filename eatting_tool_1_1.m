function last_supper = eatting_tool_1_1()
%% �Ľ��뷨���ִ�����
%��ֹʱ�䣺eatting_tool 1.1�浽****.**.**ʧ��

%��;����Ҫ������ˣ�209���ң�����ʳ��ѡ����������

%1.0���ܣ��˵�ѡ������˱�дxls��xlsx�˵���
%      ���ֲ���
%      ��Ʒ���ѡ��֧������ɸѡ��
%      ʱ����ʾ
%1.1�������ܣ�

%(�ѽ��) 1.��ν���ʾ��Ϣ��ʾ�ڴ�������¼��ı���ͼ�ϣ��磺���ȣ�;

% 2.��ν�xls�еĲ�Ʒ���ͣ����׷�������ȣ�ɸѡ������ʾ��popupmenu�ϣ�
%   �������ֶ������������;

% 3.���ʹ������Ѻã���������

% 4.����Ż���ʹ��ȡ����ȸ�Ѹ��
%   �ر���matlab��һ������ʱ����ȡ������

% 5.�ò�ʱ��popupmenu����û����Ӧ�ã�ֻ�ǵ������˽���
%   ��Ҫ��ȱ���뷨

% 6.Ĭ�ϱ���ͼƬ��û���ֶ���ӹ��ܣ���Ҫ�������������⣺
%   >>����ֻ����ķһ�������ǲ����ܻ��ģ��Ⱳ�Ӷ������ܻ��ģ�����
%   >>���ڽ����С�̶�����Ӳ�ͬ��СͼƬ���ܵ��±��Σ����������������
%       -_- ͳһ��ӵı���ͼƬ�ߴ磨�����ܲ��Ѻã�
%       -_- ʵ�ֽ���ߴ�ɵ��������Ļ����ܶ�ؼ���Сλ�ö�Ҫ�ı䣩
% uibuttongroup�����Ǹ��������趨����
%Ϊʲô�ڿؼ������ŵ�һ������������ȫ��������
%positionΪ��ֻ�ܴӣ�0,0����ʼ
%���ң�����Ϊ���޷���ʾ�����ܷ���
%% ����ͼ����漰��������ʼ��
%ȫ�ֱ���
global rand_N
global xls_num xls_txt xls_raw
global Select_Type Select_Time
global None_Flag
global BGM
h_figure = figure(1);
set(h_figure,'position',[600 350 400 300],...
    'menubar','none','numbertitle','off','toolbar','none',...
    'name','209�ò͹���','color','white');
mode = 1;
None_Flag = 0;
%��δ��ȡ�¸�ʱ������ָ��Ŀ¼���ļ�
file_path00 = 'E:\Matlab2017a\MATLAB\MatlabR2017a-Program\';
file_path01 = '209_Eatting_Tool\';
file_name0 = 'Ѱ���� - ��������.mp3';
file = [file_path00,file_path01,file_name0];
[BGM_data,Fs] = audioread(file);
BGM = audioplayer(BGM_data,Fs);
%% ��ӱ���ͼƬ������
%·����ͬ
Path = 'E:\Matlab2017a\MATLAB\MatlabR2017a-Program\209_Eatting_Tool\';
LeiMu_JPG_Name = '��ķ';
LeiMu_JPG_File = [Path,LeiMu_JPG_Name];
LeiMu_JPG = imread(LeiMu_JPG_File,'jpg');
hAxes_LeiMu = axes('parent',h_figure);
set(hAxes_LeiMu,'box','off',...
    'xtick',[],'ytick',[],...
    'units','pixels',...
    'position',[0 0 400 300]);
imshow(LeiMu_JPG);
BGM_JPG_Name = '����';
BGM_JPG_File = [Path,BGM_JPG_Name];
BGM_JPG = imresize(imread(BGM_JPG_File,'jpg'),[28,35]);

%% ui�ؼ�
%************************�ı�*************************** 
List_Time_Text = {'���','���','���'};
List_Type_Text = {'����','�׷�','��ʳ','����','��ʳ'};
List_Over_Text = {'�����ò�͵˰~����',...
                  '���ˣ�����ó�~~',...
                  '���ˣ���ϲ����~'};
%************************��ť��*************************** 
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
%**********************��ť�ؼ�***************************
Menu_UI = uicontrol('position',[135 26 46 38],...
                    'style','pushbutton','string','�˵�',...
                    'backgroundcolor',[0.53 0.81 0.91],'fontsize',9,...
                    'fontweight','bold','foregroundcolor','white',...
                    'visible','on',...
                    'callback',@Menu_CallbackFcn);
Start_UI = uicontrol('position',[213 26 46 38],...
                     'style','pushbutton','string','��ʼ',...
                     'backgroundcolor',[0.53 0.81 1],'fontsize',9,...
                     'fontweight','bold','foregroundcolor','white',...
                     'visible','on',...
                     'callback',@Start_CallbackFcn);     
uicontrol('position',[68 85 46 35],...
          'style','text','string','�ò��Ƽ�',...
          'backgroundcolor',[0.98 0.94 0.9],'fontsize',11,...
          'fontweight','bold','foregroundcolor',[1 0.5 0],...
          'visible','on');
%************************************************************  
%*********************������ʫ~~��***************************
uicontrol('position',[13 75 24 150],...
          'style','text','string','�������������',...
          'backgroundcolor',[1 1 1],'fontsize',13,...
          'fontweight','bold','foregroundcolor',[0.53 0.81 1],...
          'visible','on')
uicontrol('position',[363 75 24 150],...
          'style','text','string','�ܷ����������',...
          'backgroundcolor',[1 1 1],'fontsize',13,...
          'fontweight','bold','foregroundcolor',[0.53 0.81 1],...
          'visible','on')
%************************************************************
%***********************������ʾ�ı���***********************
Text_UI1 = uicontrol('position',[120 85 160 35],...
                     'style','text','string','',...
                     'backgroundcolor',[1 1 1],'fontsize',12,...
                     'fontweight','bold',...
                     'visible','on');
Text_UI2 = uicontrol('position',[120 125 160 25],...
                     'style','text','string','��ѡ��...',...
                     'backgroundcolor',[0.97 0.97 1],'fontsize',11,...
                     'fontweight','bold','foregroundcolor','red',...
                     'visible','on');   
Text_UI3 = uicontrol('position',[120 150 160 30],...
                     'style','text',...
                     'string',['Current��',datestr(now,31)],...
                     'backgroundcolor',[1 1 1],'fontsize',10,...
                     'fontweight','bold',...
                     'visible','on'); 
BGM_UI = uicontrol('position',[310 267 35 28],...
                   'string','����',...
                   'backgroundcolor',[1 1 1],'fontsize',7,...
                   'fontweight','bold','foregroundcolor','black',...
                   'visible','on','CData',BGM_JPG,...
                   'Callback',@BGM_CallbackFcn);         
%********************����ʽѡ���*************************                 
Popupmenu_UI1 = uicontrol('position',[55 225 60 55],...
                        'style','popupmenu','fontsize',9,...
                        'string',List_Time_Text,'fontweight','bold');
Popupmenu_UI2 = uicontrol('position',[285 125 60 55],...
                        'style','popupmenu','fontsize',9,...
                        'string',List_Type_Text,'fontweight','bold');  
set(Popupmenu_UI1,'callback',{@Time_CallbackFcn});
set(Popupmenu_UI2,'callback',{@Type_CallbackFcn});

%% ��ʱ��  
%����ʱ�����
TimePeriod = 0.1;
t = timer('TimerFcn', {@Timer_Callback}, ...
    'ExecutionMode','fixedDelay', 'Period', TimePeriod);
start(t);
set(h_figure,'DeleteFcn',{@Delete_CallbackFcn,t});  

%% �ص�����
    function BGM_CallbackFcn(~,~,~)
        set(BGM_UI,'string','��ȡ��');
        [file_name,file_path] = uigetfile('*.mp3');
        file = [file_path,file_name];
        true_flag = ischar(file);
        if(true_flag)
            [BGM_data,Fs] = audioread(file);
            BGM = audioplayer(BGM_data,Fs);
            set(BGM_UI,'string','������');
            play(BGM);%��������   
        else
            set(BGM_UI,'string','δ��ȡ');
        end
        BGM.StopFcn = @BGM_StopFcn;%����ֹͣ����øú���
        %BGM.StopFcn = 'if mode,play(BGM);end'
        %����д������  
    end
    function BGM_StopFcn(~,~,~)
    %ʵ��ѭ������    
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
    %��ȡxls�˵�
        set(Text_UI2,'string','��ȡ�˵������Ե�...');
        pause(0.15);
        [file_name,file_path] = uigetfile({'*.xls;*.xlsx'});
        file = [file_path,file_name]
        true_flag = ischar(file);
        if(true_flag)
            [xls_num,xls_txt,xls_raw] = xlsread(file);
            rand_N = size(xls_num,1);
            set(Text_UI2,'string','�˵��Ѷ�ȡ');
        else
            set(Text_UI2,'string','δ��ȡ�²˵�');
        end
    end
    function Start_CallbackFcn(~,~,~)
    %���ѡ����ʳ 
    %�����˭������ѡ�������ϣ�
        set(Text_UI2,'string','����ѡ�����Ե�...');    
        cnt = 1;
        random = '����';
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
               Type_Flag = 1;%������ѭ�� 
               None_Flag = 1;
            end
        end
        pause(0.15);    
        Last_Dinner = xls_txt(Res,3) ;  
        if(None_Flag)
            set(Text_UI2,'string','�����ʳ������');
            None_Flag = 0;
        else        
            Over_N = unidrnd(3);
            set(Text_UI2,'string',List_Over_Text(Over_N)); 
        end
        set(Text_UI1,'string',Last_Dinner,...
            'foregroundcolor','red');          
    end
    function Timer_Callback(~,~,~)
    %��ʾʱ�䣨��ܱ�Ҫ��
    %��լ�Ų���֪�����漸���� >> Ц ^*^
        set(Text_UI3,'string',['ʱ�䣺',datestr(now,31)]);
    end
    function Delete_CallbackFcn(~,~,t)
    %���ڹرգ�ֹͣ���в���    
        mode = false;
        stop(BGM);  
%��stop�����Ľ�--->>
%���û�δѡȡ������ֱ���˳����򱨴�
%��Ԥ����������
        stop(t);
        last_supper = fprintf('>>�û����˳�\n');
    end

end