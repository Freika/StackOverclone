require 'rails_helper'

describe Answer do
  it { should validate_presence_of :body }

  it do
    should belong_to :question
  end
end
