# Wave 2
require_relative 'csv_record'
require 'pry'

module RideShare
  # inherits from CsvRecord (similar to Trip & Passenger)
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :trips
    attr_accessor :status
    
    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      # Pass to the superclass constructor (CsvRecord) similar to Passenger
      super(id)
      @name = name
      
      if vin.length != 17
        raise ArgumentError
      else
        @vin = vin
      end
      
      valid_status = %i[AVAILABLE UNAVAILABLE]
      if valid_status.include?(status)
        @status = status
      else
        raise ArgumentError
      end
      
      @trips = trips || []
    end
    
    def add_trip(trip)
      @trips << trip
    end
    
    def average_rating
      if @trips.length == 0
        return 0
      else
        avg_rating = 0
        count = 0
        @trips.each do |trip|
          unless trip.rating == nil
            avg_rating += trip.rating
            count += 1
          end
        end
        avg_rating = (avg_rating/count).to_f.round(2)
        return avg_rating
      end
    end
    
    def total_revenue
      total_rev = 0
      @trips.each do |trip|
        unless trip.cost == nil
          if trip.cost <= 1.65
            total_rev += trip.cost * 0.8
          else
            total_rev += (trip.cost - 1.65) * 0.8
          end
        end
      end
      return total_rev
    end
    
    
    def change_status
      @trips.each do |trip|
        if trip.end_time == nil
          self.status = :UNAVAILABLE
        end
      end
    end
    
    private
    
    def self.from_csv(record)
      return new(
        id: record[:id],
        name: record[:name],
        vin: record[:vin],
        status: record[:status].to_sym
      )
    end
  end
end
