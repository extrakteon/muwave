function xp_out = cascade(varargin)
% CASCADE - calculates the S-parameters of the cascade:
%  >-[SP1]->-[SP2]-> .. -[SPN]-> 
%   1     2 1     2  .. 1     2
% 
% SP_CASCADE = CASCADE(SP1,...,SPN)
% SP_CASCADE = CASCADE(SP1,...,SPN,'inverse',inverse) - where inverse is a vector
% which is true if the SP should be inverted before cascading.
% SP_CASCADE = CASCADE(SP1,...,SPN,'reverse',reverse) - where reverse is a vector
% which is true if the SP should be reverse before cascading. Reverse only
% works for 2-ports.

% Check if any options are supplied
option_valid = {'inverse', 'reverse'};
inverse = [];
reverse = [];
N = [];
for k = 1:(length(varargin)-1);
    if strcmp(class(varargin{k}),'char')
        if isempty(N)
            N = k - 1; % the number of arguments before options startss
        end
        str = lower(varargin{k});
        valid = strcmp(str,option_valid);
        if any(valid)
            if valid(1)
                inverse = logical(reshape(varargin{k+1},[1 N]));
            end
            if valid(2)
                reverse = logical(reshape(varargin{k+1},[1 N]));
            end
        else
            error(sprintf('CASCADE: %s is an unvalid option. Valid options are ''inverse'',''reverse''',str));
        end
    end
end

% use defaults if no options were given
if isempty(N)
    N = length(varargin);
end
if isempty(inverse)
    inverse = logical(zeros(1,N));
end
if isempty(reverse)
    reverse = logical(zeros(1,N));
end

% process input arguments and calculate cascade
xp_out = 1;
for k = 1:N
   switch class(varargin{k})
    case 'double'
        tmp = xparam(varargin{k});
    case 'xparam'
        tmp = varargin{k};
    otherwise
        tmp = get(varargin{k},'data');
   end
   
   % reverse?
   if reverse(k)
       tmp = rev2port(tmp);
   end
   % inverse?
   if inverse(k)
       xp_out = xp_out * inv(tmp.W);
   else
       xp_out = xp_out * tmp.W;
   end
   
end

% convert to S-parameters
xp_out = xp_out.S;
