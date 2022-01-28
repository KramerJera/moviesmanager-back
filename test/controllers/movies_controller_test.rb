require "test_helper"

class MoviesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @movie = movies(:one)
  end

  test "should get index" do
    get movies_url, as: :json
    assert_response :success
  end

  test "should create movie" do
    assert_difference("Movie.count") do
      post movies_url, params: { movie: { poster: @movie.poster, profile_id: @movie.profile_id, title: @movie.title, watched: @movie.watched, watchlist: @movie.watchlist } }, as: :json
    end

    assert_response :created
  end

  test "should show movie" do
    get movie_url(@movie), as: :json
    assert_response :success
  end

  test "should update movie" do
    patch movie_url(@movie), params: { movie: { poster: @movie.poster, profile_id: @movie.profile_id, title: @movie.title, watched: @movie.watched, watchlist: @movie.watchlist } }, as: :json
    assert_response :success
  end

  test "should destroy movie" do
    assert_difference("Movie.count", -1) do
      delete movie_url(@movie), as: :json
    end

    assert_response :no_content
  end
end
