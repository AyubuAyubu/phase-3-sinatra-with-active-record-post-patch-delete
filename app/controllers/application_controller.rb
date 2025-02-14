class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'

  #GET REQUEST
  get '/games' do
    games = Game.all.order(:title).limit(10)
    games.to_json
  end

  get '/games/:id' do
    game = Game.find(params[:id])

    game.to_json(only: [:id, :title, :genre, :price], include: {
      reviews: { only: [:comment, :score], include: {
        user: { only: [:name] }
      } }
    })
  end

  #DELETE REQUEST
  delete '/reviews/:id' do
    # find the review using the ID
    # delete the review
    # send a response with the deleted review as JSON
    review = Review.find(params[:id])
    review.destroy
    review.to_json
  end

  #POST REQUEST
  post '/reviews' do
  review = Review.create(
    score: params[:score],
    comment: params[:comment],
    game_id: params[:game_id],
    user_id: params[:user_id]
  )
  review.to_json
end

    #PATCH REQUEST
    #Handle requests with the PATCH HTTP verb to /reviews/:id
    #Find the review to update using the ID
    #Access the data in the body of the request
    #Use that data to update the review in the database
    #Send a response with updated review as JSON

    patch '/reviews/:id' do
      review = Review.find(params[:id])
      review.update(
        score: params[:score],
        comment: params[:comment]
  )
  review.to_json
end
