require 'spec_helper'

describe RailsAdmin::CSVConverter do
  it 'keeps headers ordering' do
    RailsAdmin.config(Player) do
      export do
        field :number
        field :name
      end
    end

    FactoryGirl.create :player
    objects = Player.all
    schema = {only: [:number, :name]}
    expect(RailsAdmin::CSVConverter.new(objects, schema).to_csv({})[2]).to match(/Number,Name/)
  end

  it 'escape formula' do
    RailsAdmin.config(Player) do
      export do
        field :number
        field :name
      end
    end

    FactoryGirl.create(:player, name: "=HYPERLINK")
    objects = Player.all
    schema = {only: [:name]}
    expect(RailsAdmin::CSVConverter.new(objects, schema).to_csv({})[2]).to end_with("'=HYPERLINK\n")
  end
end
