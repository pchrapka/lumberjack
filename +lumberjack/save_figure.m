function save_figure(cfg)
% SAVE_FIGURE Saves the current figure
%   SAVE_FIGURE(CFG) saves the current figure as *.fig *.eps and *.png.
%
%   cfg.out_dir
%       (string) output directory
%   cfg.file_name
%       (string) file name to use, no extension
%   

% Construct the file name
file_name = fullfile(cfg.out_dir, cfg.file_name);

% Save the figure to a file
saveas(gcf, [file_name '.fig']);
saveas(gcf, [file_name '.eps'],'epsc2');
saveas(gcf, [file_name '.png']);
end