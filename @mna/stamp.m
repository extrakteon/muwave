function x = stamp(x,type,element,conn)
% STAMP  Adds the stamp of a known element type into an MNA-object
%

% $Header$
% $Author: fager $
% $Date: 2004-11-17 11:24:03 +0100 (Wed, 17 Nov 2004) $
% $Revision: 234 $ 
% $Log$
% Revision 1.15  2004/11/17 10:24:03  fager
% Added possibility to read X and X2 elements
% Sensitivities not implemented though
%
% Revision 1.14  2004/04/28 15:56:00  koffer
% Support for second order sensitivities
%
% Revision 1.13  2003/11/17 22:27:32  kristoffer
% *** empty log message ***
%
% Revision 1.12  2003/11/17 18:55:54  kristoffer
% no message
%
% Revision 1.11  2003/11/17 07:46:35  kristoffer
% *** empty log message ***
%
% Revision 1.10  2003/11/12 22:36:37  kristoffer
% Basic support for adjoint sensitivity calculations
%
% Revision 1.9  2003/10/08 09:59:55  fager
% Fixed X2 element.
%
% Revision 1.8  2003/10/06 16:43:48  kristoffer
% no message
%
% Revision 1.7  2003/10/06 07:11:50  kristoffer
% no message
%
% Revision 1.6  2003/10/03 15:26:27  kristoffer
% no message
%
% Revision 1.5  2003/10/03 15:24:58  kristoffer
% Node 0 is now a ground connection
%
% Revision 1.4  2003/10/03 13:10:46  fager
% General X (one port) and X2 (two port) components added.
%
% Revision 1.6  2003/08/18 07:48:44  kristoffer
% no message
%
% Revision 1.5  2003/07/23 09:18:43  kristoffer
% Returns a measSP-object containing the model
%
% Revision 1.4  2003/07/22 14:59:09  kristoffer
% no message
%
Y = x.Y;
switch type
    case 'C'
        Y = mna_cap(element,conn,Y);        
    case 'R'
        Y = mna_res(element,conn,Y);
    case 'G'
        Y = mna_cond(element,conn,Y);
    case 'L'
        Y = mna_ind(element,conn,Y);
    case 'X'
        Y = mna_general1p(element,conn,Y);
    case 'X2'
        Y = mna_general2p(element,conn,Y);
        x.reciprocal = false;
    case 'VCCS'
        Y = mna_vccs(element,conn,Y);
        x.reciprocal = false;
    case 'VCCSD'
        element = strcat(element,'*exp(-s*tau_',element,')');
        Y = mna_vccs(element,conn,Y);
        x.reciprocal = false;
    case 'GY'
        Y = mna_gyrator(element,conn,Y);
        x.reciprocal = false;
    case 'P'
        % insert port definition
        if ischar(element(1))
            pnum = str2num(element(2:end));
        else
            pnum = str2num(element);
        end
        ports = x.ports;
        ports(:,pnum) = conn';
        x.ports = ports;
    otherwise
        % do nothing!
        ;
end
[new_parameters, new_partials,new_types] = extract_parameters(element,type);
x.Y = Y;
[x.params,x.partials,x.param_type,x.param_conn] = AddParameters(x.params,new_parameters,x.partials,new_partials,new_types,x.param_type,conn,x.param_conn);
    
% add parameters to mapping-matrix (the ugly way)
XN = x.nodes;
params = x.params;
XP = length(params);
for row=1:XN
    for col=1:XN
        for k=1:XP
            map(row,col,k) = ~isempty(strfind(Y{row,col},params{k}));
        end
    end
end
x.map = map;

function [parameters,partials,ptype_out] = extract_parameters(element_expression,ptype_in)
parameters = symvar(element_expression);
s_idx = find(strcmp(parameters,'s'));
parameters(s_idx) = [];
parameters = parameters';
switch ptype_in
    case {'VCCSD'}
        partials = [1;1];
        ptype_out{1} = 'VCCSD';
        ptype_out{2} = 'VCCSD_TAU';
    otherwise
        if length(parameters)==1
            partials(1) = str2num(strrep(element_expression,parameters{1},'1'));
            ptype_out{1} = ptype_in;
        else
            for k = 1:length(parameters);
                partials(k) = 1;
                ptype_out{k} = ptype_in;    % Replaced erroneous (k) with proper {k}
            end
        end
end

function [total_parameters,total_partials,param_type_out,param_conn_out] = AddParameters(existing_parameters,new_parameters,existing_partials,new_partials,ptype,param_type_in,conn,param_conn_in)
total_parameters = existing_parameters;
total_partials = existing_partials;
param_type_out = param_type_in;
param_conn_out = param_conn_in;
N = length(existing_parameters);
added_parameters = 0; 
if N == 0, 
    total_parameters = new_parameters;
    total_partials = new_partials;
    param_type_out{1} = ptype{1};
    param_conn_out{1} = conn;
