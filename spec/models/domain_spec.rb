require 'rails_helper'

RSpec.describe Domain, type: :model do

  it 'can have multiple collaborators' do
    collaborator1 = User.new
    collaborator2 = User.new
    domain = Domain.new(collaborators: [collaborator1, collaborator2])
    expect(domain.collaborators.length).to eq(2)
  end

end