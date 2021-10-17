# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require_relative '../lib/graphql_api'

CORRECT_QUERY = File.read('config/jobs_info_query.txt')
CORRECT = YAML.safe_load(File.read('spec/fixtures/graphql_jobs_results.yml'))

describe 'Test GraphQLApi library' do
  describe 'HTTP communication' do
    it 'HAPPY: should fetch with correct query' do
      result = SkillSet::GraphQLApi.new.fetch(CORRECT_QUERY)
      _(result).wont_be_empty
    end

    it 'HAPPY: job list should be JobInfo' do
      jobs = SkillSet::GraphQLApi.new.job_list
      jobs.each { |job| _(job).must_be_instance_of SkillSet::JobInfo }
    end

    it 'SAD: should raise exception on invalid queries' do
      _(proc do
        SkillSet::GraphQLApi.new.fetch('query: { invalid }')
      end).must_raise SkillSet::GraphQLApi::Errors::InvalidQuery
    end
  end

  describe 'JobInfo' do
    before do
      @jobs = SkillSet::GraphQLApi.new.job_list
      @job = @jobs.first
    end

    it 'HAPPY: should have title' do
      _(@job).must_respond_to :title
    end

    it 'HAPPY: should have description' do
      _(@job).must_respond_to :description
    end

    it 'HAPPY: can get full information' do
      _(@job).must_respond_to :full_info
    end
  end
end
