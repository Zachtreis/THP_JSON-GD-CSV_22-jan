class Index
    def self.prompt_choice
      #creat a nice menu using the gem TTY-prompt
      prompt = TTY::Prompt.new
      #list of available choices
      choices = {'JSON' => 1, 'Google Sheets' => 2, 'CSV' => 3}
      answer = prompt.select('Choose in which format do you want to save the scrapped data?', choices, help: '(Use arrow keys to choose your answer and Enter to validate)')
      puts "*" * 60
      return answer
    end
  end