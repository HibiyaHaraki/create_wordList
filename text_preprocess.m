function cleanedDocuments = text_preprocess(string_data)
% text_preprocess - Clean the string data
%   This function clean the string data.
%   The detail information is on <a href="matlab:web('https://jp.mathworks.com/help/textanalytics/ug/prepare-text-data-for-analysis.html')">Prepare Text Data for Analysis</a>
%
%   The risk of running this script is always with you.
%
%   text_preprocess(string_data)
%
%   Inputs
%       string_data - Text that you want to clean
%           string

    arguments
        string_data string
    end

    % Create Tokenized data
    string_data = eraseURLs(string_data);
    string_data = replace(string_data,' '+digitsPattern+' ',' ');
    Documents = tokenizedDocument(string_data);

    % Clean the tokenized data
    cleanedDocuments = correctSpelling(Documents);
    cleanedDocuments = addPartOfSpeechDetails(cleanedDocuments);
    cleanedDocuments = removeStopWords(cleanedDocuments);
    cleanedDocuments = normalizeWords(cleanedDocuments,'Style','lemma');
    cleanedDocuments = erasePunctuation(cleanedDocuments);
end