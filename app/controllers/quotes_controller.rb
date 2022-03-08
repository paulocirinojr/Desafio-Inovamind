require 'nokogiri'
require 'open-uri'

class QuotesController < ApplicationController

  # Autenticação com token
  TOKEN = "inovamind"
  include ActionController::HttpAuthentication::Token::ControllerMethods

  # Verifica autenticação antes da requisição
  before_action :authenticate

  # Crawler
  SITE_URL = "http://quotes.toscrape.com"

  # Retorna a lista com todos quotes cadastrados
  # CÓDIGOS DE RETORNO:
  # 200 - Caso a requisição possua dados válidos
  # 404 - Caso não exista nenhum cadastro no BD
  def index
    @quotes = Quote.all

    if (@quotes.length > 0)
      render json: @quotes, status: :ok
    else
      render json: {
        info: "Nenhuma frase encontrada no banco de dados!"
      }, status: :not_found
    end
  end

  # Inicia o processo de verificação da tag recebida. [/quotes/{SEARCH_TAG}]
  def show
    crawler(params[:id])
  end

  def crawler(param)
    # Obtém o conteúdo HTML da página
    html = Nokogiri::HTML(URI.open(SITE_URL))

    # Obtem os quotes da página
    html.search('div.quote').each do |q|
      tags = q.search('div.tags') # Obtém as tags dos quotes

        tags.each do |t|
          if (t.text.include?(param)) # Compara a tag recebida com as do quote.
            checkQuote(q, t)
          end
        end
    end

    checkTag(param)

  end

  # Cadastra a tag no banco de dados caso não seja encontrada.
  # Caso seja encontrada, retorna as frases que possuem a tag.
  def checkTag(tag)
    if (Tag.where(tag: tag).length == 0)
      Tag.create!(
        tag: tag
      )
    end
    # Obtém os quotes que possuem a tag solicitada
    @quotes = Quote.where(tags: { '$in': [tag]})
    
    if (@quotes.length > 0)
      render json: @quotes, status: :ok
    else
      render json: {
        info: "Nenhuma frase encontrada com a tag informada!"
      }, status: :not_found
    end
  end

  # Cadastra o Quote obtido, caso não exista no BD
  def checkQuote(quote, tags)
    if (Quote.where(quote: getQuote(quote)).length == 0)
      q = Quote.create!(
        quote: getQuote(quote),
        author: getAuthor(quote),
        author_about: getAuthorAbout(quote),
        tags: getTags(tags)
      )
    end
  end

  # Obtém os dados do autor 
  def getAuthor(quote)
    author = quote.css('small.author').text
    author
  end

  # Obtém o link sobre o autor
  def getAuthorAbout(quote)
    aut_url = quote.css('a').first.attributes["href"].value
    aut_about = SITE_URL + aut_url
    aut_about
  end

  # Obtém a frase
  def getQuote(quote)
    q = quote.css('span.text').text
    q
  end

  # Quebra a string de tags e retorna em um array
  def getTags(tags)
    t = tags.text.split(" ")
    arr = []

    t.each do |word|
        arr.push(word) unless word == "Tags:"
    end
    arr
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quote
      @quote = Quote.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def quote_params
      params.require(:quote).permit(
      :quote, :author, :author_about,
      tags_attributes: [:tag]
      )
    end

    def authenticate
      authenticate_or_request_with_http_token do |token, options|
        ActiveSupport::SecurityUtils.secure_compare(
          ::Digest::SHA256.hexdigest(token),
          ::Digest::SHA256.hexdigest(TOKEN)
        )
      end
    end
end
