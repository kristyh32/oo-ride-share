require 'csv'
require 'time'

require_relative 'csv_record'

module RideShare
  class Trip < CsvRecord
    attr_reader :id, :passenger, :passenger_id, :start_time, :end_time, :cost, :rating, :driver_id, :driver
    
    def initialize(id:,
      passenger: nil, passenger_id: nil,
      start_time:, end_time:, cost: nil, rating:, driver_id: nil, driver: nil)
      super(id)
      
      if passenger
        @passenger = passenger
        @passenger_id = passenger.id
        
      elsif passenger_id
        @passenger_id = passenger_id
      else
        raise ArgumentError.new('Passenger or passenger_id is required')
      end
      
      @start_time = start_time
      @end_time = end_time
      @cost = cost
      @rating = rating
      
      if  @rating == nil
        @rating = nil   
      elsif @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end
      
      if @end_time == nil
        @end_time = nil
      elsif @start_time > @end_time
        raise ArgumentError.new("Start time must occur prior to end time")
      end
      
      if driver
        @driver = driver
        @driver_id = driver.id
      elsif driver_id
        @driver_id = driver_id
      elsif driver == nil
        raise ArgumentError.new("Driver or driver id is required")
      else
        raise ArgumentError.new("Driver or driver id is required")
      end
      
      
    end
    
    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
      "ID=#{id.inspect} " +
      "PassengerID=#{passenger&.id.inspect}>"
    end
    
    def connect(passenger, driver)
      @passenger = passenger
      @driver = driver
      passenger.add_trip(self)
      driver.add_trip(self)
    end
    
    def duration
      duration_in_sec = @end_time - @start_time
      return duration_in_sec
    end
    
    private
    
    def self.from_csv(record)
      return self.new(
        id: record[:id],
        driver_id: record[:driver_id],
        passenger_id: record[:passenger_id],
        start_time: Time.parse(record[:start_time]),
        end_time: Time.parse(record[:end_time]),
        cost: record[:cost],
        rating: record[:rating]
      )
    end
  end
end
