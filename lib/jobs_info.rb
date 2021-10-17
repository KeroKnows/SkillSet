# frozen_string_literal: true

require 'http'
require 'yaml'

FIXTURE_PATH = 'spec/fixtures'

def main
  fixture_dir_exist?
  query = File.read('config/jobs_info_query.txt')
  data = request_data('https://api.graphql.jobs/', query)
  File.write('spec/fixtures/graphql_jobs_results.yml', data.to_yaml)
end

def fixture_dir_exist?
  raise "directory of fixtures: #{FIXTURE_PATH} does NOT exist. please CREATE IT FIRST." unless Dir.exist? FIXTURE_PATH
end

def request_data(api_url, query)
  response = HTTP.post(api_url, json: { query: query })
  raise "Request data failed. HTTP status code: #{response.code}" unless response.code == 200

  results = response.parse
  results_to_data(results)
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
