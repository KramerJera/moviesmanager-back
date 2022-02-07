class MoviesController < ApplicationController
  before_action :authorize_access_request!
  before_action :fetch_profile
  before_action :set_movie, only: %i[ show update destroy ]

  # GET /movies
  def index
    @movies = @profile.movies

    render json: @movies
  end

  # GET /movies/1
  def show
    render json: @movie
  end

  # POST /movies
  def create
    @movie = @profile.movies.new(movie_params)

    if @movie.save
      render json: @movie, status: :created
    else
      render json: @movie.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /movies/1
  def update
    if @movie.update(movie_params)
      render json: @movie
    else
      render json: @movie.errors, status: :unprocessable_entity
    end
  end

  # DELETE /movies/1
  def destroy
    @movie.destroy
  end

  def search
    movie = params[:search_term]
    filtered = RemoteMovie.search(movie)
    render json: filtered
  end

  def watchlist
    @movies = @profile.movies.where(watchlist: true)

    render json: @movies
  end

  def watched
    @movies = @profile.movies.where(watched: true)

    render json: @movies
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = @profile.movies.find(params[:id])
    end

    def fetch_profile
      @profile = current_user.profiles.find(params[:profile_id])
    end

    # Only allow a list of trusted parameters through.
    def movie_params
      params.require(:movie).permit(:title, :poster, :description, :watchlist, :watched, :profile_id)
    end
end
