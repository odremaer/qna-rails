class AddBestAnswerToAnswers < ActiveRecord::Migration[6.1]
  def change
    add_column :answers, :best_answer, :boolean, default: false
  end
end
