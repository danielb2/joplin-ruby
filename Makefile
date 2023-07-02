foo:

test:
	rake spec

build:
	gem build joplin.gemspec

push: clean build
	gem push *gem
	git tag `grep VERSION lib/joplin/version.rb | sed -e 's/^.*VERSION = "\(.*\)"/\1/'`

clean:
	rm -f *gem

install: clean build
	gem install --local *gem
