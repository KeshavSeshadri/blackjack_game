require "json"
require "net/http"

class DeckApiClient
  ROOT_PATH = "https://deckofcardsapi.com/api"

  def new_shuffled_deck(deck_count: 2, cards: nil)
    query = {
      deck_count: deck_count,
      cards: cards,
    }
    handle_reponse(response: Net::HTTP.get_response(build_uri(path: "/deck/new/shuffle/", query_hash: query)))
  end

  def draw_cards_from_deck(deck_id:, card_count: 1)
    query = { count: card_count }
    handle_reponse(response: Net::HTTP.get_response(build_uri(path: "/deck/#{deck_id}/draw/", query_hash: query)))
  end

  def new_deck
    handle_reponse(response: Net::HTTP.get_response(build_uri(path: "/deck/new/")))
  end

  def shuffle_deck(deck_id:, remaining: false)
    query = { remaining: remaining }
    handle_reponse(response: Net::HTTP.get_response(build_uri(path: "/deck/#{deck_id}/shuffle/", query_hash: query)))
  end

  def add_card_from_deck_to_pile(deck_id:, pile_name:, cards:)
    query = { cards: cards }
    handle_reponse(response: Net::HTTP.get_response(build_uri(path: "/deck/#{deck_id}/pile/#{pile_name}/add/", query_hash: query)))
  end

  private 

  def build_uri(path:, query_hash: {})
    uri = URI("#{ROOT_PATH}#{path}")
    uri.query = URI.encode_www_form(query_hash.compact)
    p uri
    URI.parse(uri.to_s)
  end

  def handle_reponse(response:)
    if response.is_a?(Net::HTTPSuccess) 
      JSON.parse(response.body)
    else
      raise "boo!!!!"
    end
  end


    # /deck/<<deck_id>>/pile/<<pile_name>>/add/?cards=AS,2S

    # /deck/<<deck_id>>/pile/<<pile_name>>/shuffle/

    # /deck/<<deck_id>>/pile/<<pile_name>>/list/

    # /deck/<<deck_id>>/pile/<<pile_name>>/draw/?cards=AS
    # /deck/<<deck_id>>/pile/<<pile_name>>/draw/?count=2
    # /deck/<<deck_id>>/draw/bottom/
    # /deck/<<deck_id>>/draw/random/

    # /deck/<<deck_id>>/return/
    # /deck/<<deck_id>>/pile/<<pile_name>>/return/
    # /deck/<<deck_id>>/return/?cards=AS,2S
    # /deck/<<deck_id>>/pile/<<pile_name>>/return/?cards=AS,2S
end

# new_deck = DeckApiClient.new.new_shuffled_deck(deck_count: 3)
# p new_deck
# p DeckApiClient.new.draw_cards_from_deck(deck_id: new_deck["deck_id"], card_count: 1)
# new_deck = DeckApiClient.new.shuffle_deck(deck_id: new_deck["deck_id"])

# new_deck = DeckApiClient.new.new_deck
# p new_deck
# p DeckApiClient.new.shuffle_deck(deck_id: new_deck["deck_id"])

# p DeckApiClient.new.new_shuffled_deck(deck_count: 1, cards: "AS")

new_deck = DeckApiClient.new.new_shuffled_deck(deck_count: 1)
p DeckApiClient.new.add_card_from_deck_to_pile(deck_id: new_deck["deck_id"], pile_name: "myhappypile", cards: "AS,KC")

