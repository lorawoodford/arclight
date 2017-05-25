# frozen_string_literal: true

require 'spec_helper'

describe Arclight::SearchBehavior do
  subject(:search_builder_instance) { search_builder.with(user_params) }

  let(:user_params) { {} }
  let(:solr_params) { {} }
  let(:context) { CatalogController.new }
  let(:search_builder_class) do
    Class.new(Blacklight::SearchBuilder).tap do |klass|
      include Blacklight::Solr::SearchBuilderBehavior
      klass.include(described_class)
    end
  end
  let(:search_builder) { search_builder_class.new(context) }

  describe '#add_hierarchy_max_rows' do
    context 'when in hierarchy view' do
      let(:user_params) { { view: 'hierarchy' } }

      it 'adds pseudo unlimited rows to query' do
        expect(search_builder_instance.add_hierarchy_max_rows(solr_params)).to include(rows: 999_999_999)
      end
    end
    context 'when not in hierarchy view' do
      it 'does not affect rows param' do
        expect(search_builder_instance.add_hierarchy_max_rows(solr_params)).to eq({})
      end
    end
  end
end
