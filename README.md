# create_wordList.m
MATLABを用いて, 論文等の文書ファイルから日常的に使用されない高頻出英単語を抽出する.

## 環境について
[MATLAB](https://jp.mathworks.com/products/matlab.html) R2023aにて実行を確認しております. 必要となるtoolboxは以下になります.

* [Statistics and Machine Learning Toolbox](https://jp.mathworks.com/products/statistics.html)
* [Text Analytics Toolbox](https://jp.mathworks.com/products/text-analytics.html)

## 構文
```
wordList = create_wordList(doc_folder_name,deleteWords)
wordList = create_wordList(doc_folder_name,deleteWords,options)
[wordList,docsList] = create_wordList(_)
```

```
wordTable = create_wordList(doc_folder_name,deleteWords,'outputTable',true)
wordTable = create_wordList(doc_folder_name,deleteWords,'outputTable',true,options)
[wordTable,docsList] = create_wordList(_)
```

## 説明

### string型で英単語リストを出力

* create_wordList(doc_folder_name,deleteWords) は, doc_folder_nameディレクトリ内に入っている文書から単語を抽出し, deleteWordsに含まれる単語と既定の閾値により日常的に使用される単語や重要でない単語の削除を行います. その結果はstring型データとして英単語リストのみが出力されます.
* create_wordList(doc_folder_name,deleteWords,options) は, 指定された閾値による単語の削除を行います.
* [wordList,docsList] = create_wordList(_) は, 抽出された英単語のリストだけではなく, 読み込みに成功した文書のリストをdocsListとして出力します．

### table型で英単語リストを出力

* create_wordList(doc_folder_name,deleteWords,'outputTable',true) は, doc_folder_nameディレクトリ内に入っている文書から単語を抽出し, deleteWordsに含まれる単語と既定の閾値により日常的に使用される単語や重要でない単語の削除を行います. その結果はtable型として, 英単語リストに加えて各単語の頻度等の情報と共に出力されます.
* create_wordList(doc_folder_name,deleteWords,'outputTable',true,options) は, 指定された閾値による単語の削除を行います.
* [wordTable,docsList] = create_wordList(_) は, 抽出された英単語リスト及び各単語の情報だけではなく, 読み込みに成功した文書のリストをdocsListとして出力します．

## 例

### New General Service Listを用いた英単語の抽出

この例では, [NGSL](http://www.newgeneralservicelist.org/)単語リストを用いて, 読み込まれた文書から抽出された英単語から, 日常的に使用される単語を削除することで, 高頻出で専門的な英単語を抽出する. まず, [NGSL](http://www.newgeneralservicelist.org/)から得られる単語リスト(doc内にあり)をMATLABに読み込み, string型の単路リストとして読み込む (詳細は[create_NGSL_wordList.m](create_NGSL_wordList.m)を参照).

```
>> create_NGSL_wordList()
```

[create_NGSL_wordList関数](create_NGSL_wordList.m)は, doc内にある[NGSL](http://www.newgeneralservicelist.org/)単語リストを"NGSL_wordList.mat"として保存する. 
その後, このデータを用いて作成する英単語リストから削除する必要のある単語をまとめたデータを作成する.

```
load("NGSL_wordList.mat");
delete_words = [delete_words;NGSL1000];
delete_words = [delete_words;NGSL2000];
delete_words = [delete_words;NGSLSupplemental];
delete_words = [delete_words;NAWL];
```

次に, 読み込む文書ファイル"papers/"に保存する. (読み込むことのできる文書については, [extractFileText関数](https://jp.mathworks.com/help/textanalytics/ref/extractfiletext.html)を参照). そして, このフォルダを指定して, 単語リストの抽出を開始する.

```
path_to_doc_folder = "papers"
wordList = create_wordList(path_to_doc_folder,delete_words)
```

これらの手順について詳しくは, [create_wordList_with_function.m](create_wordList_with_function.m)を参照.

### 文書の読み込み情報の確認

create_wordListは2番目の出力として, 読み込まれた文書ファイルの中で, 読み込み結果を示した情報を出力します. この結果はtable型として出力されます.

```
load("NGSL_wordList.mat");
delete_words = [delete_words;NGSL1000];
delete_words = [delete_words;NGSL2000];
delete_words = [delete_words;NGSLSupplemental];
delete_words = [delete_words;NAWL];
path_to_doc_folder = "papers"
[wordList,docsList] = create_wordList(path_to_doc_folder,delete_words)
```

### 閾値の指定

create_wordListでは, 英単語リストの作成の際に, 閾値を用いて重要な英単語のみを出力する. 個の閾値を指定する際には, オプション引数を使用する.

```
load("NGSL_wordList.mat");
delete_words = [delete_words;NGSL1000];
delete_words = [delete_words;NGSL2000];
delete_words = [delete_words;NGSLSupplemental];
delete_words = [delete_words;NAWL];
path_to_doc_folder = "papers"
wordList = create_wordList(path_to_doc_folder,delete_words,'minFreq',100,'minRange',10,'minChars',2,'maxChars',10)
```

### 英単語リストとその情報を取得

英単語リストとして出力された各単語が, 読み込まれた文書の中でその程度出現しているかについての情報を得たい場合には, オプション引数の'oputputTable'を利用する. この時, 出力される"wordList"はtable型となる.

```
load("NGSL_wordList.mat");
delete_words = [delete_words;NGSL1000];
delete_words = [delete_words;NGSL2000];
delete_words = [delete_words;NGSLSupplemental];
delete_words = [delete_words;NAWL];
path_to_doc_folder = "papers"
wordList = create_wordList(path_to_doc_folder,delete_words,'outputTable',true)
```

### 実行状況に関する詳しい情報を取得する.

読み込む文書数に応じて, 本関数の実行時間は前後します. もし, 実行中に詳しい情報を取得したい場合は, オプション引数の'verbose'を使用します.

```
load("NGSL_wordList.mat");
delete_words = [delete_words;NGSL1000];
delete_words = [delete_words;NGSL2000];
delete_words = [delete_words;NGSLSupplemental];
delete_words = [delete_words;NAWL];
path_to_doc_folder = "papers"
wordList = create_wordList(path_to_doc_folder,delete_words,'verbose',true)
```

## 入力引数

### doc_folder_name - 読み込む文書が入るフォルダ名
**string**

読み込む文書が入るフォルダの名前を記入する. ここで, 選択できるフォルダ名は1つのみである. また, 読み込むことのできる文書については, [extractFileText関数](https://jp.mathworks.com/help/textanalytics/ref/extractfiletext.html)を参照.

### deleteWords - 単語リストに含まれない単語を指定
**string**

文書から抽出された単語の中で, 単語リストに含まない単語を指定する. 例えば, 日常的に使用される単語等を入力する際に用いる.

### minFreq - 単語リストに含まれる単語の最低頻度の指定
**数値, （初期値: 10）**

文書から抽出された単語の中で, ここで指定された数値よりも多くの出現回数を持つ単語のみをリストに含める.

### minRange - 単語リストに含まれる単語の出現範囲の指定
**数値, （初期値: 1）**

文書から抽出された単語の中で, ここで指定された数値よりも多くの文書に出現する単語のみをリストに含める.

### minChars - 単語リストに含まれる単語の最低文字数の指定
**数値, （初期値: 3）**

文書から抽出された単語の中で, ここで指定された数値よりも多くの文字数を持つ単語のみをリストに含める.

### maxChars - 単語リストに含まれる単語の最大文字数の指定
**数値, （初期値: 20）**

文書から抽出された単語の中で, ここで指定された数値よりも小さい文字数を持つ単語のみをリストに含める.

### outputTable - 作成された英単語の情報も出力
**logical, （初期値: false）**

出力リストに含まれるwordListに抽出された単語リストに加えて, その単語の出現回数や出現範囲に関する情報を出力する.

### verbose - 詳細情報の表示
**logical, （初期値: false）**

コマンドウィンドウに実行状況に関する詳細情報を表示.

## 出力引数

### wordList - 作成された単語リスト
**string or table**

作成された英単語リスト. outputTableの値によって, string型またはtable型により出力される.

### docsList - 読み込まれた文書リスト
**table**

英単語を作成するのに読み込まれた文書に関する情報を出力.

## 参照

[1] [Uehara, S., Haraki, H., & McLean, S. (2022). Developing a Discipline-Specific Corpus and High-Frequency Word List for Science and Engineering Students in Graduate School. Vocabulary Learning and Instruction, 11(2), 1–12.](https://vli-journal.org/wp/vli-112-uehara-et-al-2022/)

[2] [NEW GENERATION SERVICE LIST PROJECT (NGSL)](http://www.newgeneralservicelist.org/)

[3] [（Qiita記事）MATLABで論文から自分だけのオリジナル英単語帳を作成する](https://qiita.com/hibs_MATLAB_Amb/items/c32200f30804349b413b)