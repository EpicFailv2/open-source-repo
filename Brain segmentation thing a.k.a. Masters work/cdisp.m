function cdisp(str)
% CDISP - disp() with remove last line optional command
%
%   Displays given string using disp() command, but deletes previous line
%   printed by this method if given '\b', '\DEL' or '\DELETE' within the
%   input string
% 
%   str - input string
%
% ET 2017.06.23 "edgetech"™ All Rights Reserved.

global consoleDisplayGlobalVariableForLongStorage
cdvs = consoleDisplayGlobalVariableForLongStorage;

if (~isempty(strfind(str,'\DEL')) || ~isempty(strfind(str,'\b')))
    fprintf(sprintf(repmat('\b',1,length(cdvs)+1)));
    cdvs = '';
else
    disp(str)
    cdvs = str;
end

consoleDisplayGlobalVariableForLongStorage = cdvs;

return