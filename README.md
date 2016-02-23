# rebuild_distribution
This script is based on code found at:
https://dev.acquia.com/blog/maintaining-your-installed-drupal-distro

When run, it will attempt to rebuild a Drupal distribution based on user input.

# User prompts
The user will be prompted for the following information:

# Distribution name.
This is the lowercase project name for the distribution you wish to rebuild.

# Distribution version or version branch.
This is either the exact version number you wish to rebuild to (i.e. 7.x-1.2) or a branch (7.x-1.x).

# Path to an  alternate makefile.
If you have another makefile that you would prefer to build from rather than the default makefile in a distribution, the path can be specified here.

If no path is specified, the default behavior is to look for appropriate make file in:
ra-projects/${distribution_name}/build-${distribution_name}.make

For a list of available Drupal distributions:
https://www.drupal.org/project/project_distribution 
