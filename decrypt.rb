class Decrypt
  ALPHABET = %w(a b c d e f g h i j k l m n o p q r s t u v w x y z)
  ALPHABET_BY_FREQUENCY = %w(e t a o i n s h r d l c u m w f g y p b v k j x q z)

  def initialize(input)
    @input = input.downcase.strip
  end

  def decrypt
    letter_frequencies = count_letter_frequencies @input
    substitutions = determine_substitutions letter_frequencies
    letter_indices = get_letter_indices @input
    perform_substitutions @input, substitutions, letter_indices
  end

  private

  def count_letter_frequencies(text, alphabet = ALPHABET)
    alphabet.inject({}) do |memo, letter|
      memo[letter] = text.count(letter)
      memo
    end
  end

  def determine_substitutions(letter_frequencies, alphabet_by_frequency = ALPHABET_BY_FREQUENCY)
    letters_by_frequency = letter_frequencies.sort_by{|letter, frequency| frequency}.reverse.map(&:first)
    # Inject with index :)
    letters_by_frequency.each_with_index.inject({}) do |substitutions, (letter, index)|
      substitutions[letter] = alphabet_by_frequency[index]
      substitutions
    end
  end

  def get_letter_indices(text, alphabet = ALPHABET)
    # Can't just substitute each letter, as we would erroneously
    # substitute letters that have just been substituted in.
    # Instead, go by index of each letter.
    alphabet.inject({}) do |memo, letter|
      memo[letter] = text.to_enum(:scan, Regexp.new(letter)).map do
        # $` = the string up to the match.
        $`.size
      end
      memo
    end
  end

  def perform_substitutions(text, substitutions, letter_indices)
    substitutions.each do |original_letter, replacement_letter|
      letter_indices[original_letter].each do |index|
        text[index] = replacement_letter
      end
    end
    text
  end
end

# # # # # # # #
# Control flow.
# # # # # # # #

input_file = ARGV[0]
input_text = File.open(input_file, "rb").read

puts Decrypt.new(input_text).decrypt
