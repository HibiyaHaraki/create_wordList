function create_NGSL_wordList(option)
% create_NGSL_wordList - create word list from <a href="matlab:web('http://www.newgeneralservicelist.org/')">NGSL</a> files
%   This function create "NGSL_wordList.mat" from <a href="matlab:web('http://www.newgeneralservicelist.org/')">NGSL</a> files.
%
%   The risks of runnning this script is always with you.
%
%   create_NGSL_wordList()
%   create_NGSL_wordList('fileName',output_fileName_string)
%
%   This script needs following files from <a
%   href="matlab:web('http://www.newgeneralservicelist.org/')">NGSL site</a>.
%   * doc/NGSL+1.01+by+band.xlsx
%   * doc/NGSL+Spoken+1.01.xlsx
%   * doc/NAWL_1.0_lemmatized_for_research.csv
%   * doc/TSL_1.1_lemmatized_for_research.csv
%   * doc/BSL_1.01_lemmatized_for_research.csv
%   * doc/NDL_1.0_lemmatized_for_research.csv
%   * doc/FEL_1.0_lemmatized_for_research.csv
%
%   Optional Input
%       fileName - Output file name [NGSL_wordList]
%           string

    arguments
        option.fileName (1,1) {mustBeA(option.fileName,'string')} = "NGSL_wordList"
    end

    % Necessary Files
    file_loc = "doc/"; % File location
    NGSL_inputFileName      = "NGSL+1.01+by+band.xlsx";
    NGSL_S_inputFileName    = "NGSL+Spoken+1.01.xlsx";
    NAWL_inputFileName      = "NAWL_1.0_lemmatized_for_research.csv";
    TSL_inputFileName       = "TSL_1.1_lemmatized_for_research.csv";
    BSL_inputFileName       = "BSL_1.01_lemmatized_for_research.csv";
    NDL_inputFileName       = "NDL_1.0_lemmatized_for_research.csv";
    FEL_inputFileName       = "FEL_1.0_lemmatized_for_research.csv";
    
    % Import NGSL word list
    if (exist(file_loc+NGSL_inputFileName,'file'))
        % Read 1st 1000 words in NGSL word list
        NGSL1000_table = readtable(file_loc+NGSL_inputFileName,'Sheet','1st 1000');
        % Get Lemmatized word list
        NGSL1000 = lower(string(NGSL1000_table.(1)));
        fprintf("NGSL 1st 1000 word list includes %d words.\n",length(NGSL1000));
    
        % Read 2nd 1000 words in NGSL word list
        NGSL2000_table = readtable(file_loc+NGSL_inputFileName,'Sheet','2nd 1000');
        % Get Lemmatized word list
        NGSL2000 = lower(string(NGSL2000_table.(1)));
        fprintf("NGSL 2nd 1000 word list includes %d words.\n",length(NGSL2000));
    
        % Read 3rd 1000 words in NGSL word list
        NGSL3000_table = readtable(file_loc+NGSL_inputFileName,'Sheet','3rd 1000');
        % Get Lemmatized word list
        NGSL3000 = lower(string(NGSL3000_table.(1)));
        fprintf("NGSL 3rd 1000 word list includes %d words.\n",length(NGSL3000));
    
        % Read Supplemental words in NGSL word list
        NGSLSupplemental_table = readtable(file_loc+NGSL_inputFileName,'Sheet','Supplemental');
        % Get Lemmatized word list
        NGSLSupplemental = lower(string(NGSLSupplemental_table.(1)));
        fprintf("NGSL Supplemental word list includes %d words.\n",length(NGSLSupplemental));
    else
        error("Cannot open %s",file_doc+NGSL_inputFileName);
        return;
    end

    % Import NGSL-S words
    if (exist(file_loc+NGSL_S_inputFileName,'file'))
        % Read NGSL-S word list
        NGSL_S_table = readtable(file_loc+NGSL_S_inputFileName,'Sheet','Freq');
        % Get Lemmatized Word List
        NGSL_S = lower(string(NGSL_S_table.(1)));
        fprintf("NGSL-S word list includes %d words.\n",length(NGSL_S));
    else
        error("Cannot open %s",file_loc+NGSL_S_inputFileName);
        return;
    end

    % Import NAWL words
    if (exist(file_loc+NAWL_inputFileName,'file'))
        % Read NAWL word list
        NAWL_table = readtable(file_loc+NAWL_inputFileName,'ReadVariableNames',false);
        % Get Lemmatized Word List
        NAWL = lower(string(NAWL_table.(1)));
        fprintf("NAWL word list includes %d words.\n",length(NAWL));
    else
        error("Cannot open %s",file_loc+NAWL_inputFileName);
        return;
    end

    % Import TOEIC words
    if (exist(file_loc+TSL_inputFileName,'file'))
        % Read TOEIC word list
        TSL_table = readtable(file_loc+TSL_inputFileName,'ReadVariableNames',false);
        % Get Lemmatized Word List
        TSL = lower(string(TSL_table.(1)(8:end)));
        fprintf("TSL word list includes %d words.\n",length(TSL));
    else
        error("Cannot open %s",file_loc+TSL_inputFileName);
        return;
    end

    % Import Business words
    if (exist(file_loc+BSL_inputFileName,'file'))
        % Read Business Service Word list
        BSL_table = readtable(file_loc+BSL_inputFileName,'ReadVariableNames',false);
        % Get Lemmatized Word List
        BSL = lower(string(BSL_table.(1)(8:end)));
        fprintf("BSL word list includes %d words.\n",length(BSL));
    else
        error("Cannot open %s",file_loc+BSL_inputFileName);
        return;
    end

    % Import new dolche words
    if (exist(file_loc+NDL_inputFileName,'file'))
        % Read Business Service Word list
        NDL_table = readtable(file_loc+NDL_inputFileName,'ReadVariableNames',false);
        % Get Lemmatized Word List
        NDL = lower(string(NDL_table.(1)));
        fprintf("NDL word list includes %d words.\n",length(NDL));
    else
        error("Cannot open %s",file_loc+NDL_inputFileName);
        return;
    end

    % Import fitness english words
    if (exist(file_loc+FEL_inputFileName,'file'))
        % Read Business Service Word list
        FEL_table = readtable(file_loc+FEL_inputFileName,'ReadVariableNames',false);
        % Get Lemmatized Word List
        FEL = lower(string(FEL_table.(1)(8:end)));
        fprintf("FEL word list includes %d words.\n",length(FEL));
    else
        error("Cannot open %s",file_loc+FEL_inputFileName);
    end

    % Import abbreviations
    abbreviations_table = abbreviations;
    abbreviation = lower(string(abbreviations_table.(1)));

    % Save all word list
    save(option.fileName, ...
        'NGSL1000', ...
        'NGSL2000', ...
        'NGSL3000', ...
        'NGSLSupplemental', ...
        'NGSL_S', ...
        'NAWL', ...
        'TSL', ...
        'BSL', ...
        'NDL', ...
        'FEL', ...
        'abbreviation');
    fprintf("Output %s.mat\n",option.fileName);

end
