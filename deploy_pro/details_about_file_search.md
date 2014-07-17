# Details about File Search
## <a id="search-opt"></a>Search Options

Following options should be set in file **seafevents.conf**, and need to restart seafile and seahub to take affect.

```
[INDEX FILES]
...
# Whether search office/pdf files. Defaults to false.
index_office_pdf = true

# Set search language.
lang = german
```

Following options should be set in file **seahub_settings.py**, and need to restart seahub to take affect.

```
# Whether highlight the keywords in the file when the visit is via clicking a link in 'search result' page. 
# Defaults to false. Since v3.0.5.
HIGHLIGHT_KEYWORD = True
```

## <a id="wiki-faq"></a>Common problems


### <a id="wiki-search-office-pdf"></a>I can't search Office/PDF files


First, make sure you have `index_office_pdf = true` in the file **seafevents.conf**:

```
[INDEX FILES]
...
index_office_pdf = true

```

Second, check whether the program **pdftotext** has been installed.

If you have not installed **pdftotext**, you can't extract text from PDF files.

```
which pdftotext
```

Run the above command, if there is no output, then you need to install it:

```
sudo apt-get install poppler-utils
```

After installed **pdftotext**, you need to re-build your search index:

```
./pro/pro.py search --clear
./pro/pro.py search --update
```


### <a id="wiki-search-no-result"></a>I get no result when I search a keyword

The search index is updated every 10 minutes by default. So before the first index update is performed, you get nothing no matter what you search.

  To be able to search immediately,

  - Make sure you have started seafile server
  - Update the search index manually:
```
      cd haiwen/seafile-pro-server-2.0.4
     ./pro/pro.py search --update
```

### <a id="wiki-cannot-search-encrypted-files"></a>Encrypted files cannot be searched

This is because the server can't index encrypted files, since, they are encrypted.

### <a id="wiki-set-search-lang"></a>Handle your language more gracefully

**Note**: Added in seafile pro server 3.0.3.

Say your files are mainly in German, you can specify it in `seafevents.conf`:

```
[INDEX FILES]
...
lang = german
```

This way, the text of your files can be handled more gracefully when you search them.

*Anytime you change the value of `lang`, you have to delete the search index and recreate it:*

```
./pro/pro.py search --clear
./pro/pro.py search --update
```

Supported languages include: `arabic`, `armenian`, `basque`, `brazilian`, `bulgarian`, `catalan`, `chinese`, `cjk`, `czech`, `danish`, `dutch`, `english`, `finnish`, `french`, `galician`, `german`, `greek`, `hindi`, `hungarian`, `indonesian`, `italian`, `norwegian`, `persian`, `portuguese`, `romanian`, `russian`, `spanish`, `swedish`, `turkish`, `thai`




