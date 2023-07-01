test:
	rake spec

build:
	gem build joplin.gemspec

push: clean all
	gem push *gem

clean:
	rm -f *gem

install: clean build
	gem install --local *gem

rebuild:
	rm -rf built:\ Shape\ Up\ v\ 1.8,\ 2019\ edition/
	./bin/joplin write 59439c7f2372437b99bea1ce5277f398

