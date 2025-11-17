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
      @participants
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

    def assign_recipient(recipient)
      return false if recipient.assigned_to_someone?
      return false if recipient == self
      return false if @blocked.include?(recipient.name)

      @recipient = recipient
      @recipient.assigned_to_someone!
      true
    end

    def reset_assignment!
      @recipient = nil
      @assigned_to_someone = false
    end

    def unassign_recipient!
      @recipient = nil
    end

    def unassign_from_someone!
      @assigned_to_someone = false
    end

    def assigned_to_someone! = @assigned_to_someone = true
    def assigned_to_someone? = @assigned_to_someone
    def recipient? = !!@recipient
    def to_s = "#{@name} -> #{@recipient ? @recipient.name : 'Nobody'}"
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
    participants = @participants.to_a
    participants.each(&:reset_assignment!)

    unless assign_recursive(participants)
      # This would be a bug in the algorithm or constraints are too tight
      raise "No valid assignment found. Check blocked constraints."
    end

    puts @participants.list
  end

  # Recursive backtracking search algorithm
  def self.assign_recursive(participants, index = 0)
    return true if index == participants.length

    giver = participants[index]
    available = participants.reject(&:assigned_to_someone?)

    available.shuffle.each do |recipient|
      if giver.assign_recipient(recipient)
        return true if assign_recursive(participants, index + 1)

        giver.unassign_recipient!
        recipient.unassign_from_someone!
      end
    end

    false
  end
end

puts "Pesca module loaded successfully!"
