function IVPointSelection(handles)
%IVPOINTSELECTION Determines if a point at the IV plot has been clicked and plot the S-parameters for that point

    if handles.MeasDone % check if measurement is performed


        % ax1
        ax1position = get(handles.ax1,'CurrentPoint');
        ax1x = ax1position(1,1);
        ax1y = ax1position(1,2);
        ax1xlim = get(handles.ax1,'XLim');
        ax1ylim = get(handles.ax1,'YLim');

        % ax2
        ax2position = get(handles.ax2,'CurrentPoint');
        ax2x = ax2position(1,1);
        ax2y = ax2position(1,2);
        ax2xlim = get(handles.ax2,'XLim');
        ax2ylim = get(handles.ax2,'YLim');    

       
        if (ax1x > ax1xlim(1)) && (ax1x < ax1xlim(2)) && (ax1y > ax1ylim(1)) && (ax1y < ax1ylim(2))
            h = get(handles.ax1, 'Children');
            xdata = get(h(2),'XData');
            ydata = get(h(2),'YData');

            % rescale x and y data
            xdata = (xdata - ax1xlim(1))./(ax1xlim(2)-ax1xlim(1));
            ydata = (ydata - ax1ylim(1))./(ax1ylim(2)-ax1ylim(1));
            ax1x = (ax1x - ax1xlim(1))./(ax1xlim(2)-ax1xlim(1));
            ax1y = (ax1y - ax1ylim(1))./(ax1ylim(2)-ax1ylim(1));

            % Get index to closest data point
            delta = (xdata - ax1x).^2 + (ydata - ax1y).^2;
            [void, index] = min(delta);
            try
                UpdatePlots(handles,index)
            catch
            end
        elseif (ax2x > ax2xlim(1)) && (ax2x < ax2xlim(2)) && (ax2y > ax2ylim(1)) && (ax2y < ax2ylim(2))
            h = get(handles.ax2, 'Children');
            xdata = get(h(2),'XData');
            ydata = get(h(2),'YData');

            % rescale x and y data
            xdata = (xdata - ax2xlim(1))./(ax2xlim(2)-ax2xlim(1));
            ydata = (ydata - ax2ylim(1))./(ax2ylim(2)-ax2ylim(1));
            ax2x = (ax2x - ax2xlim(1))./(ax2xlim(2)-ax2xlim(1));
            ax2y = (ax2y - ax2ylim(1))./(ax2ylim(2)-ax2ylim(1));

            % Get index to closest data point
            delta = (xdata - ax2x).^2 + (ydata - ax2y).^2;
            [void, index] = min(delta);
            try
                UpdatePlots(handles,index)
            catch
            end
        end
    end
end

function UpdatePlots(handles,index)

    global SP_SWP;
    swp = SP_SWP;
    xp = swp(index).data;
    
    h = get(handles.ax1, 'Children');
    set(h(1),'UserData',index);
    set(h(1),'XData',swp.V1(index));
    set(h(1),'YData',abs(swp.I1(index)));        
    h = get(handles.ax2, 'Children');
    set(h(1),'UserData',index);
    set(h(1),'XData',swp.V2(index));
    set(h(1),'YData',swp.I2(index));  

    % update bias boxes
    set(handles.mv1,'String',num2str(round(swp(index).V1.*100)/100));
    set(handles.mi1,'String',num2str(round(swp(index).I1.*1e3.*100)/100));
    set(handles.mv2,'String',num2str(round(swp(index).V2.*100)/100));
    set(handles.mi2,'String',num2str(round(swp(index).I2.*100)/100));



    % update S-param
    if xp.ports == 2
        axes(handles.ax3);
        plot(xp.freq.*1e-9,db(xp.s21),'b');
        xlabel('Frequency [GHz]');
        ylabel('[dB]');
    
        axes(handles.ax4);
        plot(xp.freq.*1e-9,db(xp.s11),xp.freq.*1e-9,db(xp.s22));
        legend('S_1_1','S_2_2','Location','Best');
        xlabel('Frequency [GHz]');
        ylabel('[dB]');
    elseif xp.ports == 1
        axes(handles.ax4);
        plot(xp.freq.*1e-9,db(xp.s11));
        xlabel('Frequency [GHz]');
        ylabel('[dB]');
    end




end

