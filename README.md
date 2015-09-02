# Opendirectories
... is a bunch of tools to help facilitate [search](https://github.com/riencroonenborghs/opendirectories/tree/master/opendirectories) and [acquisition](https://github.com/riencroonenborghs/opendirectories/tree/master/downloader) of data.

## Search data
... through a [Chrome Extension](https://github.com/riencroonenborghs/opendirectories/tree/master/opendirectories/chrome) or a [Firefox Add-on](https://github.com/riencroonenborghs/opendirectories/tree/master/opendirectories/firefox). 

The Chrome Extension has more features. The Add-on search is pretty basic, but gets the job done.

### How to install the Chrome Extension
- go to `chrome://extensions`
- check `Developer mode` *(top right)*
- click `Load unpacked extension...` *(top left)*
- point it to the extension *(the folder with the manifest.json file)*
- click `Select`
### How to install the Firefox Add-on
- go to `about:addons`
- click settings button next to the search field *(top right)* and select `Install Add-on From File...`
- point it to the extension *(the folder with the manifest.json file)*
- click `Open`

## Acquire data
... through a [Chrome Extension](https://github.com/riencroonenborghs/opendirectories/tree/master/downloader/chrome/downloader) and a [Rails 4 App](https://github.com/riencroonenborghs/opendirectories/tree/master/downloader/rails/downloader). It handles regular URLs, BBC iPlayer videos and Youtube videos.

Install the Extension like above. 

Deploy the Rails 4 App like any other app.
The Rails 4 App requires both [get_iplayer](https://github.com/get-iplayer/get_iplayer) and [youtube-dl](https://github.com/rg3/youtube-dl) to do the heavy lifting.

## Scripts
Two scripts that are basically a wrapper around `wget` and `get_iplayer`.