# this is for development purposes, until I can figure out a better way to test
# timetrap formatters locally :thinking:

default:
	gem build ./timetrap_everhour.gemspec
	gem install --force --no-ri --no-rdoc ./timetrap_everhour-0.0.1.gem
