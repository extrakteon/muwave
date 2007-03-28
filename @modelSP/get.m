function val=get(cIN,prop_name)
% Method to access the properties of a measSP object.

% $Header$
% $Author: kristoffer $
% $Date: 2003-06-17 14:17:51 +0200 (Tue, 17 Jun 2003) $
% $Revision: 2 $ 
% $Log$
% Revision 1.1  2003/06/17 12:17:53  kristoffer
% Initial revision
%
% Revision 1.1  2002/01/17 15:20:24  fager
% Initial
%
%

switch prop_name
case 'meassp',
	val=cIN.meassp;
case 'ModelType',
	val=cIN.ModelType;
case 'Params',
	val=cIN.Params;
case 'ExtrType',
	val=cIN.ExtrType;
case 'OptParams',
	val=cIN.OptParams;
case 'ParamStart',
	val=cIN.ParamStart;
case 'ParamMin',
	val=cIN.ParamMin;
case 'ParamMax',
	val=cIN.ParamMax;
case 'Error',
	val=cIN.Error;
case 'Iterations',
	val=cIN.Iterations;
case 'MeasData',
	val=cIN.MeasData;
case 'CustomInfo',
	val=cIN.CustomInfo;
otherwise
	try		% Try if it works if operated on the data object
		val = get(cIN.meassp,prop_name);
	catch
		error(['Unknown property "',prop_name,'".']);
	end
end