else
    for k = 1:length(new_parameters)
        i = 1; found = false;
        while ~found & i <= N
            newpstr = new_parameters{k};
            if strcmp(newpstr,existing_parameters{i})
                if ~strcmp(param_type_out{i},ptype)
                    warning('Elements with same name are not of same sort.');
                    % TODO %  This dirty fix allows Y-matrix calculations in all cases. Sensitivities will not working though...
                    found = true;
                    param_conn_out{i} = [param_conn_out{i}];
                else           
                    found = true;
                    param_conn_out{i} = [param_conn_out{i};conn];
                end
            elseif newpstr(1) == 'P'
                % port definitions is not a parameter
                found = true;
            end
            i = i + 1;
        end
        if ~found
            added_parameters = added_parameters + 1;
            total_parameters{N+added_parameters} = new_parameters{k};
            total_partials(N+added_parameters) = new_partials(k);
            param_type_out{N+added_parameters} = ptype{k};
            param_conn_out{N+added_parameters} = conn;
        end
    end
end


function Y = mna_2t(element,conn,Y)
% sort node-connection vector
xconn = sort(conn);

if xconn(1)~=0
    % element not connected to ground
    Y{xconn(1),xconn(1)}=strcat(Y{xconn(1),xconn(1)},'+',element);    
    Y{xconn(1),xconn(2)}=strcat(Y{xconn(1),xconn(2)},'-',element);
    Y{xconn(2),xconn(1)}=strcat(Y{xconn(2),xconn(1)},'-',element);
    Y{xconn(2),xconn(2)}=strcat(Y{xconn(2),xconn(2)},'+',element);
elseif xconn(2) ~= 0
    % element connected to ground
    Y{xconn(2),xconn(2)}=strcat(Y{xconn(2),xconn(2)},'+',element);
end    

function Y = mna_cap(element,conn,Y)
Y = mna_2t(strcat('s*',element),conn,Y);

function Y = mna_res(element,conn,Y)
Y = mna_2t(strcat('1/(',element,')'),conn,Y);

function Y = mna_cond(element,conn,Y)
Y = mna_2t(element,conn,Y);

function Y = mna_ind(element,conn,Y)
Y = mna_2t(strcat('1/(s*',element,')'),conn,Y);

function Y = mna_vccs(element,conn,Y)
if ~any(conn(1:2)==0)
    Y{conn(2),conn(1)}=strcat(Y{conn(2),conn(1)},'+',element);
end
if ~any(conn(2:3)==0)
    Y{conn(2),conn(3)}=strcat(Y{conn(2),conn(3)},'-',element);
end
if ~any([conn(1) conn(4)]==0)
    Y{conn(4),conn(1)}=strcat(Y{conn(4),conn(1)},'-',element);
end
if ~any(conn(3:4)==0)
    Y{conn(4),conn(3)}=strcat(Y{conn(4),conn(3)},'+',element);
end

function Y = mna_gyrator(element,conn,Y)
if conn(1) ~= 0
    if conn(2) ~= 0
        Y{conn(1),conn(2)}=strcat(Y{conn(1),conn(2)},'+',element);
        Y{conn(2),conn(1)}=strcat(Y{conn(2),conn(1)},'-',element);    
    end
    if conn(4) ~= 0
        Y{conn(1),conn(4)}=strcat(Y{conn(1),conn(4)},'-',element);
        Y{conn(4),conn(1)}=strcat(Y{conn(4),conn(1)},'+',element);    
    end
end
if conn(3) ~= 0
    if conn(2) ~= 0
        Y{conn(2),conn(3)}=strcat(Y{conn(2),conn(3)},'+',element);
        Y{conn(3),conn(2)}=strcat(Y{conn(3),conn(2)},'-',element);
    end
    if conn(4) ~= 0
        Y{conn(3),conn(4)}=strcat(Y{conn(3),conn(4)},'+',element);
        Y{conn(4),conn(3)}=strcat(Y{conn(4),conn(3)},'-',element);
    end
end

function [Y] = mna_general1p(element_expression,conn,Y)
Y = mna_2t(element_expression,conn,Y);

function [Y] = mna_general2p(element_expression,conn,Y)
if ~any(conn(1:2)==0)
    Y{conn(2),conn(1)}=strcat(Y{conn(2),conn(1)},'+',element_expression);
end
if ~any(conn(2:3)==0)
    Y{conn(2),conn(3)}=strcat(Y{conn(2),conn(3)},'-',element_expression);
end
if ~any([conn(1) conn(4)]==0)
    Y{conn(4),conn(1)}=strcat(Y{conn(4),conn(1)},'-',element_expression);
end
if ~any(conn(3:4)==0)
    Y{conn(4),conn(3)}=strcat(Y{conn(4),conn(3)},'+',element_expression);
end
