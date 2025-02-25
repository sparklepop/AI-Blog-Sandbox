class AddImagePromptToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :image_prompt, :string
    add_column :posts, :image_url, :string
  end
end
