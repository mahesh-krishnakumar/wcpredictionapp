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
      user_predictions.where(match: match).first
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

    def match_card__header_classes(prediction)
      'match-card__header' + (prediction.persisted? ? ' match-card__header--predicted' : '')
    end

    def match_dates
      Match.unlocked.pluck(:kick_off).map(&:to_date).uniq.sort!
    end

    def date_strip_initial_slide
      match_dates.index(Date.today) || 0
    end

    def unlocked_matches
      @unlocked_matches ||= Match.unlocked
    end

    def unlocked_matches_by_day
      @unlocked_matches_by_day ||= begin
        matches = Match.unlocked.group_by_day { |m| m.kick_off }
        matches.each_with_object({}) do |(day, matches), hash|
          hash[day] = matches.sort_by(&:kick_off)
        end
      end
    end

    def pending_predictions_count
      unlocked_matches.count - user_predictions.where(match: unlocked_matches).count
    end

    def predictions_completed_text(day)
      "#{predictions_by_day(day).count}/#{matches_by_day(day).count}"
    end

    def match_count(day)
      matches_by_day(day).count
    end

    def predictions_complete?(day)
      match_count(day) == predictions_by_day(day).count
    end

    def match_status_text(match)
      if match.completed?
        'Match Complete'
      elsif match.kick_off > Time.now
        'Match Starting'
      elsif Time.now.between?(match.kick_off, match.kick_off + 2.hours)
        'Match Ongoing'
      else
        'Awaiting Results'
      end
    end

    private

    def user_predictions
      @user_predictions ||= @user.predictions
    end

    def matches_by_day(day)
      unlocked_matches_by_day[day]
    end

    def predictions_by_day(day)
      user_predictions.where(match: matches_by_day(day))
    end
  end
end