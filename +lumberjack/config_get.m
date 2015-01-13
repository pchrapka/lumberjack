function [value, status] = config_get(field)
%CONFIG_GET Get the value in the specified field from the config file

% Set up config file name
config_file = 'config.mat';
status = 0;

% Check if it exists
if exist(config_file, 'file')
    % Load the file if it exists
    din = load(config_file);
    config = din.config;
    value = config.(field);
    status = 1;
else
    value = 0;
    status = 0;
    fprintf('field: %s not found\n', field);
end

end