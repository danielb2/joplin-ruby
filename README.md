# Joplin


## usage

Creating a note
```ruby
Joplin::token = "your joplintoken here copied from the webclippper settings"

begin
  note = Joplin::Notes.new
  note.title = "a new note"
  note.body = "markdown content"
  note.save!
rescue
  puts "Joplin not running?"
end
```

updating a note
```ruby
  note = Joplin::Notes.new "6e3811c7a73148a" # note id can be found in the information of any note
  note.title = "a new note title"
  note.save!
end
```
