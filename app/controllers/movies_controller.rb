class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # preserve sort and rating filter options
    if params.has_key?(:ratings)
      session[:ratings] = params[:ratings]
    end

    if params.has_key?(:sort)
      session[:sort] = params[:sort]
    end

    if !params.has_key?(:ratings) && !params.has_key?(:sort)
      p = Hash.new
      if session.has_key?(:ratings)
        p[:ratings] = session[:ratings]
      end
      if !session.has_key?(:sort)
        p[:sort] = session[:sort]
      end
      if !p.empty?
        redirect_to movies_path(p)
      end
    end
    @all_ratings = []
    Movie.all_ratings.each do |rating|
      checked = false;
      unless params[:ratings].nil?
        checked = params[:ratings].include?(rating)
      end
      @all_ratings << [rating, checked]
    end
    @sort_by = params[:sort]
    @movies = Movie.order(@sort_by)
    unless params[:ratings].nil?
      @movies = @movies.where(:rating => params[:ratings].keys)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end


  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
