# Opendirectories

## Search

- Search your thing!
- Maintain a list of comma separated query types and blacklisted URLs

### Screenshots

![Screenshot 1](https://raw.githubusercontent.com/riencroonenborghs/opendirectories/master/screenshots/opendirectories1.png)

![Screenshot 2](https://raw.githubusercontent.com/riencroonenborghs/opendirectories/master/screenshots/opendirectories2.png)

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

- Has a server and client part
- The server is written in Rails 4, requires both [get_iplayer](https://github.com/get-iplayer/get_iplayer) and [youtube-dl](https://github.com/rg3/youtube-dl) to do the heavy lifting. [Resque](https://github.com/resque/resque) does the queue handling. It handles regular URLs, BBC iPlayer videos and Youtube videos. BBC iPlayer does require the correct location or a proxy (`.env`'s PROXY key).
- The client is a Chrome extension and is written in plain HTML, coffeescript and AngularJS. `build.sh` converts the coffeescript into javascript. Somewhere in the sources there's a `SERVER` and `PORT` constant. Change it to your needs.

### Screenshots

![Screenshot 1](https://raw.githubusercontent.com/riencroonenborghs/opendirectories/master/screenshots/downloader1.png)

![Screenshot 2](https://raw.githubusercontent.com/riencroonenborghs/opendirectories/master/screenshots/downloader2.png)

![Screenshot 3](https://raw.githubusercontent.com/riencroonenborghs/opendirectories/master/screenshots/downloader3.png)