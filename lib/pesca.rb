# Pesca Module
# This module is automatically loaded in the Ruby WASM REPL

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

    def size
      @partecipanti.size
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
      @destinatario = partecipante
      @destinatario.assegnato_a_qualcuno!
      true
    end

    def assegnato_a_qualcuno!
      @assegnato_a_qualcuno = true
    end

    def assegnato_a_qualcuno?
      @assegnato_a_qualcuno
    end

    def inspect
      "#{@name} -> #{@destinatario ? @destinatario.name : 'Nessuno'}"
    end

    def valid?
      @destinatario && !@bloccati.include?(@destinatario.name)
    end
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
    @partecipanti.each do |it|
      i = 0
      until it.valid?
        i += 1
        puts "Assegnando per #{it.name} ..."
        it.assegna_destinatario(@partecipanti.sample)
        raise("Oh no, più di #{@partecipanti.size * 100} tentativi: sono stanco! Devi di nuovo mettere i bigliettini nel cappello.") if i > @partecipanti.size * 100
      end
    end
  rescue => e
    puts "Errore durante l'assegnazione: #{e.message}"
  end
end

# Make it easier to access
include Pesca

puts "Pesca module loaded successfully!"
