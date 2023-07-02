test:
	rake spec

build:
	gem build joplin.gemspec

push: clean build
	gem push *gem

clean:
	rm -f *gem

install: clean build
	gem install --local *gem
