class CardSearch::Lexer
  def lex(string)
    state = :blank
    current_letters = ""
    completed_tokens = []

    string.each_char do |letter|
      case state
      when :blank
        if letter.present?
          current_letters << letter
          if letter == '"'
            state = :quoted_term
          elsif letter == '!'
            state = :exact_name
          else
            state = :term
          end
        end
      when :exact_name
        current_letters << letter
      when :quoted_term
        current_letters << letter
        if letter == '"'
          completed_tokens << current_letters
          state = :blank
          current_letters = ""
        end
      when :term
        if letter == '"'
          current_letters << letter
          state = :quoted_term
        elsif letter.blank?
          completed_tokens << current_letters
          state = :blank
          current_letters = ""
        else
          current_letters << letter
        end
      end
    end

    completed_tokens << current_letters

    completed_tokens
  end
end
