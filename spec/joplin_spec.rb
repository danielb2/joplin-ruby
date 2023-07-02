RSpec.describe Joplin do
  it 'has a version number' do
    expect(Joplin::VERSION).not_to be nil
  end

  it 'can get a webclipper token' do
    expect(Joplin.get_token).not_to be nil
  end

  it 'can do an implicit get of a webclipper token' do
    expect(Joplin.token).not_to be nil
  end

  it 'creates a note' do
    note = Joplin::Note.new
    note.title = 'easy_to_find_note'
    note.body = 'a healthy note'
    note.save!

    saved = Joplin::Note.new id: note.id
    expect(saved.title).to eq('easy_to_find_note')

    saved.title = 'also_easy_to_find_note'
    saved.save!

    updated = Joplin::Note.new id: note.id
    expect(updated.title).to eq('also_easy_to_find_note')

    updated.delete!

    expect do
      Joplin::Note.new id: note.id
    end.to raise_error Joplin::Error
  end
end
