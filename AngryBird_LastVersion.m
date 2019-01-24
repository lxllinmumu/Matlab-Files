function y = test03()
%% create figure and set its properties
% prepare the angrybird image in jpg format, read it with alp parameter

%% 
file_path = 'E:\Matlab2017a\MATLAB\MatlabR2017a-Program\知乎-angrybird\';
file_name2 = 'bird_yellow';
angryBird = imresize(imread([file_path,file_name2],'png'),[20 20]);
file_name1 = 'background_bird';
backGround = imresize(imread([file_path,file_name1],'jpg'),[300,500]);
back_Size = size(backGround);

hFigure1 = figure(1);
set(gcf, 'Name',' Angry Bird is Flying',...
    'position',[400 350 500 300],...
    'NumberTitle','off','toolbar','none','MenuBar','none', ...
    'color','w', ...
    'DoubleBuffer','on');
% create axes2 for AngryBird
hAxes_AB = axes('Parent', hFigure1);
set(hAxes_AB, 'box','off', ...
    'xtick',[], 'ytick',[],...
    'units','pixels',...
    'position',[250 150 20 20]);
% create axes1 for BKGround 
hAxes_BKG = axes('Parent', hFigure1);
set(gca, 'box','off',...
    'xtick',[], 'ytick',[],...
    'units','pixels',...
    'position',[0 0 500 300]);
%show imgBackGround
h_BKG = imshow(backGround);
Text_Position = uicontrol('Parent',hFigure1, ...
    'Style','text',...
    'Position',[0 0 500 16],...
    'HorizontalAlignment','Left',...
    'String',' ',...
    'BackgroundColor','green',...
    'visible','on');
% ------------ prepare parameters and initialize the timer ---------------
hAxes_AB_x = 250;hAxes_AB_y = 150;
timePeriod = 0.01;v_AB = 170;theta = 0;
v_AB_x = v_AB * cos(theta);v_AB_y = v_AB * sin(theta);
% Initialize the timer
% ------------ Binding Event-Function --------------
t = timer('TimerFcn', {@timerCallback, hAxes_AB}, 'ExecutionMode',...
    'fixedDelay', 'Period', timePeriod);
set(hFigure1, 'DeleteFcn', {@DeleteFcn, t});
set(h_BKG, 'ButtonDownFcn', @ButtonDownFcn);
cnt = 2;
%  new_handles = guidata(hFigure1);

%% pushbutton
enter_ui = uicontrol('Position',[20 20 50 30],'String','enter',...
          'FontWeight','bold','FontSize',10,...
          'Style','pushbutton',...
          'ForeGroundColor','red',...
          'Callback',{@PushButton1_Callback,t});
      
%% -->PushButton Function 
    function PushButton1_Callback(~,~,t)
        if(cnt == 2)
            delete(enter_ui);
            % show the angrybird
            axes(hAxes_AB);
            h_AB = imshow(angryBird);
            %AB_thresh = graythresh(angryBird);
            AB_thresh = 0.9;
            set(h_AB, 'AlphaData',AB_thresh);
            cnt = 0;
        uicontrol('Position',[20 20 50 30],'String','Start',...
                  'FontWeight','bold','FontSize',10,...
                  'Style','pushbutton',...
                  'ForeGroundColor','red',...
                  'Callback',{@PushButton1_Callback,t});
        uicontrol('Position',[150 20 50 30],'String','Stop',...
                  'FontWeight','bold','FontSize',10,...
                  'Style','pushbutton',...
                  'ForeGroundColor','red',...
                  'Callback',{@PushButton2_Callback,t});
        elseif(cnt == 0)
            start(t);cnt = cnt + 1;
        else
            stop(t);cnt = 0;
        end
    end
    function PushButton2_Callback(~,~,t)
    stop(t);
    end

%% -->Button Down Function on the hAxes_BKG
    function ButtonDownFcn(~,~,~)
    AB_Position = get(hAxes_AB, 'position');
    pt = get(hAxes_BKG, 'CurrentPoint');%获取坐标比例
    hAxes_AB_x = AB_Position(1);
    hAxes_AB_y = AB_Position(2);
    pt_x = pt(1);
    pt_y = back_Size(1) - pt(3);
    % 4 situations:
    if pt_x > hAxes_AB_x && pt_y > hAxes_AB_y
    delta_x = pt_x - hAxes_AB_x;
    delta_y = pt_y - hAxes_AB_y;
    theta = atan(delta_y/delta_x);
    v_AB_x = abs(v_AB * cos(theta));
    v_AB_y = abs(v_AB * sin(theta));
    else
        if pt_x > hAxes_AB_x && pt_y < hAxes_AB_y
        delta_x = pt_x - hAxes_AB_x;
        delta_y = hAxes_AB_y - pt_y;
        theta = atan(delta_y/delta_x);
        v_AB_x = abs(v_AB * cos(theta));
        v_AB_y = -abs(v_AB * sin(theta));
        else
            if pt_x < hAxes_AB_x && pt_y < hAxes_AB_y
            delta_x = hAxes_AB_x - pt_x;
            delta_y = hAxes_AB_y - pt_y;
            theta = atan(delta_y/delta_x);
            v_AB_x = -abs(v_AB * cos(theta));
            v_AB_y = -abs(v_AB * sin(theta));
            else
            delta_x = hAxes_AB_x - pt_x;
            delta_y = pt_y - hAxes_AB_y ;
            theta = atan(delta_y/delta_x);
            v_AB_x = -abs(v_AB * cos(theta));
            v_AB_y = abs(v_AB * sin(theta));
            end
        end
    end
    tmpString = sprintf('hAxes_AB_x:%.3f, hAxes_AB_y:%.3f, pt_x:%.3f, pt_y:%.3f',...
    hAxes_AB_x, hAxes_AB_y, pt_x, pt_y); 
    set(Text_Position, 'String', tmpString,...
        'FontSize',8);
    end

%% -->timerCallback Function
    function timerCallback(~,~,hAxes_AB)
    hAxes_AB_position = get(hAxes_AB, 'position');
    hAxes_AB_x = hAxes_AB_position(1);
    hAxes_AB_y = hAxes_AB_position(2);
    delta_d_x = v_AB_x * timePeriod;
    delta_d_y = v_AB_y * timePeriod;
    hAxes_AB_x = hAxes_AB_x + delta_d_x;
    hAxes_AB_y = hAxes_AB_y + delta_d_y;
    set(hAxes_AB, 'position',...
    [hAxes_AB_x hAxes_AB_y hAxes_AB_position(3) hAxes_AB_position(4)]);
        if hAxes_AB_x > 480 || hAxes_AB_x < 0 
        v_AB_x = -v_AB_x;
        end
        if hAxes_AB_y > 280 || hAxes_AB_y < 16
        v_AB_y = - v_AB_y;
        end
    end

%% -->DeleteFcn Function
    function DeleteFcn(~,~,t)
    stop(t);
    y = string(fprintf('Game Over!\n'));
    end

end