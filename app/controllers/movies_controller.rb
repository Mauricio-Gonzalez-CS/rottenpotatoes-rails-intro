class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    if params[:ratings] != nil
      @movies = Movie.with_ratings(params[:ratings].keys)
      @show = Movie.new
      @ratings_to_show = @show.checkbox(params[:ratings].keys)

    elsif params[:rating] == nil
      @movies = Movie.all
      @show = Movie.new
      @ratings_to_show = @show.ratings_to_show

    elsif (!params[:ratings] and session[:ratings]) or (!params[:sort_by] and session[:sort_by])
      redirect_to movies_path(
        :ratings => session[:ratings].map { |id| [id, '1'] }.to_h, 
        :sort_by => session[:sort_by]
      ) and return 
    end

    @all_ratings = @show.all_ratings

    if params[:sort_by] =='release_date'
      @release_date_css = 'hilite bg-warning'
    end
    if params[:sort_by] == 'title'
      @title_css = 'bg-warning hilite'
    end
    if params[:sort_by]
      @movies = @movies.order(params[:sort_by])
    end
    
    
    @movie_hash = @show.convertRatingToHash(@ratings_to_show)

    session[:ratings] = @ratings_to_show
    session[:sort_by] = params[:sort_by]
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
