class FindThemController < ApplicationController

  def index
    check_valid
  end

  def read_file

    # Read file and parse each line as a JSON
    customer_file = File.open(Rails.root+'public/gistfile1.txt', 'r').each_line.map { |l| JSON.parse(l) }

    return customer_file

  end

  def calculate_distance(latitude, longitude)

    # Radius of Earth in km
    r = 6371
    # Coordinates to use
    latitude_origin = 53.349805
    longitude_origin =  -6.2592576

    # Conver to radians
    rads_lat1 = latitude * Math::PI / 180
    rads_lat2 = latitude_origin * Math::PI / 180

    # Calculate deltas to use in the equation below
    delta_lat = (latitude_origin - latitude) * Math::PI / 180
    delta_lon = (longitude_origin - longitude) * Math::PI / 180

    # Equation to calculate distance between two points
    a = (Math.sin(delta_lat / 2))**2 + Math.cos(rads_lat1) * (Math.sin(delta_lon / 2))**2 * Math.cos(rads_lat2)
    c = 2 * Math.atan2( Math.sqrt(a), Math.sqrt(1-a))

    return c * r

  end

  def check_valid

    # Place all the users that have been read in the file into @all_users
    @all_users = read_file

    # New array for the invited users
    @invited_users = Array.new

    # Run all the users one by one
    @all_users.each do |user|
      # Place users that fit the condition of having 100km or less
      @invited_users << user if (calculate_distance(user["latitude"].to_f, user["longitude"].to_f) <= 100)
    end

    # Sort the users by id
    @invited_users = @invited_users.sort_by {|hash| hash["user_id"].to_i}

  end

end
