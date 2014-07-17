# Configurable Options
In the file `/data/haiwen/pro-data/seafevents.conf`:

```
[INDEX FILES]
## must be "true" to enable search
enabled = true

## The interval the search index is updated. Can be s(seconds), m(minutes), h(hours), d(days)
interval=10m

## If true, index the contents of office/pdf files while updating search index
## Note: If you change this option from "false" to "true", then you need to clear the search index and update the index again. See the FAQ for details.
index_office_pdf=false

[OFFICE CONVERTER]

## must be "true" to enable office/pdf file online preview
enabled = true

## How many libreoffice worker process to run concurrenlty
workers = 1

## where to store the converted office/pdf files
outputdir = /tmp/

## how many pages are allowed to be previewed online. Default is 50 pages
max-pages = 50

## the max size of documents to allow to be previewed online, in MB. Default is 2 MB
max-size = 2

[SEAHUB EMAIL]

## must be "true" to enable user email notifications when there are new messages
enabled = true

## interval of sending seahub email. Can be s(seconds), m(minutes), h(hours), d(days)
interval = 30m

```

### <a id="wiki-options-you-may-want-to-modify"></a>Options you may want to modify

The section above listed all the options in `/data/haiwen/pro-data/seafevents.conf`. Most of the time you can use the default settings. But you may want to modify some of them to fit your own use case. 

We list them in the following table, as well as why we choose the default value.

<table>
<tr>
<th>section</th>
<th>option</th>
<th>default value</th>
<th>description</th>
</tr>

<tr>
<td>INDEX FILES</td>
<td>index_office_pdf</td>
<td>false</td>
<td>
The full text search of office/pdf documents is not enabled by default. This is because it may consume quite some space for the search index. To turn it on, set this value to "true" and recreate the search index. See the [[FAQ For Seafile Professional Server]] for detail.
</td>
</tr>

<tr>
<td>OFFICE CONVERTER</td>
<td>max-size</td>
<td>2MB</td>
<td>
The max file size allowed to be previewed online is 2MB. The preview is converted office/pdf to HTML and display it in the browser. If the file size is too large, the conversion may take too long time and consume much space
</td>
</tr>

<tr>
<td>OFFICE CONVERTER</td>
<td>max-pages</td>
<td>50</td>
<td>
When previewing a office/pdf document online, the pages displayed is the first 50 pages. If the value is too large, the conversion may take too long time and consume much space.
</td>
</tr>

</table>
