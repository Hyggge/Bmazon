class AddArticleReferenceToReplies < ActiveRecord::Migration[7.0]
  def change
    add_reference :replies, :article, null: false, foreign_key: true
  end
end
