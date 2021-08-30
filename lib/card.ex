defmodule Card do
  @doc """
  Creates a card based off of the type provided.
  
  ## Examples

      iex> Card.create_card(:starter)
      %{
        confidence: 1,
        confidence_needed: 0,
        description: "Add 1 to confidence",
        excitement: 0,
        type: :starter,
        effect: "+1 Confidence",
        title: "Basic Spot"
      }

  """
  def create_card(type) do
    case type do
      :event -> %{
        type: :event,
        title: "Botched Spot",
        description: "Removes 1 from draw power"
      }
      :gimmick -> %{ 
        type: :gimmick, 
        title: "Signature Move",
        description: "Add 1 to excitement", 
        effect: "+1 Excitement",
        confidence: 0, 
        excitement: 1, 
        confidence_needed: 3 
      }
      :starter -> %{ 
        type: :starter, 
        title: "Basic Spot",
        description: "Add 1 to confidence", 
        effect: "+1 Confidence",
        confidence: 1, 
        excitement: 0, 
        confidence_needed: 0 
      }
    end
  end

  @doc """
    Joins a list of cards together into a comma-separated string.

  ## Examples

      iex> deck = MainEventDraw.create_starter_deck
      iex> Card.join_card_titles(deck)
      "Basic Spot, Basic Spot, Basic Spot, Basic Spot, Basic Spot, Basic Spot, Basic Spot, Basic Spot, Basic Spot, Basic Spot"

  """
  def join_card_titles(cards) do
    Enum.map(cards, fn card -> card.title end)
    |> Enum.join(", ")
  end

  @doc """
    Shuffles cards.

  ## Examples

      iex> cards = ["Card One", "Card Two", "Card Three", "Card Four"]
      iex> shuffled_cards = Card.shuffle_cards(cards)
      iex> cards == shuffled_cards
      false
  """
  def shuffle_cards(cards) do
    Enum.shuffle(cards)
  end
end