require 'http'
require 'yaml'

def main
  query = File.read('config/query.txt')
  response = HTTP.post('https://api.graphql.jobs/', :json => { :query => query })
  results = response.parse
  data = results_to_data(results)
  File.write('spec/fixtures/graphql_jobs_results.yml', data.to_yaml)
end

def results_to_data(results)
  results['data']['jobs'].map { |job| parse_job(job) }
end

def parse_job(job)
  {
    "title" => job['title'],
    "tags" => job['tags'].map { |tag| tag['name'] },
    "description" => job['description'],
    "company" => job['company']['name'],
    "location" => job['locationNames'],
    "posted_date" => job['postedAt'].split('T').first
  }
end

main