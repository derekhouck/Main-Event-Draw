defmodule Card do
  defstruct [
    :type,
    :title,
    :description,
    :effect,
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
        type: :starter,
        confidence_needed: 0,
        effect: { :add_confidence, 1 },
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
        confidence_needed: 0,
        description: "Add 1 to confidence",
        type: :starter,
        effect: { :add_confidence, 1 },
        title: "Basic Spot"
      }

  """
  def new(type) do
    case type do
      :chant -> %Card{
        type: :gimmick,
        title: "Crowd Chant",
        description: "The crowd starts chanting for the babyface (+2 confidence)",
        effect: { :add_confidence, 2 },
        confidence_needed: 2
      }
      :comeback -> %Card{
        type: :gimmick,
        title: "Thrilling Comeback",
        description: "This could be the opening you've been waiting for! (+2 excitement)",
        effect: { :add_excitement, 2 },
        confidence_needed: 5
      }
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
        effect: { :add_excitement, 1 },
        confidence_needed: 3
      }
      :starter -> %Card{
        type: :starter,
        title: "Basic Spot",
        description: "Add 1 to confidence",
        effect: { :add_confidence, 1 },
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
        Enum.map(0..12, fn _x -> Card.new(:gimmick) end)
        ++ Enum.map(0..3, fn _x -> Card.new(:chant) end)
        ++ Enum.map(0..2, fn _x -> Card.new(:comeback) end)
        |> shuffle_cards
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
    Selects a card from a set. Returns a tuple containing two lists: the card drawn and the remainder of the set.

  ## Examples

      iex> set = [Card.new(:starter), Card.new(:gimmick), Card.new(:event)]
      iex> { card, _remaining_set } = Card.select(set, 1)
      iex> card.type
      :gimmick

  """
  def select(set, index \\ 0) do
    List.pop_at(set, index)
  end

  @doc ~S"""
    Shuffles cards.

  ## Examples

      iex> cards = Enum.map(0..5, fn x -> "Card #{x}" end)
      iex> shuffled_cards = Card.shuffle_cards(cards)
      iex> cards == shuffled_cards
      false

  """
  def shuffle_cards(cards) do
    Enum.shuffle(cards)
  end
end
