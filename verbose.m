function verbose(start_time,info_text,options)
% verbose - Show information on command window
%   This function shows message with time information on the command window.
%
%   The risk of running this script is always with you.
%
%   verbose(start_time,info_text)
%   verbose(start_time,info_text,Options)
%
%   Inputs
%       start_time - Standard time for computing duration
%           datetime
%       info_text  - String of the messages you want to show
%           string
%
%   Input Options
%       Mode  - Switch that decide whether show message or not [true]
%           logical

    arguments
        start_time (1,1) datetime
        info_text (1,1) string
        options.Mode  (1,1) {mustBeNumericOrLogical} =  true
    end


    if (options.Mode)
        time_now = datetime('now');
        dur = time_now - start_time;

        time_now_string = string(time_now,"yyyy/MM/dd HH:mm:ss.SSS");
        dur_string = string(dur,"hh:mm:ss.SSSS");
        fprintf("[%s (%s)] %s\n",time_now_string,dur_string,info_text);
    end
end