all:
	gem build joplin.gemspec

push: clean all
	gem push *gem

clean:
	rm -f *gem

test:
	rake

install: clean all
	gem install --local *gem
