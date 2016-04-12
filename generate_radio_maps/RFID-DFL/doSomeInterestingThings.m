%simulate an object walking within the room, to verify the generated radio map

clc;
clear;
roomLength = 20;
roomWidth = 15;
gridSize = 0.1;
attenuationFactor = 20;
ellipse_size = 0.1;

%if out of memory, change the parameters: 'ellipse_size' --> [0.2 0.5 1],
%or go to deployRFID.m and reduce the number of Tags.

fingerprint = get_ezDFL_radio_map(roomLength, roomWidth, gridSize, attenuationFactor, ellipse_size);
[ readerPosition, tagPosition, links, linkDistance, readerNumbers, tagNumbers ] = deployRFID(roomLength, roomWidth);
attenuation = 20 * log(1 ./ linkDistance);
tmp = repmat(attenuation', (roomLength / gridSize - 1) * (roomWidth / gridSize - 1), 1);
initialRadioMap = reshape(tmp, roomLength / gridSize - 1, roomWidth / gridSize - 1, size(links, 1));

trace = getRandomTrace(roomLength, roomWidth, 1000);
trace = round(trace * 10) / 10;

draw_RFID_deployment(roomLength, roomWidth);
h1 = plot(trace(1, 1), trace(1, 2));
% hold on; axis([-2, roomLength + 2, -2, roomWidth + 2]);
h(1) = plot(trace(1, 1), trace(1, 2));


for t = 2 : length(trace)
    delete(h1);
    disp(t);
    for i = 1 : length(h)
        delete(h(i));
    end
    idx = abs(fingerprint(trace(t, 1) * 10, trace(t, 2) * 10, :) - initialRadioMap(trace(t, 1) * 10, trace(t, 2) * 10, :)) > 0.1;
    blockedLinks = links(idx(:), :);
    h = plot(0, 0);
    for i = 1 : size(blockedLinks)
        h(i) = plot(blockedLinks(i, [1 3]), blockedLinks(i, [2 4]), 'c'); hold on;
    end
    h1 = plot(trace(t, 1), trace(t, 2), 'b.', 'markerSize', 30); hold on; 
    pause(0.01);
    
    
%% 生成动画
    m(:,t-1)=getframe;            %将图形保存到m矩阵    
    M=getframe(gcf);
    nn=frame2im(M);
    [nn,cm]=rgb2ind(nn,256);
    if t-1==1
        imwrite(nn,cm,'out.gif','gif','LoopCount',inf,'DelayTime',0.01);% 说明loopcount只是在i==1的时候才有用
    else
        %[nn,cm]=rgb2ind(nn,256);
        imwrite(nn,cm,'out.gif','gif','WriteMode','append','DelayTime',0.01)%当i>=2的时候loopcount不起作用
    end
%%
end