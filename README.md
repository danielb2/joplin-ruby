# Joplin


## usage

Creating a note
```ruby
Joplin::token = "your joplintoken here copied from the webclippper settings"

begin
  note = Joplin::Note.new
  note.title = "a new note"
  note.body = "markdown content"
  note.save!
rescue
  puts "Joplin not running?"
end
```

updating a note
```ruby
  note = Joplin::Note.new id: "6e3811c7a73148a" # note id can be found in the information of any note
  note.title = "a new note title"
  note.save!
```

### A note on the token

If you've got joplin installed, you can do:

``` ruby
require "joplin/token"
token = Joplin::Token.get
```

to get the token programatically. It reads from the sqlite database located in `~/.config/joplin-desktop`


## CLI

### joplin nb2n --token <yourtoken> 'notebook name'

Will take a notebook and concatenate all notes into one for easy export to PDF

The token argument is optional and if you have it installed locally it will find the token
