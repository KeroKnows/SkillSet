# frozen_string_literal: true

require 'http'
require_relative 'jobs'

# [debug]
require 'yaml'
# [end] debug

module SkillSet
  class GraphQLApi
    API_PATH = 'https://api.graphql.jobs/'

    module Errors
      class NotFound < StandardError; end
      class InvalidQuery < StandardError; end
      class InternalError < StandardError; end
    end

    HTTP_ERROR = {
      400 => Errors::InvalidQuery,
      404 => Errors::NotFound,
      500 => Errors::InternalError
    }.freeze

    def job_list
      query = File.read('config/jobs_info_query.txt')
      jobs_data = fetch(query)
      jobs_data.map { |job| JobInfo.new(job) }
    end

    def fetch(query)
      response = HTTP.post(API_PATH, json: { query: query })
      raise(HTTP_ERROR[response.code]) unless successful?(response)

      response = response.parse
      raise(HTTP_ERROR[500]) unless valid?(response)

      # response = YAML.safe_load(File.read('spec/fixtures/graphql_jobs_results.yml'))
      response
    end

    private

    def successful?(result)
      !HTTP_ERROR.keys.include?(result.code)
    end

    def valid?(result)
      !result.include?('errors')
    end
  end
end
