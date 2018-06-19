class AddSummaryTextToMatch < ActiveRecord::Migration[5.2]
  def change
    add_column :matches, :summary_text, :string
    add_column :matches, :short_text, :string
  end
end
