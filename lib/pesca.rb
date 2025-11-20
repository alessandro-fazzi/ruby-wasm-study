# Pesca Module
# This module is automatically loaded in the Ruby WASM REPL

require 'forwardable'

module Pesca
  VERSION = "0.1.0"

  def self.greet(name = "World")
    "Hello, #{name}! Welcome to Pesca!"
  end

  def self.info
    puts "Pesca Ruby REPL v#{VERSION}"
    puts "Ruby version: #{RUBY_VERSION}"
    puts "Platform: #{RUBY_PLATFORM}"
  end

  class Participants
    include Enumerable
    extend Forwardable

    def_delegators :@participants, :reject

    attr_accessor :names

    def initialize
      @participants = []
    end

    def reset!
      @participants = []
    end

    def add(name, blocked: "")
      @participants << Participant.new(name, blocked: blocked.split(",").map(&:strip))
    end

    def list
      @participants.map(&:inspect)
    end

    def each(&block)
      @participants.each(&block)
    end

    def sample
      @participants.sample
    end
  end

  class Participant
    attr_reader :name

    def initialize(name, blocked: [])
      @name = name
      @assigned = nil
      @blocked = blocked
      @assigned_to_someone = false
    end

    def assign_recipient(participant)
      return false if participant.assigned_to_someone?
      return false if participant == self
      return false if @blocked.include?(participant.name)

      @recipient = participant
      @recipient.assigned_to_someone!
      true
    end

    def assigned_to_someone! = @assigned_to_someone = true
    def assigned_to_someone? = @assigned_to_someone
    def recipient? = !!@recipient
    def inspect = "#{@name} -> #{@recipient ? @recipient.name : 'Nobody'}"
  end

  def self.reset!
    @participants = nil
  end

  def self.set_participants(&block)
    @participants ||= Participants.new

    @participants.instance_exec(&block)
  end

  def self.list_participants
    @participants ? @participants.list : []
  end

  def self.assign!
    until @participants.all?(&:recipient?)
      @participants.reject(&:recipient?).each do
        puts "Trying to assign recipient for #{it.name}"
        it.assign_recipient(@participants.reject(&:assigned_to_someone?).sample)
      end
    end

    puts @participants.list
  end
end

puts "Pesca module loaded successfully!"
