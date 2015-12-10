module Api
  class ResultsController < ApiController
    def create
      render :ok, json: create_results
    end

    private

    def create_results
      result_data.map do |result_json|
        result = results.create! \
          tag: result_tag,
          example_name: result_json['example_name'],
          example_location: result_json['example_location']

        create_queries(result, result_json['queries']) if result_json['queries']

        result
      end
    end

    def create_queries(result, result_queries)
      result_queries.each do |result_query|
        result.queries.build(statement: result_query).save!
      end
    end

    def project
      @project ||= Project.find params[:project_id]
    end

    def results
      project.results.reorder created_at: :asc
    end

    def result_data
      params["result_data"]
    end

    def result_tag
      params["tag"]
    end
  end
end
