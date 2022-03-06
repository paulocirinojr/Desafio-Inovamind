require "test_helper"

class QuotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @quote = quotes(:one)
  end

  test "should get index" do
    get quotes_url, as: :json
    assert_response :success
  end

  test "should create quote" do
    assert_difference("Quote.count") do
      post quotes_url, params: { quote: { author: @quote.author, author_about: @quote.author_about, quote: @quote.quote } }, as: :json
    end

    assert_response :created
  end

  test "should show quote" do
    get quote_url(@quote), as: :json
    assert_response :success
  end

  test "should update quote" do
    patch quote_url(@quote), params: { quote: { author: @quote.author, author_about: @quote.author_about, quote: @quote.quote } }, as: :json
    assert_response :success
  end

  test "should destroy quote" do
    assert_difference("Quote.count", -1) do
      delete quote_url(@quote), as: :json
    end

    assert_response :no_content
  end
end
