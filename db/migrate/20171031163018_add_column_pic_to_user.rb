class AddColumnPicToUser < ActiveRecord::Migration[5.1]
	def change
		#change_table :users do |t|
		#	t.has_attached_file :avatar
		#end
		change_column :roles,:is_active,:boolean,:default=>true
	end
end
