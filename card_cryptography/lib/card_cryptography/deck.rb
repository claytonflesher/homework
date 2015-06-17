module Cipher
  class Deck
    def initialize
      @cards = Array.new(52)
    end
    attr_reader :cards
    private     :cards

    def build(shuffle = false)
      @cards.fill { |i| (i + 1) }
      @cards << "A"
      @cards << "B"
      if shuffle
        @cards.shuffle!
      end
      return cards
    end

    def move_a_joker
      build
      start = cards.index("A")
      if cards[-1] == "A"
        @cards.pop.unshift("A")
      else
        @cards.delete("A")
        @cards.insert((start + 1), "A")
      end
      return cards
    end

    def move_b_joker
      move_a_joker
      start = cards.index("B")
      if cards[-2..-1].include?("B")
        b_at_end
      else
        @cards.delete("B")
        @cards.insert((start + 2), "B")
      end
      return cards
    end

    def triple_cut
      move_b_joker
      first_group = build_first_group
      last_group  = build_last_group
      @cards.delete_if { |card| first_group.include?(card) || last_group.include?(card) }
      @cards.unshift(last_group)
      @cards << first_group
      @cards.flatten!
    end

    private

    def b_at_end
      if cards[-1] == "B"
        @cards.delete("B")
        @cards.insert(2, "B")
      else
        @cards.delete("B")
        @cards.insert(1, "B")
      end
    end

    def build_first_group
      if cards.index("A") < cards.index("B")
        first_group = cards[0..cards.index("A")]
        first_group.delete("A")
      else
        first_group = cards[0..cards.index("B")]
        first_group.delete("B")
      end
      first_group
    end

    def build_last_group
      if cards.index("A") > cards.index("B")
        last_group = cards[cards.index("A")..-1]
        last_group.delete("A")
      else
        last_group = cards[cards.index("B")..-1]
        last_group.delete("B")
      end
      last_group
    end
  end
end
