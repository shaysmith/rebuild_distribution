#!/bin/bash

#/Let's query the user for the correct distribution to update.
echo "https://www.drupal.org/project/project_distribution"
echo "Enter distribution name:"
read distribution_name

#/Let's find out which version of the distribution to build.
echo "Enter a distribution version or version branch:"
read distribution_version_branch

#/Query the user for an alternate makefile to build form if they have one.
echo "Enter a path to an alternate makefile to build from or press enter:"
read distribution_makefile

#/Using the user supplied information to build a working URL to the distribution repo.
GITURL="http://git.drupal.org/project/${distribution_name}.git" BRANCH="${distribution_version_branch}" PREFIX="ra-projects/${distribution_name}"

#/Change directories into the git root directory.
cd "$(git rev-parse --show-toplevel)"

#/Grabbing a copy of the distribution repo to work with.
echo "Pulling in latest updates on branch $BRANCH from remote $GITURL."
mkdir ra-projects
git clone $GITURL ra-projects/${distribution_name}

#/Pull in the correct version of the distro.
git subtree pull --squash --prefix=$PREFIX $GITURL $BRANCH

#/Let's preserve any custom bits by moving them out of the docroot.
cd "$(git rev-parse --show-toplevel)"
echo "Moving .htaccess out of docroot..."
cp docroot/.htaccess .
echo "Moving robots.txt out of docroot..."
cp docroot/robots.txt .
echo "Moving sites directory out of docroot..."
cp -rf docroot/sites .
if [[ -f docroot/favicon.ico ]]
	cp docroot/favicon.ico .
fi

#/Delete the docroot directory.
echo "Removing docroot..."
rm -rf docroot
echo "Building ${distribution_name} profile..."

#/Run drush make against the default makefile or a user specified make file.
if [[ -z ${distribution_make} ]]; then
	drush make -y ${distribution_makefile} docroot --no-gitinfofile
else
	drush make -y ra-projects/${distribution_name}/build-${distribution_name}.make docroot --no-gitinfofile
fi

#/Let's remove the default bits that were updated in the docroot.
echo "Removing default .htaccess from docroot..."
rm docroot/.htaccess
echo "Removing default robots.txt from docroot..."
rm docroot/robots.txt
echo "Removing default sites directory from docroot..."
rm -rf docroot/sites
if [[ -f favicon.ico ]]
        rm docroot/favicon.ico .
fi

#/Let's put the custom bits back into the docroot and clean up our mess.
echo "Moving custom .htaccess back into docroot..."
mv .htaccess docroot/.htaccess
echo "Moving custom robots.txt back into docroot..."
mv robots.txt docroot/robots.txt
echo "Moving custom sites directory back into docroot..."
mv sites docroot/sites
if [[ -f favicon.ico ]]
        cp favicon.ico docroot/favicon.ico
fi

#/Cleaning up our working directory by removing it.
rm -rf ra-projects

#/And now for some git specific juju.
#git add --all
#git commit -m "initials: Updating Distribution."

