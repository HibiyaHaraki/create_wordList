close all; clear; clc;
%% Inputs
% Path to the folder of the documents
path_to_doc_folder = "papers";

% Delete word list
delete_NGSL1000         = true ; % NGSL 1st 1000 wordsを削除する?
delete_NGSL2000         = true ; % NGSL 2nd 1000 wordsを削除する?
delete_NGSL3000         = true ; % NGSL 3rd 1000 wordsを削除する?
delete_NGSLSupplemental = true ; % NGSL Supplemental wordsを削除する?
delete_NGSL_S           = true ; % NGSL + Spoken wordsを削除する?
delete_NAWL             = true ; % NAWL wordsを削除する?
delete_TSL              = false; % TOEIC wordsを削除する?
delete_BSL              = false; % Business service wordsを削除する?
delete_NDL              = false; % NDL wordsを削除する?
delete_FEL              = false; % Fitness English wordsを削除する?
delete_abbreviation     = true ; % Abbreviationを削除する?

%% Check inputs
doc_list = [];
if (~exist(path_to_doc_folder,'dir'))
    error("Cannot find the %s.",path_to_doc_folder);
    return;
else
    doc_info = dir(path_to_doc_folder);
    for ii = 1:length(doc_info)
        if (string(doc_info(ii).name) ~= "." & string(doc_info(ii).name) ~= "..")
            doc_list = [doc_list,string(doc_info(ii).folder)+"\"+string(doc_info(ii).name)];
        end
    end
    fprintf("Find %d documents\n",length(doc_list));
end

if (~exist("NGSL_wordList.mat",'file'))
    error("Please put 'wordList.mat' here!!");
    return;
end

%% Extract delete words
delete_words = [];
load("NGSL_wordList.mat");

if (delete_NGSL1000)
    delete_words = [delete_words;NGSL1000];
end

% Delete NGSL 2nd 1000 words
if (delete_NGSL2000)
    delete_words = [delete_words;NGSL2000];
end

% Delete NGSL 3rd 1000 words
if (delete_NGSL3000)
    delete_words = [delete_words;NGSL3000];
end

% Delete NGSL Supplemental words
if (delete_NGSLSupplemental)
    delete_words = [delete_words;NGSLSupplemental];
end

% Delete NGSL-S words
if (delete_NGSL_S)
    delete_words = [delete_words;NGSL_S];
end

% Delete NAWL words
if (delete_NAWL)
    delete_words = [delete_words;NAWL];
end

% Delete TSL words
if (delete_TSL)
    delete_words = [delete_words;TSL];
end

% Delete BSL words
if (delete_BSL)
    delete_words = [delete_words;BSL];
end

% Delete NDL words
if (delete_NDL)
    delete_words = [delete_words;NDL];
end

% Delete FEL words
if (delete_FEL)
    delete_words = [delete_words;FEL];
end

% Delete Abbreviation
if (delete_abbreviation)
    delete_words = [delete_words;abbreviation];
end

%% Create word list with the function
[wordList,docsList] = create_wordList(path_to_doc_folder,delete_words,'verbose',true);