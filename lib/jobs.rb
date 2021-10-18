# frozen_string_literal: true

module SkillSet
  # Library for job information
  class JobInfo
    def initialize(data)
      @data = parse_job(data)
    end

    def title
      @data['title']
    end

    def description
      @data['description']
    end

    def full_info
      @data
    end

    private

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
  end
end
