function [ output_args ] = raw2fieldtrip( cfg )
%RAW2FIELDTRIP Converts raw EEG data to FieldTrip format
%   RAW2FIELDTRIP(CFG) converts raw EEG data to a format that's useable
%   with FieldTrip.
%
%   cfg requires the following fields
%       n_channels
%       n_trials
%       label       Channel labels (n_channels x 1)
%       fsample     Sampling rate (Hz)
%       trial       Cell array of trial data
%           data    Trial data (n_channels x n_samples)
%           time    Time axis (1 x n_samples)
%           info    (optional)
%       info_hdr    (optional) Header for additional info
%       out_dir     Output directory for files
%       file_name   Output file name root
%       file_name_suf (optional)
%           suffix for the file name
%
%   Source:
%   http://fieldtrip.fcdonders.nl/faq/how_can_i_import_my_own_dataformat

% FIXME Good candidate for a inter project utilities project

n_channels = cfg.n_channels;
n_trials = cfg.n_trials;

%% Channel labels
if isequal(length(cfg.label), n_channels)
    data.label = cell(n_channels, 1);
    % Copy the channel labels (Nchan x 1)
    [data.label{:}] = cfg.label{:};
else
    error(...
        'rtms:raw2fieldtrip',...
        ['cfg.label should contain ' num2str(n_channels) ' cells']);
end

%% Sampling rate
% Copy the sampling rate
data.fsample = cfg.fsample;

%% Trials
if isequal(size(cfg.trial,1), n_trials);
    data.trial = cell(1, n_trials);
    data.time = cell(1, n_trials);
    
    if isfield(cfg,'info_hdr')
        n_info_fields = length(cfg.info_hdr);
        data.trialinfo = cell(n_trials, n_info_fields);
        data.trialinfo_hdr = cfg.info_hdr;
    end
    for i=1:n_trials
        % Get the number of samples
        n_samples = length(cfg.trial{i}.time);
        % Get the trial data
        if isequal(size(cfg.trial{i}.data), [n_channels n_samples])
            data.trial{i} = cfg.trial{i}.data;
        else
            error(...
                'rtms:raw2fieldtrip',...
                'cfg.trial.data is a bad size');
        end
        % Get the time axis
        data.time{i} = reshape(...
            cfg.trial{i}.time,...
            1, n_samples);
        
        if isfield(data,'trialinfo')
            % Get the additional information
            [data.trialinfo{i,:}] = cfg.trial{i}.info{:};
        end
    end
else
    error(...
        'rtms:raw2fieldtrip',...
        ['cfg.trial should contain ' num2str(n_trials) ' cells']);
end

%% Save the data
% Create the directory if it doesn't exist
if ~exist(cfg.out_dir, 'dir')
    mkdir(cfg.out_dir);
end
if isfield(cfg, 'file_name_suf') && ~isempty(cfg.file_name_suf)
    out_file = fullfile(cfg.out_dir,...
        [cfg.file_name '_' cfg.file_name_suf '.mat']);
else
    out_file = fullfile(cfg.out_dir,...
        [cfg.file_name '.mat']);
end
save(out_file, 'data');

end

