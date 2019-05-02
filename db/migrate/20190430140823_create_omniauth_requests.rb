class CreateOmniauthRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :omniauth_requests do |t|
      t.string :email
      t.string :uid
      t.string :name
      t.string :provider
      t.string :confirmation_token
      t.datetime :confirmation_sent_at
      t.datetime :confirmed_at

      t.timestamps
    end
  end
end
