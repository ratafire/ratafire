class AddPredictedAmountToBillingArtists < ActiveRecord::Migration
  def change
  	add_column :billing_artists, :predicted_next_amount, :decimal, :default => 0, :precision => 10, :scale => 2
  end
end
