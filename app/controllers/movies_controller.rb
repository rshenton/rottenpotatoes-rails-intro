class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @sort = params[:sort] || session[:sort]
    @checked_ratings = params[:ratings] || session[:ratings] || Hash[Movie.all_ratings.map {|k| [k, true]}]
    @all_ratings = Hash[Movie.all_ratings.map {|k| [k, @checked_ratings.key?(k)]}]
    
    session[:sort] = @sort
    session[:ratings] = @checked_ratings
    
    if !params[:sort] || !params[:ratings]
      flash.keep
      redirect_to movies_path(:ratings => @checked_ratings, :sort => @sort) and return
    end
    
    @movies = Movie.where(:rating => @checked_ratings.keys).order @sort
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
