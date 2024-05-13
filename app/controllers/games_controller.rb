require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = generate_grid
  end

  def score
    guess = params["guess"].downcase
    grid = params["grid"].downcase

    if included?(guess, grid)
      if  english_word?(guess)
        @result = "Good guess: #{guess}"
      else
        @result = "Sorry, your word #{guess} is not an English word."
      end
    else
      @result = "Sorry, your word #{guess} is not included in: #{grid}."
    end
  end

  private

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def english_word?(guess)
    response = URI.parse("https://dictionary.lewagon.com/#{guess}")
    json = JSON.parse(response.read)
    json['found']
  end


  def generate_grid
    alphabet = ('A'..'Z').to_a
    @letters = []

    10.times do
      @letters << alphabet.sample
    end
    return @letters
  end

end
