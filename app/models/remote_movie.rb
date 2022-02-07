class RemoteMovie
  TMDB_BASE_URL = 'https://api.themoviedb.org/3/search/movie'.freeze
  TMDB_IMAGE_URL = 'https://image.tmdb.org/t/p/w500/'.freeze

  attr_accessor :title, :poster, :description

   def initialize(title, poster, description)
    @title = title
    @poster = poster
    @description = description
  end

  def self.search(query)
    response = Faraday.get(TMDB_BASE_URL, { 
                          api_key: $api_key, 
                          language: 'pt-BR', 
                          include_adult: false, 
                          query: query })

    json = JSON.parse(response.body)
    result = json['results']

    filtered = Array.new
    for movie in result do
      if movie['overview'] != ""
        poster_path = TMDB_IMAGE_URL + (movie['poster_path']).to_s
        movie['poster_path'] = poster_path

        correct = RemoteMovie.new(  
          movie['title'],
          movie['poster_path'],
          movie['overview'])

        filtered.push(correct)
      end
    end
    filtered
  end


end