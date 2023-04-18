function textdata = extract_text_from_docs(filename)
%   extract_text_from_docs - Function of extracting text from files for file datastore.
%   Thedetail information is <a href="matlab:web('https://jp.mathworks.com/help/textanalytics/ref/extractfiletext.html')">extract FileText</a> function

    try
        textdata = extractFileText(filename);
    catch
        textdata = '';
    end
end