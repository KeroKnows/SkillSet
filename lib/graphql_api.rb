# frozen_string_literal: true

require 'http'
require_relative 'jobs'

# [debug]
# require 'yaml'
# [end] debug

module SkillSet
  # Library for GraphQL API Handling
  class GraphQLApi
    API_PATH = 'https://api.graphql.jobs/'

    module Errors
      class NotFound < StandardError; end
      class InvalidQuery < StandardError; end # rubocop:disable Layout/EmptyLineBetweenDefs
      class InternalError < StandardError; end # rubocop:disable Layout/EmptyLineBetweenDefs
    end

    HTTP_ERROR = {
      400 => Errors::InvalidQuery,
      404 => Errors::NotFound,
      500 => Errors::InternalError
    }.freeze

    def job_list
      query = File.read('config/jobs_info_query.txt')
      jobs_data = fetch(query)['jobs']
      jobs_data.map { |job| JobInfo.new(job) }
    end

    def fetch(query)
      response = HTTP.post(API_PATH, json: { query: query })
      raise(HTTP_ERROR[response.code]) unless successful?(response)

      response = response.parse
      raise(HTTP_ERROR[500]) unless valid?(response)

      response['data']
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
