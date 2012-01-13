function PointSelection(handles)

if handles.MeasDone % check if measurement is performed
    % smithchart
    smithposition = get(handles.smith,'CurrentPoint');
    smithx = smithposition(1,1);
    smithy = smithposition(1,2);
    SmithMag = sqrt(smithx.^2+smithy.^2); % magnitude of selected point
    
    % ax3
    ax3position = get(handles.ax3,'CurrentPoint');
    ax3x = ax3position(1,1);
    ax3y = ax3position(1,2);
    ax3xlim = get(handles.ax3,'XLim');
    ax3ylim = get(handles.ax3,'YLim');
    
    % ax4
    ax4position = get(handles.ax4,'CurrentPoint');
    ax4x = ax4position(1,1);
    ax4y = ax4position(1,2);
    ax4xlim = get(handles.ax4,'XLim');
    ax4ylim = get(handles.ax4,'YLim');    

    if (SmithMag < 1.1) % then smithchart selected
        h = get(handles.smith, 'Children');
        xdata = get(h(1),'XData');
        ydata = get(h(1),'YData');

        % Get index to closest data point
        delta = (xdata - smithx).^2 + (ydata - smithy).^2;
        [void, index] = min(delta);
        try
            UpdatePlots(handles,index)
        catch
        end
    elseif (ax3x > ax3xlim(1)) && (ax3x < ax3xlim(2)) && (ax3y > ax3ylim(1)) && (ax3y < ax3ylim(2))
        h = get(handles.ax3, 'Children');
        xdata = get(h(2),'XData');
        ydata = get(h(2),'YData');

        % rescale x and y data
        xdata = (xdata - ax3xlim(1))./(ax3xlim(2)-ax3xlim(1));
        ydata = (ydata - ax3ylim(1))./(ax3ylim(2)-ax3ylim(1));
        ax3x = (ax3x - ax3xlim(1))./(ax3xlim(2)-ax3xlim(1));
        ax3y = (ax3y - ax3ylim(1))./(ax3ylim(2)-ax3ylim(1));
        
        % Get index to closest data point
        delta = (xdata - ax3x).^2 + (ydata - ax3y).^2;
        [void, index] = min(delta);
        try
            UpdatePlots(handles,index)
        catch
        end
    elseif (ax4x > ax4xlim(1)) && (ax4x < ax4xlim(2)) && (ax4y > ax4ylim(1)) && (ax4y < ax4ylim(2))
        h = get(handles.ax4, 'Children');
        xdata = get(h(2),'XData');
        ydata = get(h(2),'YData');

        % rescale x and y data
        xdata = (xdata - ax4xlim(1))./(ax4xlim(2)-ax4xlim(1));
        ydata = (ydata - ax4ylim(1))./(ax4ylim(2)-ax4ylim(1));
        ax4x = (ax4x - ax4xlim(1))./(ax4xlim(2)-ax4xlim(1));
        ax4y = (ax4y - ax4ylim(1))./(ax4ylim(2)-ax4ylim(1));
        
        % Get index to closest data point
        delta = (xdata - ax4x).^2 + (ydata - ax4y).^2;
        [void, index] = min(delta);
        try
            UpdatePlots(handles,index)
        catch
        end
    end
end
end

function UpdatePlots(handles,index)
h = get(handles.smith, 'Children');
% change selected GL
set(h(2),'UserData',index);
set(h(2),'XData',real(handles.data.GL(index)));
set(h(2),'YData',imag(handles.data.GL(index)));

h = get(handles.ax3, 'Children');
set(h(1),'UserData',index);
set(h(1),'XData',handles.data.Pin(index));
set(h(1),'YData',handles.data.Pout(index));        
h = get(handles.ax4, 'Children');
set(h(1),'UserData',index);
set(h(1),'XData',handles.data.Pin(index));
set(h(1),'YData',handles.data.Deff(index));  

% update bias boxes
set(handles.mv1,'String',num2str(round(handles.swp(index).V1dc.*100)/100));
set(handles.mi1,'String',num2str(round(handles.swp(index).I1dc.*1e3.*100)/100));
set(handles.mv2,'String',num2str(round(handles.swp(index).V2dc.*100)/100));
set(handles.mi2,'String',num2str(round(handles.swp(index).I2dc.*100)/100));

% update power and gain boxes
set(handles.mpout,'String',num2str(round(handles.data.Pout(index).*10)/10));
set(handles.mgt,'String',num2str(round(handles.data.Gt(index).*10)/10));
set(handles.mgp,'String',num2str(round(handles.data.Gp(index).*10)/10));
set(handles.mdeff,'String',num2str(round(handles.data.Deff(index).*10)/10));

% update waveforms
axes(handles.ax1);
plot(handles.swp(index).v1,handles.swp(index).i1,'-k','LineWidth',2);
xlabel('V_1 [V]');
ylabel('I_1 [A]');
axes(handles.ax2);
plot(handles.swp(index).v2,handles.swp(index).i2,'-k','LineWidth',2);
xlabel('V_2 [V]');
ylabel('I_2 [A]');
end