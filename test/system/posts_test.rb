require "application_system_test_case"

class PostsTest < ApplicationSystemTestCase
  setup do
    @post = posts(:one)
  end

  test "visiting the index" do
    visit posts_url
    assert_selector "h1", text: "Latest Posts"
  end

  test "should create post" do
    visit posts_url
    click_on "New post"

    fill_in "Title", with: @post.title
    # Action Text/Trix editor - set content via JavaScript
    trix_editor = find("trix-editor")
    page.execute_script("arguments[0].editor.loadHTML('<div>Test content for new post</div>')", trix_editor.native)
    click_on "Create Post"

    assert_text "Post was successfully created"
    click_on "Back to posts"
  end

  test "should update Post" do
    visit post_url(@post)
    click_on "Edit post"

    fill_in "Title", with: "Updated title"
    # Action Text/Trix editor - set content via JavaScript
    trix_editor = find("trix-editor")
    page.execute_script("arguments[0].editor.loadHTML('<div>Updated content</div>')", trix_editor.native)
    click_on "Update Post"

    assert_text "Post was successfully updated"
    click_on "Back to posts"
  end

  test "should destroy Post" do
    visit post_url(@post)
    # Accept the confirmation dialog when deleting
    accept_confirm do
      click_on "Delete post"
    end

    assert_text "Post was successfully destroyed"
  end
end
