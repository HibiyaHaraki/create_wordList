function [wordList,docsList] = create_wordList(doc_folder_name,deleteWords,options)
% create_wordList - Create specific word list from the documents
%   This function generate a word list from input documents by following tasks.
%   * Extract words from documents
%   * Remove words that you specify
%   * Remove words by threshold
%   * Sort words by frequency
%
%   The risk of running this script is always with you.
%
%   wordList = create_wordList(doc_folder_name,deleteWords)
%   wordList = create_wordList(doc_folder_name,deleteWords,options)
%   [wordList,docsList] = create_wordList(_)
%
%   wordTable = create_wordList(doc_folder_name,deleteWords,'outputTable',true)
%   wordTable = create_wordList(doc_folder_name,deleteWords,'outputTable',true,,options)
%   [wordTable,docsList] = create_wordList(_)
%
%   Inputs
%       doc_folder_name - Folder name that include documents
%           string
%       deleteWords - Words that remove from the list
%           string
%
%   Input Options [initaial_state]
%       minFreq     - Minimum frequency of the words that are included in the list [10]
%           scalar
%       minRange    - Minimum range of the words that are included in the list [1]
%           scalar
%       minChars    - Minimum number of characters in a word scalar [3]
%           scalar
%       maxChars    - Maximum number of characters in a word [20]
%           scalar
%       outputTable - Output not only word but also the data of frequency and rage [false]
%           logical
%       verbose     - Show detail information [false]
%           logical

    arguments
        doc_folder_name string
        deleteWords string
        options.minFreq  (1,1) {mustBeNumeric} =  10
        options.minRange (1,1) {mustBeNumeric} =  1
        options.minChars (1,1) {mustBeNumeric} =  3
        options.maxChars (1,1) {mustBeNumeric} = 20
        options.outputTable (1,1) {mustBeNumericOrLogical} = false
        options.verbose  (1,1) {mustBeNumericOrLogical} = false
    end

    % Check necessary script files
    if (~exist("extract_text_from_docs.m",'file'))
        error("Error: extract_text_from_docs.m is necessary.");
        return;
    end

    if (~exist("text_preprocess.m",'file'))
        error("Error: text_preprocess.m is necessary.");
        return;
    end

    if (~exist("verbose.m",'file'))
        error("Error: verbose.m is necessary.");
    end

    % Function code
    start_time = datetime('now'); % Set star time (for verbose mode)
    verbose(start_time,sprintf("Start create_wordList"), ...
        "Mode",options.verbose);

    % Check input document list
    if (~isscalar(doc_folder_name))
        error("Incorrect document list. The list must be string vector.");
        return;
    end

    % Check input delete word list
    if (~isvector(deleteWords))
        error("Incorrect delete word list. The list must be string vector.");
    else
        deleteWords = unique(lower(deleteWords));
        numDeleteWords = length(deleteWords);
        verbose(start_time,sprintf("Input %d delete words",numDeleteWords), ...
            "Mode",options.verbose);
        deleteWords = [deleteWords;unique(normalizeWords(deleteWords,'Style','lemma'))];
        deleteWords = unique(deleteWords);
    end

    % Check options
    minFreq  = floor(options.minFreq);
    minRange = floor(options.minRange);
    minChars = floor(options.minChars);
    maxChars = ceil(options.maxChars);
    verbose(start_time,sprintf("Minimum frequency threshold: %d" ,minFreq ),"Mode",options.verbose);
    verbose(start_time,sprintf("Minimum range threshold: %d"     ,minRange),"Mode",options.verbose);
    verbose(start_time,sprintf("Minimum characters threshold: %d",minChars),"Mode",options.verbose);
    verbose(start_time,sprintf("Maximum characters threshold: %d",maxChars),"Mode",options.verbose);
    if (options.outputTable)
        verbose(start_time,sprintf("Output only english words (string)"),"Mode",options.verbose);
    else
        verbose(start_time,sprintf("Output english words with information (table)"),"Mode",options.verbose);
    end
    if (options.verbose)
        verbose(start_time,sprintf("Verbose mode: true"),"Mode",options.verbose);
    end
    
    % Generate file datastore
    verbose(start_time,sprintf("Create file data store"),"Mode",options.verbose);
    docs_ds = fileDatastore(doc_folder_name, ...
        'ReadFcn',@extract_text_from_docs, ...
        "FileExtensions",[".pdf",".txt",".html",".docx"]);

    verbose(start_time,sprintf("Convert data to string"),"Mode",options.verbose);
    docs_cell_data = readall(docs_ds); % Read documents
    docs_str_data  = string(docs_cell_data); % Convert cell 2 string

    verbose(start_time,sprintf("Preprocessing (This may takes time)"),"Mode",options.verbose);
    docs_prep_data = text_preprocess(docs_str_data); % Preprocess (see more in this function below)

    % Get document list
    verbose(start_time,sprintf("Create document list that is included"),"Mode",options.verbose);
    import_result = docs_str_data ~= "";
    docsList = table(docs_ds.Files,import_result);

    % Generate bag of words of the docs
    verbose(start_time,sprintf("Create bag of words"),"Mode",options.verbose);
    docs_bow = bagOfWords(docs_prep_data);

    % Delete words from docs data
    verbose(start_time,sprintf("Delete words"),"Mode",options.verbose);
    docs_bow_deleted = removeWords(docs_bow,deleteWords,'IgnoreCase',true);    

    % Delete words by threshold
    verbose(start_time,sprintf("Delete words by threshold"),"Mode",options.verbose);
    vocabulary = docs_bow_deleted.Vocabulary';
    freq = full(sum(docs_bow_deleted.Counts,1))';
    range = zeros(docs_bow_deleted.NumWords,1);
    for ii = 1:docs_bow_deleted.NumWords
        range(ii) = nnz(docs_bow_deleted.Counts(:,ii)>0);
    end
    docs_table = table(vocabulary,freq,range);
    docs_table(~isnan(str2double(docs_table.vocabulary)),:) = []; % delete numbers
    docs_table(docs_table.freq < minFreq,:) = []; % delete words by frequency
    docs_table(docs_table.range < minRange,:) = []; % delete words by range
    docs_table(strlength(docs_table.vocabulary) <= minChars,:) = []; % deelte words by min characters
    docs_table(strlength(docs_table.vocabulary) >= maxChars,:) = []; % delete words by max characters

    verbose(start_time,sprintf("Sort word list"),"Mode",options.verbose);
    docs_table = sortrows(docs_table,'freq','descend');

    % Output
    if (options.outputTable)
        verbose(start_time,sprintf("Output word list (table)"),"Mode",options.verbose);
        wordList = docs_table;
    else
        verbose(start_time,sprintf("Output word list (string)"),"Mode",options.verbose);
        wordList = string(docs_table.vocabulary);
    end

    verbose(start_time,sprintf("Finish create_wordList"),"Mode",options.verbose);
end