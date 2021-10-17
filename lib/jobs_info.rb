# frozen_string_literal: true

require 'http'
require 'yaml'

FIXTURE_PATH = 'spec/fixtures'

def main
  fixture_dir_exist?
  query = File.read('config/jobs_info_query.txt')
  response = HTTP.post('https://api.graphql.jobs/', json: { query: query })
  results = response.parse
  data = results_to_data(results)
  File.write('spec/fixtures/graphql_jobs_results.yml', data.to_yaml)
end

def fixture_dir_exist?
  raise "directory of fixtures: #{FIXTURE_PATH} does NOT exist. please CREATE IT FIRST." unless Dir.exist? FIXTURE_PATH
end

def results_to_data(results)
  results['data']['jobs'].map { |job| parse_job(job) }
end

def parse_job(job)
  {
    'title' => job['title'],
    'tags' => job['tags'].map { |tag| tag['name'] },
    'description' => job['description'],
    'company' => job['company']['name'],
    'location' => job['locationNames'],
    'posted_date' => job['postedAt'].split('T').first
  }
end

main
