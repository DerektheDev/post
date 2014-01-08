class Campaign < ActiveRecord::Base

  has_many :resources

  def ordered_stylesheets markup_name, scope = "all"
    # what is the markup document? e.g. california.html
    filename_string = markup_name.split('.').first

    # what should we retrieve? styles for the head? for the body to be inlined?
    scope = scope.to_s

    # return an array of requested resources in the proper parsing order
    o = []
    patterns_array = stylesheet_sorting_patterns(markup_name, scope)
    patterns_array.each do |query|
      if matches = resources.where("file_file_name like ?", query)
        matches.each do |match|
          o.push match
        end
      end
    end
    o
  end

  def stylesheet_sorting_patterns markup_name, scope = "all"
    # ORDER OF COMPILATION/SPECIFICITY
    #   BODY:
    #     reset.css, reset_1.css, global.css, global_1.css
    #     california.css, california_1.css
    #   HEAD:
    #     global_head.css, global_head_1.css
    #     california_head.css, california_head_1.css
    scopes = {
      head: [
        "global_head.%",
        "global_head_%.%",
        "#{markup_name}_head.%",
        "#{markup_name}_head_%.%"
      ],
      inline: [
        "reset.%",
        "reset_%.%",
        "global.%",
        "global_%.%",
        "#{markup_name}.%",
        "#{markup_name}_%.%"
      ]
    }
    patterns = case scope
    when "head", "inline"
      scopes[scope.to_sym]
    else
      (scopes[:head] | scopes[:inline])
    end
    patterns
  end

end
