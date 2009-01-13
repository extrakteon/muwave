function cOUT=merge(cIN1,varargin)
%MERGE  Merge two or more meassp objects into one.
%   M = MERGE(MSP1,MSP2,MSP3,...,MSPN) merges the MEASSP objects MSP1, MSP2 to MSPN 
%   into the new object M. Information about the frequency points originating 
%   from each of the merged MEASSP objects are collected in the length-N cell vector 
%   property SEGMENTS, whose elements are vectors of the frequency indices
%   from each of the original MSPs.

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author$
% $Date$
% $Revision$ 
% $Log$
% Revision 1.1  2005/05/02 14:16:43  fager
% Initial version
%

cOUT = cIN1;
MSP = cIN1;
XSP = get(MSP,'data');

nIn = nargin;
if nargin<2, error('At least two MEASSP input objects are needed'); end

for k = 1:(nIn-1)
    if ~isa(varargin{k},'meassp'), error('Input arguments must be MEASSP objects');end
    MADD = varargin{k};
    XADD = get(MADD,'data');
    
    % Merge the xparam objects
    if ~isequal(get(XADD,'ports'),get(XSP,'ports')), error('All objects must have same number of ports'); end
    if ~isequal(get(XADD,'reference'),get(XSP,'reference')), error('All objects must have same reference impedance'); end
    XADD = get(XADD,get(XSP,'type')); % Convert to same type as the first input
    
    f_in = freq(MSP);
    f_add = freq(MADD);
    if isempty(f_add) | isempty(f_in), error('The input objects must not be empty'); end
    
    [f_out,f_ix] = sort([f_in;f_add]);
    if length(f_out) ~= length(unique(f_out)), warning('Duplicate frequency points exist!'); end
    
    XSP = set(XSP,'freq',f_out);
    MIN_3D = get(XSP,'mtrx');
    MADD_3D = get(XADD,'mtrx');
    MSP_3D = cat(3,MIN_3D,MADD_3D);
    MSP_3D = MSP_3D(:,:,f_ix); % Sort the data points
    XSP = set(XSP,'data',arraymatrix(MSP_3D));
    if xor(isempty(get(XSP,'datacov')),isempty(get(XADD,'datacov'))), error('Covariance information must be given for either all or none of the input objects');end
    DCIN = get(XSP,'datacov');
    if ~isempty(DCIN);
        DCIN_3D = get(DCIN,'mtrx');
        DCADD_3D = get(XADD.datacov,'mtrx');
        DCSP_3D = cat(3,DCIN_3D,DCADD_3D);
        DCSP_3D = DCSP_3D(:,:,f_ix); % Sort the data points
        XSP = set(XSP,'datacov',arraymatrix(DCSP_3D));
    end
    MSP = set(MSP,'data',XSP);
    
    % Merge the measstate properties
    
    MINST = get(MSP,'measstate');
    MOUTST = MINST;
    MINST_NAMES = get(MINST);
    MADDST = get(MADD,'measstate');
    MADDST_NAMES = get(MADDST);
    for k = 1:length(MADDST_NAMES)
        addname = MADDST_NAMES{k};
        addval = get(MADDST,addname);
        if ismember(addname,MINST_NAMES)
            oldval = get(MINST,addname);
            if ~isequal(oldval,addval),
                if isnumeric(oldval) & isnumeric(addval)
                    MOUTST = set(MOUTST,addname,cat(2,oldval,addval));
                else
                    if ~iscell(oldval), oldval = {oldval}; end
                    MOUTST = set(MOUTST,addname,{oldval{:},addval});
                end
            end
        else
            MOUTST = addprop(MOUTST,addname,addval);
        end
    end
    MSP = set(MSP,'measstate',MOUTST);
    
    % Merge the measmnt properties
    
    MINST = get(MSP,'measmnt');
    MOUTST = MINST;
    MINST_NAMES = get(MINST);
    MADDST = get(MADD,'measmnt');
    MADDST_NAMES = get(MADDST);
    for k = 1:length(MADDST_NAMES)
        addname = MADDST_NAMES{k};
        addval = get(MADDST,addname);
        if ismember(addname,MINST_NAMES)
            oldval = get(MINST,addname);
            if ~isequal(oldval,addval),
                if isnumeric(oldval) & isnumeric(addval)
                    MOUTST = set(MOUTST,addname,cat(2,oldval,addval));
                else
                    if ~iscell(oldval), oldval = {oldval}; end
                    MOUTST = set(MOUTST,addname,{oldval{:},addval});
                end
            end
        else
            MOUTST = addprop(MOUTST,addname,addval);
        end
    end
    MSP = set(MSP,'measmnt',MOUTST);
end
MSP = addprop(MSP,'Info','Merged data');
cOUT = MSP;