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

### Saving to a specific notebook

You can specify the id of the notebook

```ruby
  note = Joplin::Note.new parent_id: 'c5e6827be8c946c78210d3508cce7ea6'
```

## CLI

### joplin nb2n --token <yourtoken> 'notebook name'

Will take a notebook and concatenate all notes into one for easy export to PDF

The token argument is optional and if you have it installed locally it will find the token

### joplin epub <id of note>

This will generate an epub from the referenced notes in the note. It will not
include the actual note, but only linked markdown notes within. Rendering
things like tables, mermaid diagrams etc is not supported
