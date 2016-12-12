require 'split'
require 'csv'
require 'bigdecimal'

module Split
  module Export
    extend self

    def round(number, precision = 2)
      BigDecimal.new(number.to_s).round(precision).to_f
    end

    def to_csv
      csv = CSV.generate do |csv|
        csv << ['Experiment', 'Alternative', 'Participants', 'Completed', 'Conversion Rate', 'Z score', 'Control', 'Winner']
        Split::ExperimentCatalog.all.each do |experiment|
          goals = experiment.goals + [nil] # nil corresponds to conversions without any goals.

          experiment.alternatives.each do |alternative|
            csv << [experiment.name,
                    alternative.name,
                    alternative.participant_count,
                    goals.inject(0) { |sum, g| sum + alternative.completed_count(g) },
                    round(goals.inject(0) { |sum, g| sum + alternative.conversion_rate(g) }, 3),
                    round(alternative.z_score, 3),
                    alternative.control?,
                    alternative.to_s == experiment.winner.to_s]
          end
        end
      end
    end

    def experiment_to_csv(experiment)
      csv = CSV.generate do |csv|
        csv << %w(Alternative Goal Participants Completed Conversion\ Rate Z\ Score Control Winner)

        experiment = Split::ExperimentCatalog.find(experiment)

        break if !experiment

        goals = [nil] + experiment.goals # nil corresponds to conversions without any goals.

        experiment.alternatives.each do |alternative|
          goals.each do |goal|
            csv << [alternative.name,
                    goal,
                    alternative.participant_count,
                    alternative.completed_count(goal),
                    alternative.conversion_rate(goal),
                    alternative.z_score(goal),
                    alternative.control?,
                    alternative.to_s == experiment.winner.to_s]
          end
        end
      end
    end
  end
end
