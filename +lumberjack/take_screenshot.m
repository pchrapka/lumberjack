function take_screenshot(cfg)
% Takes a screenshot using gnome-screenshot

% Create the folder
[pathstr, ~, ~, ~] = lumberjack.fileparts(cfg.filename);
if ~exist(pathstr, 'dir');
    mkdir(pathstr);
end

% Create the command
command = ['gnome-screenshot -f ' cfg.filename];
% Take the screenshot
system(command);

end