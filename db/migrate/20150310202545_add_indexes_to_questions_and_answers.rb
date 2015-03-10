class AddIndexesToQuestionsAndAnswers < ActiveRecord::Migration
  def change
    change_table :questions do |t|
      t.index :user_id
    end

    change_table :answers do |t|
      t.index :user_id
      t.index :question_id
    end
  end
end


