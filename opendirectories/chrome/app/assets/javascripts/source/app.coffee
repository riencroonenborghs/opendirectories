app = angular.module "opendirectories", [
  "ngAria", 
  "ngAnimate", 
  "ngMaterial", 
  "ngMdIcons",
  "opendirectories.controllers",
  "opendirectories.services",
  "opendirectories.menu.controllers",
  "opendirectories.blacklist.controllers",
  "opendirectories.queryTypes.controllers"
]

app.constant "DEFAULT_BLACKLIST", [
  "watchtheshows.com", 
  "mmnt.net", 
  "listen77.com", 
  "unknownsecret.info", 
  "trimediacentral.com", 
  "wallywashis.name", 
  "ch0c.com", 
  "hypem.com"
]

app.constant "DEFAULT_QUERY_TYPES", [
  {name: "Movies",        exts: "avi,mp4,mkv,vob,divx"}
  {name: "Music",         exts: "mp3,flac,aac"}
  {name: "Books",         exts: "pdf,epub,mob"}
  {name: "Mac Software",  exts: "dmg,sit"}
  {name: "General",       exts: ""}
]