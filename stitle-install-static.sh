#!/bin/bash

# installs planets in content/planets directory
if [[ -d /home/martin/stitlestaticsiteupload/content/planets ]] ; then
  rm -r /var/www/www.supertitle.org/htdocs/content/planets
  mv /home/martin/stitlestaticsiteupload/content/planets /var/www/www.supertitle.org/htdocs/content/
fi

# installs fractals in content/fractals directory
if [[ -d /home/martin/stitlestaticsiteupload/content/fractals ]] ; then
  rm -r /var/www/www.supertitle.org/htdocs/content/fractals
  mv /home/martin/stitlestaticsiteupload/content/fractals /var/www/www.supertitle.org/htdocs/content/
fi

# installs blaufisch in content/blaufisch directory
if [[ -d /home/martin/stitlestaticsiteupload/content/blaufisch ]] ; then
  rm -r /var/www/www.supertitle.org/htdocs/content/blaufisch
  mv /home/martin/stitlestaticsiteupload/content/blaufisch /var/www/www.supertitle.org/htdocs/content/
fi

# installs knights in content/knights directory
if [[ -d /home/martin/stitlestaticsiteupload/content/knights ]] ; then
  rm -r /var/www/www.supertitle.org/htdocs/content/knights
  mv /home/martin/stitlestaticsiteupload/content/knights /var/www/www.supertitle.org/htdocs/content/
fi

# installs web root files in web root directory
mv /home/martin/stitlestaticsiteupload/index.html /var/www/www.supertitle.org/htdocs/
mv /home/martin/stitlestaticsiteupload/screen.css /var/www/www.supertitle.org/htdocs/
mv /home/martin/stitlestaticsiteupload/logo.png /var/www/www.supertitle.org/htdocs/
mv /home/martin/stitlestaticsiteupload/background.png /var/www/www.supertitle.org/htdocs/
mv /home/martin/stitlestaticsiteupload/settings.png /var/www/www.supertitle.org/htdocs/
