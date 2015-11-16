rm -rf app/assets/javascripts/build
coffee -o app/assets/javascripts/build -c app/assets/javascripts/source/*.coffee
