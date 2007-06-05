function spout = uncascade(varargin)
% UNCASCADE - calculates the S-parameters of the inverse cascade
%
% SP = UNCASCADE(SP1,SP2) - uncascades SP2 from SP1 from the right.
% SP = UNCASCADE(SP1,SP2,'R') - uncascades SP2 from SP1 from the right.
% SP = UNCASCADE(SP1,SP2,'L') - uncascades SP2 from SP1 from the left.
%

if nargin==3
    direction = varargin{3};
else
    direction = 'R'; % default
end

sp1 = varargin{1};
sp2 = varargin{2};

switch upper(direction(1))
    case 'R'
        spout = cascade(sp1,sp2,'inverse',[0 1]); % perform inverse cascade
    case 'L'
        spout = cascade(sp2,sp1,'inverse',[1 0]); % perform inverse cascade
    otherwise
        error('Direction must be either ''Left'' or ''Right''');
end
