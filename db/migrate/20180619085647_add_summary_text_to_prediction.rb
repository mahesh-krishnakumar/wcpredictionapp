class AddSummaryTextToPrediction < ActiveRecord::Migration[5.2]
  def change
    add_column :predictions, :summary_text, :string
    add_column :predictions, :short_text, :string
  end
end
