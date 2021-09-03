class ExerciseTrackerController < ApplicationController
  def addUser
    user = User.new({ username: params[:username] })
    user.save
    render json: { 'username': user.username, '_id': user.id }
  end

  def getUsers
    users = []

    User.all.each do |user|
      users << { :username => user.username, :_id => user.id.to_s }
    end

    render json: users
  end

  def addExercise
    user = User.find(params[:_id])

    if params[:date]
      date = Date.parse(params[:date])
    else
      date = Date.today
    end

    ex = Exercise.new({ :user => user, :description => params[:description], :duration => params[:duration], :date => date })
    ex.save

    render json: { :username => user.username, :_id => user.id, :description => ex.description, :duration => ex.duration.to_i, :date => date.strftime("%a %b %d %Y") }
  end

  def getLog
    user = User.find(params[:_id])

    log = { :username => user.username, :_id => user.id, :log => [] }

    user.exercises.each do |ex|
      if params[:from] and ex.date < Date.parse(params[:from])
        next
      end
      if params[:to] and ex.date > Date.parse(params[:to])
        next
      end
      log[:log] << { :description => ex.description, :duration => ex.duration.to_i, :date => ex.date.strftime("%a %b %d %Y") }
    end

    if params[:limit]
      log[:log] = log[:log][-params[:limit].to_i..(log[:log].length - 1)]
    end

    log[:count] = log[:log].length

    render json: log
  end
end
