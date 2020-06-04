all:
	gem build joplin.gemspec

push: clean all
	gem push *gem

clean:
	rm *gem
