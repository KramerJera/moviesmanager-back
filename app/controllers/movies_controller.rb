class MoviesController < ApplicationController
  before_action :authorize_access_request!
  before_action :fetch_profile
  before_action :set_movie, only: %i[ show update destroy ]

  require_relative '../../.tmdb_api_key.rb'
  require 'faraday/net_http'
  Faraday.default_adapter = :net_http

  # GET /movies
  def index
    @movies = @profile.movies.all

    render json: @movies
  end

  # GET /movies/1
  def show
    render json: @movie
  end

  # POST /movies
  def create
    @movie = Movie.new(movie_params)

    if @movie.save
      render json: @movie, status: :created, location: @movie
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

    response = Faraday.get('https://api.themoviedb.org/3/search/movie', { 
                          api_key: $api_key, 
                          language: 'pt-BR', 
                          include_adult: false, 
                          query: movie })

    json = JSON.parse(response.body)
    result = json['results']

    filtered = Array.new
    for movie in result do
      if movie['overview'] != ""
        poster_path = "https://image.tmdb.org/t/p/w500" + (movie['poster_path']).to_s
        movie['poster_path'] = poster_path
        filtered.push(movie)
      end
    end

    render json: filtered
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params[:id])
    end

    def fetch_profile
      @profile = current_user.profiles.find(params[:profile_id])
    end

    # Only allow a list of trusted parameters through.
    def movie_params
      params.require(:movie).permit(:title, :poster, :description, :watchlist, :watched, :profile_id)
    end
end
