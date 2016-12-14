require 'split'
require 'csv'
require 'bigdecimal'

module Split
  module Export
    extend self

    def round(number, precision = 2)
      BigDecimal.new(number.to_s).round(precision).to_f
    end

    # this method calculates the z_score for an alternative including all goals. This behavior should
    # be added to Alternative#z_score but until then, this method will do. I lifted most of the code from that method.
    def z_score_all_goals(alternative) 
      goals = alternative.goals + [nil]
      control = alternative.experiment.control

      return 'N/A' if control.name == alternative.name

      p_a = goals.inject(0) { |sum, g| sum + alternative.conversion_rate(g) }
      p_c = goals.inject(0) { |sum, g| sum + control.conversion_rate(g) }

      n_a = alternative.participant_count
      n_c = control.participant_count

      z_score = Split::Zscore.calculate(p_a, n_a, p_c, n_c)
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
                    round(z_score_all_goals(alternative), 3),
                    alternative.control?,
                    alternative.to_s == experiment.winner.to_s]
          end
        end
      end
    end

    def experiment_to_csv(experiment)
      csv = CSV.generate do |csv|
        csv << ["Alternative", "Goal", "Participants", "Completed", "Conversion Rate", "Z Score", "Control", "Winner"]

        experiment = Split::ExperimentCatalog.find(experiment)

        break if !experiment

        goals = [nil] + experiment.goals # nil corresponds to conversions without any goals.

        experiment.alternatives.each do |alternative|
          goals.each do |goal|
            csv << [alternative.name,
                    goal,
                    alternative.participant_count,
                    alternative.completed_count(goal),
                    round(alternative.conversion_rate(goal), 3),
                    round(alternative.z_score(goal), 3),
                    alternative.control?,
                    alternative.to_s == experiment.winner.to_s]
          end
        end
      end
    end
  end
end
