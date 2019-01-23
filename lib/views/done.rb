
class Done
    def self.prompt
      #creat a nice menu using the gem TTY-prompt
      prompt = TTY::Prompt.new
      #list of available choices
      choices = {'Continue' => 1, 'Stop' => 2}
      answer = prompt.select('What do you want to do now ?', choices, help: '(Use arrow keys and Enter to finish)')
      return answer
    end
  end