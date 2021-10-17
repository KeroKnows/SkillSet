
module SkillSet
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
        'tags' => job['tags'],
        'description' => job['description'],
        'company' => job['company'],
        'location' => job['location'],
        'posted_date' => job['posted_date']
      }
    end
  end
end
