function printPlot(name,dir,willResize,closePlot)
% printPlot - saves plot as .png file
%   printPlot is designed to speedup laboratory works preparation
% 
%   name    - filename
%   dir     - directory path where to save file to
%   willResize - flag for pause waiting for resize before save
%   closePlot - flag for closing of plot after saving
%   
%   All parameters required
% 
% 2016.11.05 "edgetech" All Rights Reserved.

if ~isempty(dir); name = fullfile(dir,name); end
if willResize; pause(); end
set(gcf,'PaperPositionMode','auto');
if exist([name '.png'],'file'); delete([name '.png']); end
print(name,'-dpng','-r0');
if closePlot; close; end
