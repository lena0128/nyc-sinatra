class FiguresController < ApplicationController
  # add controller methods
  
  get '/figures' do
    @figures = Figure.all
    erb :"/figures/index"
  end
  
  get '/figures/new' do
    @titles = Title.all
    @landmarks = Landmark.all
   erb :"/figures/new"
  end

  get '/figures/:id' do
    @figure = Figure.find(params[:id])
    erb :"/figures/show"
  end

  get '/figures/:id/edit' do
    @figure = Figure.find(params[:id])
    @titles = Title.all
    @landmarks = Landmark.all
    erb :"/figures/edit"
  end

  post '/figures' do
    @figure = Figure.create(params["figure"])
    @title = Title.find_by(:name => params[:title][:name])
    @landmark = Landmark.find_by(:name => params[:landmark][:name])
    @title_ids = params[:figure][:title_ids]
    @landmark_ids =params[:figure][:landmark_ids]
   
    if @title == nil
      new_title = Title.create(:name => params[:title][:name])
      @figure.titles << new_title
    end

    if @title_ids
       @title_ids.each do |id|
        new_title = Title.find(id)
        @figure.titles << new_title
       end
  end

    if @landmark == nil
      new_landmark = Landmark.create(:name => params[:landmark][:name])
      @figure.landmarks << new_landmark
    end

    if @landmark_ids
      @landmark.ids.each do |id|
        new_landmark = Landmark.find(id)
        @figure.landmarks << new_landmark
      end
    end

    @figure.save
    redirect "/figure/#{@figure.id}"
  end

  patch '/figures/:id' do
    @title = params[:title]
    @title_ids = params[:figure][:title_ids]
    @landmark = params[:landmark]
    @landmark_ids = params[:figure][:landmark_ids]

    @figure = Figure.find(params[:id])
    @figure.name = params[:figure][:name]
    if @title_ids
      @figure.titles.clear
      @title_ids.each do |id|
        t = Title.find(id)
        @figure.titles << t
      end
    end
    if !@title[:name].empty?
      new_title = Title.create(:name => @title[:name])
      @figure.titles << new_title
    end
    if @landmark_ids
      @figure.landmarks.clear
      @landmark_ids.each do |id|
        lm = Landmark.find(id)
        @figure.landmarks << lm
      end
    end
    if !@landmark[:name].empty?
      new_landmark = Landmark.create(:name => @landmark[:name])
      @figure.landmarks << new_landmark
    end
    @figure.save
    redirect to "/figures/#{@figure.id}"
  end


end
