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

  class Partecipanti
    include Enumerable
    extend Forwardable

    def_delegators :@partecipanti, :reject

    attr_accessor :names

    def initialize
      @partecipanti = []
    end

    def reset!
      @partecipanti = []
    end

    def aggiungi(name, bloccati: "")
      @partecipanti << Partecipante.new(name, bloccati: bloccati.split(",").map(&:strip))
    end

    def lista
      @partecipanti.map(&:inspect)
    end

    def each(&block)
      @partecipanti.each(&block)
    end

    def sample
      @partecipanti.sample
    end
  end

  class Partecipante
    attr_reader :name

    def initialize(name, bloccati: [])
      @name = name
      @assegnato = nil
      @bloccati = bloccati
      @assegnato_a_qualcuno = false
    end

    def assegna_destinatario(partecipante)
      return false if partecipante.assegnato_a_qualcuno?
      return false if partecipante == self
      return false if @bloccati.include?(partecipante.name)

      @destinatario = partecipante
      @destinatario.assegnato_a_qualcuno!
      true
    end

    def assegnato_a_qualcuno! = @assegnato_a_qualcuno = true
    def assegnato_a_qualcuno? = @assegnato_a_qualcuno
    def destinatario? = !!@destinatario
    def inspect = "#{@name} -> #{@destinatario ? @destinatario.name : 'Nessuno'}"
  end

  def self.reset!
    @partecipanti = nil
  end

  def self.imposta_partecipanti(&block)
    @partecipanti ||= Partecipanti.new

    @partecipanti.instance_exec(&block)
  end

  def self.lista_partecipanti
    @partecipanti ? @partecipanti.lista : []
  end

  def self.assegna!
    until @partecipanti.all?(&:destinatario?)
      @partecipanti.reject(&:destinatario?).each do
        puts "Provo ad assegnare destinatario per #{it.name}"
        it.assegna_destinatario(@partecipanti.reject(&:assegnato_a_qualcuno?).sample)
      end
    end

    puts @partecipanti.lista
  end
end

puts "Pesca module loaded successfully!"
