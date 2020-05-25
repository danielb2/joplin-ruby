RSpec.describe Joplin do
  it "has a version number" do
    expect(Joplin::VERSION).not_to be nil
  end

  it "creates a note" do
    Joplin::token = ""
    note = Joplin::Notes.new "2415cd89551f408a9ae02c5967f3d62b"
    puts note
    note.body = "something different further"
    note.save!
    # puts note
    # note2 = Joplin::Notes.new
    # note2.title = "a generatednote"
    # note2.body = "with some *content*"
    # note2.save!
    # expect(false).to eq(true)
  end
end
