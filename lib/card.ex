defmodule Card do
  defstruct [
    :type,
    :title,
    :description,
    :effect,
    confidence: 0,
    excitement: 0,
    confidence_needed: 0
  ]

  @doc """
    Draws a card from a set. Returns a tuple containing two lists: the card drawn and the remainder of the set.
  
  ## Examples

      iex> set = Card.new_set(:starter)
      iex> { [ card ], _remaining_set } = Card.draw(set)
      iex> card
      %Card{
        description: "Add 1 to confidence",
        confidence: 1,
        excitement: 0,
        type: :starter,
        confidence_needed: 0,
        effect: "+1 Confidence",
        title: "Basic Spot"
      }

  """
  def draw(set) do
    Enum.split(set, 1)
  end

  @doc """
  Creates a card based off of the type provided.
  
  ## Examples

      iex> Card.new(:starter)
      %Card{
        confidence: 1,
        confidence_needed: 0,
        description: "Add 1 to confidence",
        excitement: 0,
        type: :starter,
        effect: "+1 Confidence",
        title: "Basic Spot"
      }

  """
  def new(type) do
    case type do
      :event -> %Card{
        type: :event,
        title: "Botched Spot",
        description: "Removes 1 from draw power",
        effect: { :reduce_draw_power, 1 }
      }
      :gimmick -> %Card{ 
        type: :gimmick, 
        title: "Signature Move",
        description: "Add 1 to excitement", 
        effect: "+1 Excitement",
        confidence: 0, 
        excitement: 1, 
        confidence_needed: 3 
      }
      :starter -> %Card{ 
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
    Creates a set of cards of a specific type.

  ## Examples

      iex> deck = Card.new_set(:starter)
      iex> Enum.count(deck)
      10

  """
  def new_set(type) do
    case type do
      :event -> 
        Enum.map(0..19, fn _x -> Card.new(:event) end)
      :gimmick ->
        Enum.map(0..19, fn _x -> Card.new(:gimmick) end)
      :starter ->
        Enum.map(0..9, fn _x -> Card.new(:starter) end)
    end
  end

  @doc """
    Joins a list of cards together into a comma-separated string.

  ## Examples

      iex> deck = Card.new_set(:starter)
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

      iex> cards = ["Card One", "Card Two", "Card Three", "Card Four", "Card Five"]
      iex> shuffled_cards = Card.shuffle_cards(cards)
      iex> cards == shuffled_cards
      false
  """
  def shuffle_cards(cards) do
    Enum.shuffle(cards)
  end
end