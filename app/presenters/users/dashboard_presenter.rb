module Users
  class DashboardPresenter
    def initialize(user)
      @user = user
    end

    def groups
      @groups ||= @user.groups
    end

    def upcoming_matches
      @upcoming_matchs ||= Match.unlocked.upcoming.group_by_day { |m| m.kick_off }
    end

    def completed_matches
      @completed_matches ||= Match.completed.group_by_day { |m| m.kick_off }
    end

    def prediction(match)
      @user.predictions.where(match: match).first
    end

    def predictions_result
      @predictions_result ||= begin
        groups.each_with_object({}) do |group, result|
          result[group.id] = Matches::PredictionResultService.new(group).results
        end
      end
    end

    def predictions_list
      @predictions_list ||= begin
        groups.each_with_object({}) do |group, predictions|
          predictions[group.id] = Matches::PredictionListService.new(group).list
        end
      end
    end

    def current_standing
      @current_standing ||= Users::RanksService.new(@user).ranks
    end

    def closing_soon_text
      matches = Match.closing_soon
      return nil if matches.empty?

      list = matches.map do |match|
        "#{match.team_1.short_name} vs #{match.team_2.short_name}(#{match.kick_off.strftime('%b %d')})"
      end.join(', ')

      "Closing soon: #{list}"
    end

    def match_list__card_header_classes(prediction)
      'match-list__card-header' + (prediction.persisted? ? ' match-list__card-header--predicted' : '')
    end
  end
end