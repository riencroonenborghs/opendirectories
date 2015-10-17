# Opendirectories

## Search

![Screenshot 1](https://raw.githubusercontent.com/riencroonenborghs/opendirectories/master/screenshots/downloader1.png)
![Screenshot 2](https://raw.githubusercontent.com/riencroonenborghs/opendirectories/master/screenshots/downloader2.png)
![Screenshot 3](https://raw.githubusercontent.com/riencroonenborghs/opendirectories/master/screenshots/downloader3.png)

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

## Downloader

It handles regular URLs, BBC iPlayer videos and Youtube videos.

Install the Extension like above. Somewhere in the sources there's a `SERVER` and `PORT` constant. Change it to your needs. There's a `build.sh` to help you out afterwards.

### How to install the Chrome Extension
- go to `chrome://extensions`
- check `Developer mode` *(top right)*
- click `Load unpacked extension...` *(top left)*
- point it to the extension *(the folder with the manifest.json file)*
- click `Select`

![Screenshot 1](https://raw.githubusercontent.com/riencroonenborghs/opendirectories/master/screenshots/opendirectories1.png)
![Screenshot 1](https://raw.githubusercontent.com/riencroonenborghs/opendirectories/master/screenshots/opendirectories2.png)

... is a bunch of tools to help facilitate [search](https://github.com/riencroonenborghs/opendirectories/tree/master/opendirectories) and [acquisition](https://github.com/riencroonenborghs/opendirectories/tree/master/downloader) of data.

### Rails 4 app

Deploy the Rails 4 App like any other app.
The Rails 4 App requires both [get_iplayer](https://github.com/get-iplayer/get_iplayer) and [youtube-dl](https://github.com/rg3/youtube-dl) to do the heavy lifting. [Resque](https://github.com/resque/resque) does the queue handling.

## Scripts
Two scripts that are basically a wrapper around `wget` and `get_iplayer`.