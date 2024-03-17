#!/bin/bash

# installs planets in content/planets directory
if [[ -d /home/martin/stitlestaticsiteupload/content/planets ]] ; then
  rm -r /var/www/www.supertitle.org/htdocs/content/planets
fi
mv /home/martin/stitlestaticsiteupload/content/planets /var/www/www.supertitle.org/htdocs/content/

# installs fractals in content/fractals directory
if [[ -d /home/martin/stitlestaticsiteupload/content/fractals ]] ; then
  rm -r /var/www/www.supertitle.org/htdocs/content/fractals
fi
mv /home/martin/stitlestaticsiteupload/content/fractals /var/www/www.supertitle.org/htdocs/content/

# installs blaufisch in content/blaufisch directory
if [[ -d /home/martin/stitlestaticsiteupload/content/blaufisch ]] ; then
  rm -r /var/www/www.supertitle.org/htdocs/content/blaufisch
fi
mv /home/martin/stitlestaticsiteupload/content/blaufisch /var/www/www.supertitle.org/htdocs/content/

# installs knights in content/knights directory
if [[ -d /home/martin/stitlestaticsiteupload/content/knights ]] ; then
  rm -r /var/www/www.supertitle.org/htdocs/content/knights
fi
mv /home/martin/stitlestaticsiteupload/content/knights /var/www/www.supertitle.org/htdocs/content/

# installs server
if [[ -d /var/www/www.supertitle.org/server ]] ; then
  rm -r /var/www/www.supertitle.org/server
fi
mv /home/martin/stitlestaticsiteupload/server /var/www/www.supertitle.org/
chmod a+x /var/www/www.supertitle.org/server/index.js

mv /home/martin/stitlestaticsiteupload/package.json /var/www/www.supertitle.org/
starting_directory=$PWD
cd /var/www/www.supertitle.org/
npm install
cd $starting_directory

# installs web root files in web root directory
mv /home/martin/stitlestaticsiteupload/index.html /var/www/www.supertitle.org/htdocs/
mv /home/martin/stitlestaticsiteupload/screen.css /var/www/www.supertitle.org/htdocs/
mv /home/martin/stitlestaticsiteupload/logo.png /var/www/www.supertitle.org/htdocs/
mv /home/martin/stitlestaticsiteupload/background.png /var/www/www.supertitle.org/htdocs/
mv /home/martin/stitlestaticsiteupload/settings.png /var/www/www.supertitle.org/htdocs/
