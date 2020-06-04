RSpec.describe Joplin do
  it "has a version number" do
    expect(Joplin::VERSION).not_to be nil
  end

  it "creates a note" do
    Joplin::token = ""
    # note = Joplin::Notes.new "f3b9a4891c584f388c0e2e214d2fd37f"
    # puts note.resources
    all = Joplin::Notes.all
    puts all[9]
    # expect(false).to eq(true)
  end
end
